# AGENTS.md

## Build/Lint/Test Commands

### Single Test
```bash
# Run specific test file
flutter test test/path/to/test_file.dart

# Run tests for specific package
cd <package_directory> && flutter test

# Run tests with coverage
flutter test --coverage
```

### Quality Commands
```bash
# Analyze all packages
melos run analyze

# Format code
melos run format

# Fix Dart issues
melos run fix

# Build runner for code generation
melos run build-runner
```

## Code Style Guidelines

### Imports
- Group imports: dart, flutter, package, local
- Use absolute imports for workspace packages
- No unused imports

### Formatting
- Use `dart format .` (80 character line length)
- Follow flutter_lints rules
- No trailing whitespace

### Types & Naming
- Use strong typing (avoid `var` when type is clear)
- PascalCase for classes/widgets
- camelCase for variables/functions
- snake_case for files and directories

### Error Handling
- Use try/catch for async operations
- Log errors with appropriate levels
- Provide user-friendly error messages

### Architecture
- Follow BLoC pattern for state management
- Separate UI from business logic
- Use dependency injection via providers
- Modular package structure by functionality