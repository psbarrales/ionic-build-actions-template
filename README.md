# 📱 Ionic App Build - CI/CD with GitHub Actions

Una aplicación Ionic con workflow completo de CI/CD usando GitHub Actions y Fastlane para builds automatizados.

## 🚀 Features

- ✅ **Builds automatizados** en GitHub Actions
- ✅ **Múltiples tipos de build**: Debug APK, Release AAB, Beta AAB
- ✅ **Releases automáticos** en GitHub con artifacts
- ✅ **Fastlane integration** para builds nativos
- ✅ **Keystore management** seguro con base64
- ✅ **Tag-based deployment** strategy

## 🏗️ Estructura del Proyecto

```
ionic-app-build/
├── .github/
│   └── workflows/
│       └── build.yml           # GitHub Actions workflow
├── fastlane/
│   ├── Fastfile               # Configuración Fastlane
│   ├── Appfile               # Settings de la app
│   └── README.md             # Documentación Fastlane
├── scripts/
│   └── setup-github-secrets.sh # Helper para secretos
├── docs/
│   └── GITHUB_ACTIONS.md     # Documentación completa CI/CD
├── src/                      # Código fuente Ionic
├── android/                  # Proyecto Android/Capacitor
├── builds/                   # Builds locales (gitignored)
└── .env                      # Variables de entorno (gitignored)
```

## ⚡ Quick Start

### 1. 🔧 Setup Local

```bash
# Clonar y instalar dependencias
git clone <repo-url>
cd ionic-app-build
npm install

# Setup environment
cp .env.template .env
# Editar .env con tus valores

# Build local
npm run build
npm run android:build:debug
```

### 2. 🔐 Setup GitHub Actions

```bash
# Preparar secretos para GitHub
./scripts/setup-github-secrets.sh

# Configurar secretos en GitHub:
# Settings > Secrets and variables > Actions
# - ANDROID_KEYSTORE_BASE64
# - ANDROID_KEYSTORE_PASSWORD  
# - ANDROID_KEY_ALIAS
# - ANDROID_KEY_PASSWORD
```

### 3. 🏷️ Deploy con Tags

```bash
# Debug APK (Draft Release)
git tag v1.0.0-debug
git push origin v1.0.0-debug

# Release AAB (Public Release)
git tag v1.0.0-release  
git push origin v1.0.0-release

# Beta AAB (Pre-release)
git tag v1.0.0-beta
git push origin v1.0.0-beta
```

## 📋 Comandos Disponibles

### 🌐 Web Development
```bash
npm run build          # Build web application
npm run dev            # Development server
npm run preview        # Preview build
```

### 📱 Mobile Development  
```bash
# Fastlane builds
npm run android:build:debug     # Debug APK
npm run android:build:release   # Release APK firmado
npm run android:build:aab       # Android App Bundle

# Upload (futuro)
npm run android:upload:store    # Upload to Google Play Store
```

### 🔧 Development Tools
```bash
npx cap sync android            # Sync Capacitor
npx cap copy android            # Copy web assets
npx cap open android            # Open Android Studio
```

## 🤖 GitHub Actions Workflow

### 🔄 Triggers

| Evento | Build Web | Build Mobile | GitHub Release |
|--------|-----------|-------------|----------------|
| Push a main/develop | ✅ | ❌ | ❌ |
| Pull Request | ✅ | ❌ | ❌ |
| Tag `*-debug` | ✅ | APK Debug | Draft |
| Tag `*-release` | ✅ | AAB Release | Public |
| Tag `*-beta` | ✅ | AAB Beta | Pre-release |

### 📊 Build Matrix

| Build Type | File Format | Signed | Target | Release Type |
|------------|-------------|--------|--------|--------------|
| Debug | APK | ❌ | Testing | Draft |
| Release | AAB | ✅ | Google Play | Public |
| Beta | AAB | ✅ | Testing | Pre-release |

## 🔐 Security

- 🔒 **Keystore**: Almacenado como base64 en GitHub Secrets
- 🔒 **Passwords**: Configurados en GitHub Secrets
- 🔒 **.env**: Never committed (gitignored)
- 🔒 **Service Accounts**: JSON keys en secrets

## 📚 Documentación

- **[GitHub Actions Workflow](docs/GITHUB_ACTIONS.md)** - Documentación completa del CI/CD
- **[Fastlane Setup](fastlane/README.md)** - Configuración y uso de Fastlane
- **[Environment Setup](.env.template)** - Template de variables de entorno

## 🛠️ Tech Stack

- **Framework**: Ionic 7 + Capacitor 7
- **Runtime**: Node.js 20, Java 17  
- **CI/CD**: GitHub Actions
- **Build Tool**: Fastlane 2.228.0
- **Package Manager**: npm
- **Mobile Platform**: Android

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-feature`
3. Commit changes: `git commit -m 'Add new feature'`
4. Push to branch: `git push origin feature/new-feature`
5. Create Pull Request

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

## 🆘 Support

- 📖 **Documentation**: [docs/GITHUB_ACTIONS.md](docs/GITHUB_ACTIONS.md)
- 🐛 **Issues**: GitHub Issues tab
- 💬 **Discussions**: GitHub Discussions tab

---

**Built with ❤️ using Ionic, Fastlane, and GitHub Actions**