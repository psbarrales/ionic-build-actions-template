#!/bin/bash

# Script para verificar la configuración del workflow de GitHub Actions
# Autor: GitHub Copilot Assistant
# Fecha: $(date)

set -e

echo "🔍 Verificando configuración del workflow de GitHub Actions..."

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar mensajes con colores
print_status() {
    local status=$1
    local message=$2
    
    case $status in
        "success")
            echo -e "${GREEN}✅ $message${NC}"
            ;;
        "warning")
            echo -e "${YELLOW}⚠️  $message${NC}"
            ;;
        "error")
            echo -e "${RED}❌ $message${NC}"
            ;;
        "info")
            echo -e "${BLUE}ℹ️  $message${NC}"
            ;;
    esac
}

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ] || [ ! -d ".github/workflows" ]; then
    print_status "error" "Este script debe ejecutarse desde la raíz del proyecto Ionic"
    exit 1
fi

print_status "info" "Verificando archivos del workflow..."

# Verificar que existe el archivo de workflow
if [ -f ".github/workflows/build.yml" ]; then
    print_status "success" "Archivo de workflow encontrado: .github/workflows/build.yml"
else
    print_status "error" "No se encontró el archivo .github/workflows/build.yml"
    exit 1
fi

# Verificar configuración de permisos en el workflow
if grep -q "permissions:" .github/workflows/build.yml; then
    print_status "success" "Permisos configurados en el workflow"
else
    print_status "error" "Falta configuración de permisos en el workflow"
fi

# Verificar que usa la acción correcta para releases
if grep -q "softprops/action-gh-release" .github/workflows/build.yml; then
    print_status "success" "Usando action-gh-release moderna"
else
    print_status "warning" "No se encontró action-gh-release, verificar configuración"
fi

# Verificar configuración de Android SDK
if grep -q "Setup Android SDK" .github/workflows/build.yml; then
    print_status "success" "Configuración de Android SDK encontrada"
else
    print_status "error" "Falta configuración de Android SDK"
fi

# Verificar que existe Fastfile
if [ -f "fastlane/Fastfile" ]; then
    print_status "success" "Fastfile encontrado"
else
    print_status "error" "No se encontró fastlane/Fastfile"
    exit 1
fi

# Verificar configuración de keystore
if [ -f "android/app/release-key.jks" ]; then
    print_status "success" "Keystore local encontrado: android/app/release-key.jks"
else
    print_status "warning" "No se encontró keystore local (android/app/release-key.jks)"
fi

# Verificar configuración de Gradle
if [ -f "android/app/build.gradle" ]; then
    if grep -q "signingConfigs" android/app/build.gradle; then
        print_status "success" "Configuración de signing en build.gradle"
    else
        print_status "warning" "Falta configuración de signing en build.gradle"
    fi
else
    print_status "error" "No se encontró android/app/build.gradle"
fi

echo ""
print_status "info" "🔐 Secrets requeridos en GitHub:"
echo "   - ANDROID_KEYSTORE_BASE64"
echo "   - ANDROID_KEYSTORE_PASSWORD"
echo "   - ANDROID_KEY_ALIAS"
echo "   - ANDROID_KEY_PASSWORD"

echo ""
print_status "info" "🏷️ Tipos de tags soportados:"
echo "   - *-debug: Genera APK debug"
echo "   - *-release: Genera AAB release"
echo "   - *-beta: Genera AAB beta (draft)"

echo ""
print_status "info" "📋 Ejemplos de tags:"
echo "   git tag v1.0.0-debug && git push origin v1.0.0-debug"
echo "   git tag v1.0.0-release && git push origin v1.0.0-release"
echo "   git tag v1.0.0-beta && git push origin v1.0.0-beta"

# Verificar si hay commits pendientes
if [ -n "$(git status --porcelain)" ]; then
    print_status "warning" "Hay cambios sin commitear en el repositorio"
    echo ""
    git status --short
else
    print_status "success" "Repositorio limpio, listo para hacer tags"
fi

echo ""
print_status "success" "✨ Verificación completada"

# Mostrar información adicional si es necesario
echo ""
print_status "info" "💡 Para probar el workflow:"
echo "   1. Commit y push de los cambios actuales"
echo "   2. Crear un tag de prueba: git tag v1.0.0-debug"
echo "   3. Push del tag: git push origin v1.0.0-debug"
echo "   4. Verificar en GitHub Actions: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"