#!/bin/bash

# Script para preparar secretos de GitHub Actions
# Este script convierte el keystore a base64 y te muestra qué secretos configurar

echo "🔐 Preparando secretos para GitHub Actions..."
echo "============================================="

# Verificar que existe el keystore
if [ ! -f "android/app/release-key.jks" ]; then
    echo "❌ Error: No se encontró el keystore en android/app/release-key.jks"
    echo "Ejecuta primero: keytool -genkey -v -keystore android/app/release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release-key"
    exit 1
fi

echo "✅ Keystore encontrado: android/app/release-key.jks"
echo ""

# Convertir keystore a base64
echo "📋 Copiando keystore en base64 al clipboard..."
KEYSTORE_BASE64=$(base64 -i android/app/release-key.jks)

# Para macOS usar pbcopy, para Linux usar xclip
if command -v pbcopy &> /dev/null; then
    echo "$KEYSTORE_BASE64" | pbcopy
    echo "✅ Keystore base64 copiado al clipboard (macOS)"
elif command -v xclip &> /dev/null; then
    echo "$KEYSTORE_BASE64" | xclip -selection clipboard
    echo "✅ Keystore base64 copiado al clipboard (Linux)"
else
    echo "⚠️  No se pudo copiar al clipboard. Aquí está el base64:"
    echo "$KEYSTORE_BASE64"
fi

echo ""
echo "🔧 SECRETOS DE GITHUB ACTIONS REQUERIDOS:"
echo "=========================================="
echo ""
echo "Ve a tu repositorio de GitHub:"
echo "Settings > Secrets and variables > Actions > New repository secret"
echo ""
echo "1. ANDROID_KEYSTORE_BASE64"
echo "   Valor: [El base64 del keystore - ya está en tu clipboard]"
echo ""
echo "2. ANDROID_KEYSTORE_PASSWORD"
echo "   Valor: demodemo"
echo ""
echo "3. ANDROID_KEY_ALIAS" 
echo "   Valor: release-key"
echo ""
echo "4. ANDROID_KEY_PASSWORD"
echo "   Valor: demodemo"
echo ""
echo "📝 OPCIONAL - Para futuras integraciones con Google Play:"
echo "========================================================"
echo ""
echo "5. GOOGLE_PLAY_JSON_KEY_DATA"
echo "   Valor: [JSON completo de la service account de Google Play]"
echo ""
echo "6. GOOGLE_PLAY_TRACK"
echo "   Valor: internal"
echo ""
echo "🎯 TESTING DEL WORKFLOW:"
echo "========================"
echo ""
echo "Para probar el workflow, crea tags con estos formatos:"
echo ""
echo "# Build debug APK (genera draft release)"
echo "git tag v1.0.0-debug"
echo "git push origin v1.0.0-debug"
echo ""
echo "# Build release AAB (genera release público)"
echo "git tag v1.0.0-release"  
echo "git push origin v1.0.0-release"
echo ""
echo "# Build beta AAB (genera pre-release)"
echo "git tag v1.0.0-beta"
echo "git push origin v1.0.0-beta"
echo ""
echo "🏗️ ESTRUCTURA DE BUILDS:"
echo "========================"
echo ""
echo "- Tags con '-debug': Genera APK debug + GitHub Release (draft)"
echo "- Tags con '-release': Genera AAB release + GitHub Release (público)"
echo "- Tags con '-beta': Genera AAB beta + GitHub Release (pre-release)"
echo "- Cualquier push: Solo build web (obligatorio)"
echo ""
echo "✅ ¡Todo listo! Configura los secretos en GitHub y prueba con un tag."