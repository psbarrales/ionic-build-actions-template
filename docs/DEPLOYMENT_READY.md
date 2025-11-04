# 🎯 CONFIGURACIÓN COMPLETA - GitHub Actions CI/CD

## ✅ ¿Qué se ha configurado?

### 📁 **Archivos Creados/Modificados:**

1. **`.github/workflows/build.yml`** - Workflow principal de CI/CD
2. **`scripts/setup-github-secrets.sh`** - Script para preparar secretos
3. **`scripts/validate-setup.sh`** - Script de validación del setup  
4. **`docs/GITHUB_ACTIONS.md`** - Documentación completa
5. **`README.md`** - Documentación principal actualizada
6. **`.env.template`** - Template de variables de entorno

### 🔄 **Workflow de GitHub Actions:**

#### **Triggers:**
- ✅ **Push a main/develop**: Build web obligatorio
- ✅ **Pull Request**: Validación del código  
- ✅ **Tags `*-debug`**: Build APK debug + GitHub Release (draft)
- ✅ **Tags `*-release`**: Build AAB release + GitHub Release (público)
- ✅ **Tags `*-beta`**: Build AAB beta + GitHub Release (pre-release)

#### **Jobs:**
1. **`build-web`** (Obligatorio en todos los eventos)
   - Setup Node.js 20
   - Install dependencies
   - Build web application
   - Upload artifacts (7 días retention)

2. **`build-mobile`** (Solo en tags)
   - Setup Node.js 20, Java 17, Ruby 3.2, Android SDK
   - Decode keystore desde secrets
   - Build APK (debug) o AAB (release/beta)
   - Create GitHub Release automático
   - Upload artifacts (30 días retention)

3. **`cleanup`** (Siempre al final)
   - Generate build summary
   - Cleanup temporal artifacts

---

## 🔐 **SECRETOS REQUERIDOS EN GITHUB ACTIONS**

Ve a tu repositorio: **Settings > Secrets and variables > Actions**

### 📱 **Android Signing (Obligatorio para release/beta):**

| Secret Name | Valor | Descripción |
|-------------|-------|-------------|
| `ANDROID_KEYSTORE_BASE64` | [Base64 del keystore] | Keystore convertido a base64 |
| `ANDROID_KEYSTORE_PASSWORD` | `demodemo` | Contraseña del keystore |
| `ANDROID_KEY_ALIAS` | `release-key` | Alias de la clave |
| `ANDROID_KEY_PASSWORD` | `demodemo` | Contraseña de la clave específica |

### 🏪 **Google Play Store (Opcional - para futuro):**

| Secret Name | Valor | Descripción |
|-------------|-------|-------------|
| `GOOGLE_PLAY_JSON_KEY_DATA` | `{JSON completo}` | Service Account de Google Play Console |
| `GOOGLE_PLAY_TRACK` | `internal` | Track por defecto |

---

## 🚀 **CÓMO USARLO**

### 1. **Configurar Secretos:**
```bash
# Ejecutar script que prepara el keystore en base64
./scripts/setup-github-secrets.sh

# El base64 del keystore ya está copiado al clipboard
# Ir a GitHub > Settings > Secrets > Actions
# Crear los 4 secretos de Android con los valores mostrados
```

### 2. **Testing Local (Opcional):**
```bash
# Validar configuración
./scripts/validate-setup.sh

# Test build local
npm run android:build:debug
```

### 3. **Deploy con Tags:**
```bash
# Para APK Debug (GitHub Release como draft)
git tag v1.0.0-debug
git push origin v1.0.0-debug

# Para AAB Release (GitHub Release público)
git tag v1.0.0-release
git push origin v1.0.0-release

# Para AAB Beta (GitHub Release como pre-release)
git tag v1.0.0-beta
git push origin v1.0.0-beta
```

### 4. **Monitoreo:**
- **GitHub Actions**: Tab "Actions" en tu repositorio
- **Releases**: Tab "Releases" en tu repositorio
- **Artifacts**: Disponibles por 7-30 días según el tipo

---

## 📊 **MATRIZ DE BUILDS**

| Tag Pattern | Tipo Build | Archivo | Firmado | GitHub Release | Uso |
|-------------|------------|---------|---------|----------------|-----|
| `*-debug` | APK | `.apk` | ❌ No | Draft | Testing interno |
| `*-release` | AAB | `.aab` | ✅ Sí | Público | Google Play Store |
| `*-beta` | AAB | `.aab` | ✅ Sí | Pre-release | Testing externo |

---

## 🎯 **EJEMPLOS DE TAGS**

```bash
# Semantic Versioning + Type
git tag v1.0.0-debug    # Primera versión debug
git tag v1.0.1-release  # Patch release 
git tag v1.1.0-beta     # Minor version beta
git tag v2.0.0-release  # Major version release

# Con descripciones
git tag -a v1.0.0-debug -m "Initial debug build"
git tag -a v1.0.0-release -m "First production release"
git tag -a v1.0.1-beta -m "Beta with new features"
```

---

## 🔍 **TROUBLESHOOTING**

### **Build Failures Comunes:**

1. **Keystore Error:**
   ```
   Keystore file not found for signing config 'release'
   ```
   - ✅ Verificar `ANDROID_KEYSTORE_BASE64` en GitHub Secrets
   - ✅ Verificar passwords en secrets

2. **Java/Node Version Error:**
   ```
   ENOENT: no such file or directory
   ```
   - ✅ Verificar versiones en workflow
   - ✅ Verificar compatibilidad de package.json

3. **Capacitor Sync Error:**
   ```
   Cap sync failed
   ```
   - ✅ Verificar que build web sea exitoso
   - ✅ Check Capacitor configuration

### **Validación Pre-Deploy:**
```bash
# Ejecutar siempre antes de crear tags
./scripts/validate-setup.sh
```

---

## ⚡ **PRÓXIMAS FEATURES (Futuro)**

- 🔄 **Upload to Google Play Store** automático
- 🧪 **Testing integration** (Unit + E2E)
- 🔍 **Code Quality checks** (ESLint, SonarQube)
- 📱 **iOS support** con fastlane
- 🌐 **Web deployment** a CDN
- 📧 **Slack/Discord notifications**

---

## 🎉 **ESTADO ACTUAL**

✅ **Web Build**: Automático en todos los push  
✅ **Mobile Build**: Automático en tags  
✅ **GitHub Releases**: Automático con artifacts  
✅ **Security**: Keystore en secrets base64  
✅ **Documentation**: Completa y actualizada  
✅ **Validation**: Scripts de verificación  

**🚀 ¡LISTO PARA USAR!**

---

**Siguiente paso**: Configurar los secretos en GitHub y hacer tu primer deploy con un tag. 🏷️