#!/bin/bash

# Script de configuración inicial para Fastlane en aplicación Ionic
echo "🚀 Configurando entorno para Fastlane..."

# Verificar si Fastlane está instalado
if ! command -v fastlane &> /dev/null; then
    echo "❌ Fastlane no está instalado."
    echo "Por favor, instálalo con uno de estos comandos:"
    echo "  brew install fastlane"
    echo "  sudo gem install fastlane"
    exit 1
fi

echo "✅ Fastlane está instalado"

# Crear directorio builds si no existe
mkdir -p builds
echo "✅ Directorio builds creado"

# Verificar dependencias de Node
if [ ! -d "node_modules" ]; then
    echo "📦 Instalando dependencias de Node..."
    npm install
fi

# Sincronizar Capacitor
echo "⚡ Sincronizando Capacitor..."
npx cap sync android

# Verificar si existe el archivo .env
if [ ! -f ".env" ]; then
    echo "📝 Copiando archivo de ejemplo .env..."
    cp .env.example .env
    echo "⚠️  Por favor, edita el archivo .env con tus configuraciones reales"
fi

# Mostrar lanes disponibles
echo ""
echo "🎉 Configuración completada!"
echo ""
echo "Lanes disponibles:"
echo "  fastlane android build_debug      # Construir APK debug"
echo "  fastlane android build_release    # Construir APK release"
echo "  fastlane android build_aab        # Construir Android App Bundle"
echo "  fastlane android upload_to_store  # Subir a Google Play Store"
echo "  fastlane android upload_internal  # Subir a Internal Testing"
echo "  fastlane android upload_alpha     # Subir a Alpha Testing"
echo "  fastlane android upload_beta      # Subir a Beta Testing"
echo "  fastlane android deploy           # Workflow completo"
echo ""
echo "O usando npm scripts:"
echo "  npm run android:build:debug"
echo "  npm run android:build:release"
echo "  npm run android:deploy"
echo ""
echo "📚 Lee el archivo fastlane/README.md para más información"