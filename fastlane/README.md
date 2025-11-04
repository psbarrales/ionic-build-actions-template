fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android build_debug

```sh
[bundle exec] fastlane android build_debug
```

Build Debug APK

### android build_release

```sh
[bundle exec] fastlane android build_release
```

Build Release APK

### android build_aab

```sh
[bundle exec] fastlane android build_aab
```

Build Release AAB (Android App Bundle)

### android upload_to_store

```sh
[bundle exec] fastlane android upload_to_store
```

Upload to Google Play Store

### android upload_internal

```sh
[bundle exec] fastlane android upload_internal
```

Upload to Internal Testing

### android upload_alpha

```sh
[bundle exec] fastlane android upload_alpha
```

Upload to Alpha Testing

### android upload_beta

```sh
[bundle exec] fastlane android upload_beta
```

Upload to Beta Testing

### android upload_production

```sh
[bundle exec] fastlane android upload_production
```

Upload to Production

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Complete workflow: Build and upload to specified track

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
