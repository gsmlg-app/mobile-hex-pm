# AGENTS.md

## Purpose

This repository is a Flutter monorepo managed with Melos. Use the commands and
style guidance below when making changes so CI stays green and code matches
team conventions.

## Build/Lint/Test Commands

### Workspace Setup
```bash
# Bootstrap all packages (run at repo root)
melos bootstrap

# Prepare the project (pub get + generate configs)
melos run prepare
```

### Build & Code Generation
```bash
# Generate code for all packages
melos run build-runner

# Generate localization files
melos run gen-l10n

# Generate app icons
dart run flutter_launcher_icons:main
```

### Running the App
```bash
# Run the main app (from repo root)
flutter run
```

### Static Analysis & Formatting
```bash
# Analyze all packages (fatal infos)
melos run analyze

# Format code (dart format .)
melos run format

# Check formatting without changes
melos run format-check

# Apply automated fixes
melos run fix

# Preview automated fixes
melos run fix-dry-run
```

### Testing
```bash
# Run all tests (Dart + Flutter)
melos run test

# Run only Flutter tests
melos run test:flutter

# Run only Dart tests
melos run test:dart
```

### Single Test
```bash
# Run a single Flutter test file
flutter test test/path/to/test_file.dart

# Run a single Dart test file
dart test test/path/to/test_file.dart

# Run tests for a specific package
cd <package_directory> && flutter test
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

## Code Style Guidelines

### Imports
- Group imports by category: `dart`, `flutter`, `package`, local.
- Use absolute imports for workspace packages (e.g., `package:app_lib/...`).
- Avoid unused imports and unused exports.
- Prefer explicit imports instead of barrel files unless the package already
  uses barrels consistently.

### Formatting
- Use `dart format .` (80 character line length enforced by tooling).
- Keep trailing whitespace out of files.
- Prefer one widget per line in widget trees when nesting gets deep.
- Keep constructors and parameter lists vertically aligned for readability.

### Types & Naming
- Prefer explicit types; avoid `var` when the type is clear.
- Avoid `dynamic` unless required by API boundaries.
- Use `final` for values that never change.
- Prefer `const` widgets/constructors when possible.
- Use `late` only when initialization order requires it.
- `PascalCase` for classes, enums, extensions, typedefs, and widgets.
- `camelCase` for variables, functions, methods, and parameters.
- `snake_case` for files, directories, and part files.
- Use clear suffixes like `Bloc`, `Event`, `State`, `Repository`, `Service`.

### Flutter/UI Conventions
- Keep UI logic in widgets; business logic belongs in BLoC or services.
- Use `BlocProvider`/`BlocBuilder` or `BlocConsumer` where appropriate.
- Avoid heavy work in `build`; use memoization or BLoC state instead.
- Prefer `const` `EdgeInsets`, `SizedBox`, and `Text` when static.
- Keep widget trees small by extracting private widgets.

### BLoC/State Management
- Follow the BLoC pattern consistently across `app_bloc/` packages.
- Events are inputs, states are immutable outputs.
- Keep events/states in their own files when they grow.
- Use `Equatable` or value comparison patterns already in the package.
- Emit loading, success, and failure states explicitly.

### Error Handling
- Wrap async operations in `try/catch` and handle failures gracefully.
- Convert low-level exceptions into user-friendly error states/messages.
- Log errors with the logging utilities provided in `app_lib/logging`.
- Avoid swallowing exceptions silently; surface them to logs or state.

### Localization
- Put user-visible strings into the l10n system.
- Run `melos run gen-l10n` after changing locale files.
- Avoid hard-coded strings in widgets unless they are debug-only.

### Data & Persistence
- Keep database access in `app_lib/database` and repository layers.
- Prefer repository abstractions over direct API/database usage in UI.
- Keep DTOs and domain models clearly separated.

### Generated Files
- Do not edit `*.g.dart` or other generated files.
- Use `melos run build-runner` after model/schema changes.

### Miscellaneous
- Respect existing package boundaries in `app_lib`, `app_bloc`, `app_widget`.
- Avoid adding new dependencies without updating relevant `pubspec.yaml`.
- Keep public APIs stable; document breaking changes in package READMEs.
- Follow existing patterns in nearby files before introducing new ones.
