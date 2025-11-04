# 🚀 GitHub Actions CI/CD para Ionic App

Este repositorio incluye workflows automatizados de GitHub Actions para build y release de aplicaciones móviles con Ionic y Capacitor.

## 📋 Workflow Overview

### 🔄 Triggers

| Evento | Acción | Resultado |
|--------|--------|-----------|
| Push a `main` o `develop` | Build web | Artifacts web guardados |
| Pull Request a `main` | Build web | Validación del código |
| Tag `*-debug` | Build APK debug | GitHub Release (draft) + `app-debug.VERSION.apk` |
| Tag `*-release` | Build AAB release | GitHub Release (público) + `app-release.VERSION.aab` |
| Tag `*-beta` | Build AAB beta | GitHub Release (pre-release) + `app-beta.VERSION.aab` |

### 🏗️ Jobs

#### 1. `build-web` (Obligatorio)
- ✅ Runs en: **Todos los push**
- 🔧 Setup: Node.js 20, dependencias npm
- 📦 Output: Artifacts web en `dist/`
- ⏱️ Retention: 7 días

#### 2. `build-mobile` (Condicional)
- ✅ Runs en: **Solo tags**
- 🔧 Setup: Node.js 20, Java 17, Ruby 3.2, Android SDK
- 📱 Builds: APK (debug) o AAB (release/beta)
- 🔐 Keystore: Decodificado desde secrets
- 📦 Output: GitHub Release + archivo adjunto
- ⏱️ Retention: 30 días

#### 3. `cleanup` (Siempre)
- ✅ Runs en: **Siempre al final**
- 📊 Genera resumen de builds
- 🧹 Cleanup de artifacts temporales

## 🔐 Secretos Requeridos

Ve a **Settings > Secrets and variables > Actions** en tu repositorio y configura:

### 📱 Android Signing (Obligatorio para release/beta)

| Secret | Valor | Descripción |
|--------|-------|-------------|
| `ANDROID_KEYSTORE_BASE64` | [Base64 del keystore] | Keystore firmado convertido a base64 |
| `ANDROID_KEYSTORE_PASSWORD` | `demodemo` | Contraseña del keystore |
| `ANDROID_KEY_ALIAS` | `release-key` | Alias de la clave en el keystore |
| `ANDROID_KEY_PASSWORD` | `demodemo` | Contraseña de la clave específica |

### 🏪 Google Play Store (Opcional - para futuro)

| Secret | Valor | Descripción |
|--------|-------|-------------|
| `GOOGLE_PLAY_JSON_KEY_DATA` | `{JSON completo}` | Service Account key de Google Play Console |
| `GOOGLE_PLAY_TRACK` | `internal` | Track por defecto (internal/alpha/beta/production) |

## 🎯 Uso del Workflow

### 1. 📋 Configuración Inicial

```bash
# 1. Ejecutar script de preparación
./scripts/setup-github-secrets.sh

# 2. Copiar el base64 del keystore (ya está en clipboard)
# 3. Ir a GitHub > Settings > Secrets > Actions
# 4. Crear los 4 secretos de Android
```

### 2. 🏷️ Crear Releases

```bash
# Debug APK (Draft Release) → app-debug.v1.0.0.apk
git tag v1.0.0-debug
git push origin v1.0.0-debug

# Release AAB (Public Release) → app-release.v1.0.0.aab
git tag v1.0.0-release
git push origin v1.0.0-release

# Beta AAB (Pre-release) → app-beta.v1.0.0.aab
git tag v1.0.0-beta
git push origin v1.0.0-beta
```

### 3. 📦 Tipos de Build

| Tipo | Formato | Firmado | GitHub Release | Uso |
|------|---------|---------|----------------|-----|
| **Debug** | APK | ❌ No | Draft | Testing interno |
| **Release** | AAB | ✅ Sí | Público | Google Play Store |
| **Beta** | AAB | ✅ Sí | Pre-release | Testing externo |

## 🔍 Monitoring

### 📊 GitHub Actions Dashboard
- Ve a **Actions** tab en tu repositorio
- Monitorea builds en tiempo real
- Descarga artifacts y logs

### 📱 Releases
- Ve a **Releases** tab en tu repositorio  
- Descarga APK/AAB files
- Ve notas de release automáticas

### 🚨 Troubleshooting

#### Build Failures Comunes:

1. **Keystore Error**
   ```
   Keystore file not found for signing config 'release'
   ```
   - ✅ Verifica que `ANDROID_KEYSTORE_BASE64` esté configurado
   - ✅ Verifica que las contraseñas sean correctas

2. **Node/Java Version Error**
   ```
   ENOENT: no such file or directory
   ```
   - ✅ Verifica versiones en `.github/workflows/build.yml`
   - ✅ Asegúrate que `package.json` sea compatible

3. **Capacitor Sync Error**
   ```
   Cap sync failed
   ```
   - ✅ Verifica que el build web sea exitoso primero
   - ✅ Check Capacitor configuration

## 🛠️ Customización

### 🔧 Modificar Versiones

```yaml
env:
  NODE_VERSION: '20'    # Cambiar versión de Node.js
  JAVA_VERSION: '17'    # Cambiar versión de Java
```

### 📱 Agregar Nuevos Build Types

```yaml
# Agregar nuevo tag pattern
on:
  push:
    tags:
      - '*-debug'
      - '*-release' 
      - '*-beta'
      - '*-staging'  # Nuevo tipo
```

### 🚀 Workflows Adicionales

Puedes crear workflows separados para:
- 🧪 **Testing**: Unit tests, E2E tests
- 🔍 **Code Quality**: ESLint, SonarQube
- 📄 **Documentation**: Auto-generate docs
- 🌐 **Deploy Web**: Deploy a CDN/hosting

## 📝 Files Structure

```
.github/
└── workflows/
    └── build.yml           # Main CI/CD workflow

scripts/
└── setup-github-secrets.sh # Helper script para secretos

fastlane/
├── Fastfile               # Fastlane configuration
├── Appfile               # App-specific settings  
└── README.md             # Fastlane documentation

builds/                   # Local builds (gitignored)
android/app/             
└── release-key.jks      # Keystore (gitignored)
```

---

## 🎉 Quick Start

1. **Fork/Clone** este repositorio
2. **Run** `./scripts/setup-github-secrets.sh`
3. **Configure** secretos en GitHub Actions
4. **Push** un tag: `git tag v1.0.0-debug && git push origin v1.0.0-debug`
5. **Watch** el workflow en GitHub Actions tab
6. **Download** tu APK/AAB desde Releases tab

¡Listo! 🚀