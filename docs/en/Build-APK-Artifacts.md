# Build APK Artifacts Workflow

This workflow provides automated APK artifact generation for the Termux application.

## Features

- **Manual Trigger**: Use workflow_dispatch to manually trigger builds with custom package variant selection
- **Automatic Builds**: Automatically builds APKs when build-related files are pushed to master branch
- **Multi-Architecture Support**: Builds APKs for all supported architectures:
  - Universal (all architectures)
  - ARM64-v8a
  - ARMeabi-v7a
  - x86_64
  - x86
- **Package Variants**: Supports both apt-android-7 and apt-android-5 variants
- **Artifacts**: All built APKs are uploaded as GitHub Actions artifacts with SHA256 checksums

## Usage

### Manual Trigger

1. Go to the Actions tab in the GitHub repository
2. Select "Build APK Artifacts" workflow
3. Click "Run workflow"
4. Choose the package variant:
   - `both` - Build both apt-android-7 and apt-android-5 (default)
   - `apt-android-7` - Build only apt-android-7 variant
   - `apt-android-5` - Build only apt-android-5 variant
5. Click "Run workflow" to start the build

### Automatic Trigger

The workflow automatically runs when changes are pushed to the master branch that affect:
- `app/**`
- `terminal-view/**`
- `terminal-emulator/**`
- `termux-shared/**`
- `*.gradle`
- `gradle/**`

## Downloading Artifacts

After the workflow completes:

1. Go to the workflow run page
2. Scroll down to the "Artifacts" section
3. Download the desired APK artifacts:
   - `termux-app_<version>_universal.apk` - Universal APK (recommended for most users)
   - `termux-app_<version>_<architecture>.apk` - Architecture-specific APKs
   - `termux-app_<version>_sha256sums` - SHA256 checksums for verification

## Workflow Details

- **Runner**: ubuntu-latest
- **Build Type**: Debug
- **Java Version**: 11 (Temurin distribution)
- **Gradle Caching**: Enabled for faster builds
- **Build Time**: Approximately 10-15 minutes per variant

## Troubleshooting

If the workflow fails:

1. Check the workflow logs for detailed error messages
2. Ensure all required dependencies are properly configured
3. Verify that the version name in `app/build.gradle` follows semantic versioning
4. Check that the gradle wrapper is properly validated

## Related Workflows

- `debug_build.yml` - Builds APKs on push and pull requests
- `attach_debug_apks_to_release.yml` - Attaches APKs to GitHub releases
