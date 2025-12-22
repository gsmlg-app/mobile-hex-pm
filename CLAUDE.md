# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter mobile application for browsing hex.pm packages and reading hexdocs offline. Uses Melos monorepo with BLoC state management.

## Development Commands

```bash
# Setup
melos run prepare              # Bootstrap + generate code + l10n
melos bootstrap                # Bootstrap all packages

# Code generation
melos run build-runner         # Run build_runner for all packages
melos run gen-l10n             # Generate localization files

# Quality
melos run analyze              # Analyze with fatal infos
melos run format               # Format code
melos run fix                  # Apply dart fixes

# Testing
melos run test                 # Run all tests
melos run test:flutter         # Flutter tests only
melos run test:dart            # Dart tests only
flutter test test/path/to/test_file.dart  # Single test file

# Deployment (Fastlane)
bundle install                 # Install Ruby dependencies
cd ios && bundle exec fastlane deploy_staging      # iOS to TestFlight
cd ios && bundle exec fastlane deploy_production   # iOS to App Store
cd android && bundle exec fastlane deploy_staging  # Android to internal track
cd android && bundle exec fastlane deploy_production  # Android to beta track
```

## Architecture

### Monorepo Structure
- **app_lib/**: Core libraries (theme, locale, provider, database, logging)
- **app_bloc/**: BLoC packages (theme, hex_auth, hex_search, favorite_package, hex_doc, offline_docs_server)
- **app_widget/**: UI components (adaptive, artwork, feedback, web_view)
- **app_api/**: API integration (hex_api, hex_pm_api - generated from OpenAPI)
- **third_party/**: Custom third-party packages (form_bloc, settings_ui, etc.)

### App Entry Flow
`main.dart` → `MainProvider` (injects all BLoCs/repositories) → `App` → `GoRouter`

### BLoC Package Structure
Each BLoC package in `app_bloc/` follows this pattern:
```
lib/
├── <package_name>_bloc.dart  # Public export
└── src/
    ├── bloc.dart             # BLoC implementation with event handlers
    ├── event.dart            # Event definitions (part of bloc.dart)
    ├── state.dart            # State definitions (part of bloc.dart)
    └── form.dart             # Optional FormBloc (part of bloc.dart)
```

### Dependency Injection
`MainProvider` (in `app_lib/provider`) wires up all dependencies:
- Repositories: SharedPreferences, AppDatabase, HexApi
- BLoCs: ThemeBloc, HexAuthBloc, HexSearchBloc, FavoritePackageBloc, HexDocBloc, OfflineDocsServerBloc

### Routing
Uses go_router with static route definitions in `lib/router.dart`. Each screen defines its own `name` and `path` static constants.

### Localization
- Config: `app_lib/locale/l10n.yaml`
- ARB files: `app_lib/locale/lib/arb/`
- Access via `context.l10n.keyName`

## Code Style

- Group imports: dart → flutter → package → local
- Use strong typing (avoid `var` when type is clear)
- PascalCase: classes/widgets | camelCase: variables/functions | snake_case: files
- Follow flutter_lints rules (80 char line length)