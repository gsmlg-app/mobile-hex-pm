# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter mobile application for browsing hex.pm packages and reading hexdocs offline. It uses a modular architecture with Melos for monorepo management and BLoC for state management.

## Development Commands

### Project Setup
```bash
# Initial project preparation
melos run prepare

# Bootstrap all packages
melos bootstrap
```

### Build & Code Generation
```bash
# Generate code for all packages (build_runner)
melos run build-runner

# Generate localization files
melos run gen-l10n

# Generate app icons
dart run flutter_launcher_icons:main
```

### Static Analysis & Code Quality
```bash
# Run analyze with fatal infos
melos run analyze

# Format code
melos run format

# Format check (fails if changes needed)
melos run format-check

# Fix Dart issues
melos run fix

# Fix dry-run (preview changes)
melos run fix-dry-run
```

### Testing
```bash
# Run all tests (Dart and Flutter)
melos run test

# Run Flutter tests only
melos run test:flutter

# Run Dart tests only
melos run test:dart

# Run tests for specific package
cd <package_directory> && flutter test

# Run brick tests
melos run brick-test
```

### Dependencies
```bash
# Upgrade all dependencies
melos run upgrade

# Check for outdated dependencies
melos run outdated

# Validate dependency usage
melos run validate-dependencies
```

## Architecture

### Monorepo Structure
The project uses Melos workspace with packages organized by functionality:

- **app_lib/**: Core library packages (theme, locale, provider, database)
- **app_bloc/**: BLoC state management packages (theme, hex_auth, hex_search, etc.)
- **app_widget/**: UI component packages (adaptive, artwork, feedback, web_view)
- **app_api/**: API integration packages (hex_api, hex_pm_api)
- **third_party/**: Custom third-party packages and utilities

### State Management
- Uses BLoC pattern with separate packages for different features
- Each BLoC package contains events, states, and the bloc itself
- Main BLoCs: theme, hex_auth, hex_search, favorite_package, hex_doc

### Localization
- Uses Flutter's official l10n system
- Configuration in `app_lib/locale/l10n.yaml`
- ARB files in `app_lib/locale/lib/arb/`
- Generated files in `app_lib/locale/lib/gen_l10n/`

### API Integration
- Separate packages for different APIs (hex_api, hex_pm_api)
- Generated from OpenAPI specifications
- Handles hex.pm package data and authentication

### Key Dependencies
- **go_router**: Navigation and routing
- **flutter_bloc**: State management
- **shared_preferences**: Local storage
- **webview_flutter**: For displaying hexdocs
- **google_fonts**: Typography
- **lottie**: Animations

## Package Development

When working on individual packages:
1. Navigate to the package directory
2. Use `flutter analyze` for static analysis
3. Use `dart format .` for formatting
4. Use `flutter test` for testing
5. Use `melos run build-runner` for code generation across all packages

## Melos Script Execution

Most Melos commands use `exec` with `orderDependents: true` to ensure proper dependency order between packages. Some commands include `fail-fast: true` to stop on first failure.

## Testing Strategy

Each package has its own test suite. The project includes extensive test coverage for:
- BLoC state management logic
- API integration tests
- Widget tests for UI components
- Database operations