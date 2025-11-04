#!/bin/bash

# Script para validar la configuración del proyecto antes del deploy
echo "🔍 Validando configuración del proyecto..."
echo "============================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

SUCCESS=0
WARNINGS=0
ERRORS=0

# Helper functions
success() {
    echo -e "${GREEN}✅ $1${NC}"
    ((SUCCESS++))
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
    ((WARNINGS++))
}

error() {
    echo -e "${RED}❌ $1${NC}"
    ((ERRORS++))
}

echo ""
echo "📦 Verificando dependencias..."
echo "------------------------------"

# Check Node.js
if command -v node &> /dev/null; then
    NODE_VERSION=$(node --version)
    success "Node.js: $NODE_VERSION"
else
    error "Node.js no está instalado"
fi

# Check npm
if command -v npm &> /dev/null; then
    NPM_VERSION=$(npm --version)
    success "npm: $NPM_VERSION"
else
    error "npm no está instalado"
fi

# Check Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n 1)
    success "Java: $JAVA_VERSION"
else
    error "Java no está instalado (requerido para Android builds)"
fi

# Check Fastlane
if command -v fastlane &> /dev/null; then
    FASTLANE_VERSION=$(fastlane --version | head -n 1)
    success "Fastlane: $FASTLANE_VERSION"
else
    warning "Fastlane no está instalado globalmente (se instalará en CI)"
fi

echo ""
echo "📁 Verificando estructura del proyecto..."
echo "-----------------------------------------"

# Check required files
FILES=(
    "package.json"
    "ionic.config.json"
    "capacitor.config.ts"
    ".github/workflows/build.yml"
    "fastlane/Fastfile"
    "fastlane/Appfile"
    "scripts/setup-github-secrets.sh"
    ".env.template"
)

for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        success "Archivo: $file"
    else
        error "Archivo faltante: $file"
    fi
done

# Check directories
DIRS=(
    "src"
    "android"
    "fastlane"
    ".github/workflows"
    "scripts"
)

for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        success "Directorio: $dir"
    else
        error "Directorio faltante: $dir"
    fi
done

echo ""
echo "🔐 Verificando configuración de seguridad..."
echo "---------------------------------------------"

# Check .env
if [ -f ".env" ]; then
    success "Archivo .env existe"
    
    # Check if it has the required variables
    if grep -q "ANDROID_KEYSTORE_PATH" .env; then
        success "Variable ANDROID_KEYSTORE_PATH configurada"
    else
        warning "Variable ANDROID_KEYSTORE_PATH no encontrada en .env"
    fi
    
    if grep -q "ANDROID_KEYSTORE_PASSWORD" .env; then
        success "Variable ANDROID_KEYSTORE_PASSWORD configurada"
    else
        warning "Variable ANDROID_KEYSTORE_PASSWORD no encontrada en .env"
    fi
else
    warning "Archivo .env no existe (copiar desde .env.template)"
fi

# Check keystore
if [ -f "android/app/release-key.jks" ]; then
    success "Keystore existe: android/app/release-key.jks"
    
    # Check keystore size (should be > 1KB)
    KEYSTORE_SIZE=$(stat -c%s "android/app/release-key.jks" 2>/dev/null || stat -f%z "android/app/release-key.jks" 2>/dev/null)
    if [ "$KEYSTORE_SIZE" -gt 1000 ]; then
        success "Keystore tiene tamaño válido: $KEYSTORE_SIZE bytes"
    else
        warning "Keystore parece demasiado pequeño: $KEYSTORE_SIZE bytes"
    fi
else
    warning "Keystore no existe (se generará automáticamente o usar existente)"
fi

# Check gitignore
if grep -q "release-key.jks" .gitignore; then
    success "Keystore está en .gitignore"
else
    warning "release-key.jks no está en .gitignore"
fi

if grep -q ".env" .gitignore; then
    success "Archivo .env está en .gitignore"
else
    warning ".env no está en .gitignore"
fi

echo ""
echo "🔧 Verificando configuración de build..."
echo "----------------------------------------"

# Check package.json scripts
if grep -q "android:build:debug" package.json; then
    success "Script android:build:debug configurado"
else
    error "Script android:build:debug no encontrado en package.json"
fi

if grep -q "android:build:release" package.json; then
    success "Script android:build:release configurado"
else
    error "Script android:build:release no encontrado en package.json"
fi

if grep -q "android:build:aab" package.json; then
    success "Script android:build:aab configurado"
else
    error "Script android:build:aab no encontrado en package.json"
fi

# Check if npm install was run
if [ -d "node_modules" ]; then
    success "Dependencias npm instaladas"
else
    warning "Dependencias npm no instaladas (ejecutar: npm install)"
fi

echo ""
echo "🚀 Verificando GitHub Actions..."
echo "--------------------------------"

# Check workflow file structure
if grep -q "build-web" .github/workflows/build.yml; then
    success "Job build-web configurado"
else
    error "Job build-web no encontrado en workflow"
fi

if grep -q "build-mobile" .github/workflows/build.yml; then
    success "Job build-mobile configurado"
else
    error "Job build-mobile no encontrado en workflow"
fi

if grep -q "ANDROID_KEYSTORE_BASE64" .github/workflows/build.yml; then
    success "Secret ANDROID_KEYSTORE_BASE64 referenciado"
else
    error "Secret ANDROID_KEYSTORE_BASE64 no referenciado en workflow"
fi

# Check for tag triggers
if grep -q "*-debug" .github/workflows/build.yml; then
    success "Trigger para tags debug configurado"
else
    error "Trigger para tags debug no encontrado"
fi

if grep -q "*-release" .github/workflows/build.yml; then
    success "Trigger para tags release configurado"
else
    error "Trigger para tags release no encontrado"
fi

if grep -q "*-beta" .github/workflows/build.yml; then
    success "Trigger para tags beta configurado"
else
    error "Trigger para tags beta no encontrado"
fi

echo ""
echo "📊 RESUMEN DE VALIDACIÓN"
echo "========================"
echo -e "${GREEN}✅ Exitosos: $SUCCESS${NC}"
echo -e "${YELLOW}⚠️  Advertencias: $WARNINGS${NC}"
echo -e "${RED}❌ Errores: $ERRORS${NC}"

echo ""
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}🎉 ¡Proyecto listo para deploy!${NC}"
    echo ""
    echo "📋 Próximos pasos:"
    echo "1. Configurar secretos en GitHub Actions:"
    echo "   ./scripts/setup-github-secrets.sh"
    echo ""
    echo "2. Hacer un test build local:"
    echo "   npm run android:build:debug"
    echo ""
    echo "3. Crear tu primer tag:"
    echo "   git tag v1.0.0-debug"
    echo "   git push origin v1.0.0-debug"
    echo ""
    echo "4. Monitorear el workflow en GitHub Actions"
else
    echo -e "${RED}🚨 Hay errores que deben corregirse antes del deploy${NC}"
    echo ""
    echo "🔧 Acciones recomendadas:"
    if [ ! -d "node_modules" ]; then
        echo "- Ejecutar: npm install"
    fi
    if [ ! -f ".env" ]; then
        echo "- Crear archivo .env: cp .env.template .env"
    fi
    if [ ! -f "android/app/release-key.jks" ]; then
        echo "- Generar keystore o copiar existente"
    fi
fi

exit $ERRORS