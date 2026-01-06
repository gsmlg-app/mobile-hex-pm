<!--
Sync Impact Report:
- Version change: 1.1.0 → 2.0.0
- Modified principles:
  - Project identity: "Flutter App Template" → "Mobile Hex.pm App"
  - Removed template management section (setup_project.dart, update_bricks.dart)
  - Updated package structure to reflect actual codebase (no app_plugin/)
- Added sections:
  - Project Purpose section documenting core mission
  - Deployment section documenting Fastlane automation
- Removed sections:
  - Template Management subsection (not applicable to concrete app)
- Templates requiring updates:
  - .specify/templates/plan-template.md ✅ (no changes needed - generic constitution check)
  - .specify/templates/spec-template.md ✅ (no changes needed - technology agnostic)
  - .specify/templates/tasks-template.md ✅ (no changes needed - generic structure)
- Follow-up TODOs: None
- Rationale: MAJOR bump required - this removes the template identity entirely and
  establishes a new project identity. Backward incompatible governance change.
-->

# Mobile Hex.pm App Constitution

## Project Purpose

Mobile Hex.pm is a Flutter application for browsing [Hex.pm](https://hex.pm) packages and reading Hexdocs offline. The app enables Elixir/Elm developers to:

- Search and explore packages from the Hex.pm registry
- Download and read package documentation without internet
- Save favorite packages and releases for quick access
- Manage offline documentation storage

This constitution establishes the foundational rules ensuring consistent architecture and quality.

## Core Principles

### I. Modular Monorepo Architecture

All functionality MUST be organized into purpose-driven packages within the monorepo structure:

- **app_lib/**: Core utilities (database, theme, locale, logging, provider)
- **app_bloc/**: BLoC state management packages
- **app_widget/**: Reusable UI components
- **app_api/**: API integration (hex_api, hex_pm_api - generated from OpenAPI)
- **third_party/**: Modified third-party packages
- **bricks/**: Mason templates for code generation

Each package MUST be independently testable and have a clear, single purpose. Organizational-only
packages without concrete functionality are prohibited.

### II. BLoC State Management

State management MUST follow the BLoC (Business Logic Component) pattern:

- All business logic MUST reside in BLoC classes, not in UI widgets
- State changes MUST flow through events and states
- BLoCs MUST be unit testable without UI dependencies
- Use `flutter_bloc` for widget integration
- ThemeBloc pattern serves as the reference implementation

### III. Workspace Dependency Convention

Internal package dependencies MUST use workspace resolution:

- Declare workspace packages with `<package_name>: any` in pubspec.yaml
- NEVER use path dependencies (`path: ../some_package`)
- Melos resolves all internal dependencies through workspace configuration
- External dependencies SHOULD specify version constraints

### IV. Code Generation First

Scaffolding new code MUST use Mason templates when available:

- Use `mason make screen` for new screens
- Use `mason make widget` for new widgets
- Use `mason make simple_bloc` or `mason make list_bloc` for BLoCs
- Use `mason make form_bloc` for form handling
- Use `mason make repository` for data layer
- Use `mason make native_plugin` for platform plugins (preferred for simplicity)
- Use `mason make native_federation_plugin` only when publishing separate platform packages

Custom implementations without using available templates require justification.

### V. Testing Co-location

Tests MUST be co-located with their packages:

- Each package with logic MUST have a `test/` directory
- Main app screen tests reside in `test/screens/`
- Use `melos run test` to run all tests across packages
- Use `melos run test:dart` for non-Flutter packages
- Use `melos run test:flutter` for Flutter packages

## Development Standards

### Code Style

- Flutter Lints rules from `analysis_options.yaml` are enforced
- Run `melos run analyze` before commits (warnings are fatal)
- Run `melos run format` to ensure consistent formatting
- Prefer `const` constructors where possible
- Use `AppLogger` from `app_logging` for all logging needs

### Routing Convention

Screens MUST define static route constants for GoRouter integration:

```dart
class ExampleScreen extends StatelessWidget {
  static const name = 'example';
  static const path = '/example';
}
```

### App Initialization Pattern

App startup MUST follow the MainProvider pattern:

```dart
MainProvider(
  sharedPrefs: sharedPrefs,
  database: database,
  child: MaterialApp.router(...),
)
```

### Deployment

Releases are automated via Fastlane:

- **iOS**: `cd ios && bundle exec fastlane deploy_staging` (TestFlight) or `deploy_production` (App Store)
- **Android**: `cd android && bundle exec fastlane deploy_staging` (internal track) or `deploy_production` (beta)

Required environment variables are documented in README.md.

## Quality Gates

Before merging any PR:

1. `melos run analyze` MUST pass with no warnings
2. `melos run format` MUST show no changes needed
3. `melos run test` MUST pass for affected packages
4. New packages MUST include test coverage
5. New screens/widgets MUST be generated via Mason templates (when applicable)

## Governance

This constitution establishes the foundational rules for the Mobile Hex.pm App project.
All contributors and AI assistants MUST verify compliance with these principles.

**Amendment Process**:

1. Propose changes via pull request to this file
2. Document rationale for changes
3. Update version according to semantic versioning:
   - MAJOR: Backward incompatible principle changes
   - MINOR: New principles or expanded guidance
   - PATCH: Clarifications and wording fixes
4. Update dependent documentation if principles change

**Compliance Review**:

- All PRs MUST be checked against constitution principles
- Violations require documented justification in Complexity Tracking
- Use CLAUDE.md as runtime development guidance

**Version**: 2.0.0 | **Ratified**: 2025-01-05 | **Last Amended**: 2026-01-06
