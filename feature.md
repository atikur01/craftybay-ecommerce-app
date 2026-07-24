# Feature Development Guidelines - CraftyBay

This document outlines the coding standards, architectural patterns, and UI design principles to be followed when creating new features in the CraftyBay project.

## 1. Feature Directory Structure
Every new feature should be modularized under `lib/features/`. Follow the layered architecture within each feature folder:

```text
lib/features/<feature_name>/
├── data/
│   ├── models/            # Data transfer objects (DTOs) and JSON models
│   ├── repositories/      # Implementations of repository interfaces
│   └── data_sources/      # API calls (Remote) or Local storage (Local)
├── presentation/
│   ├── providers/         # State management logic (using Provider)
│   ├── screens/           # Main UI screens
│   └── widgets/           # Feature-specific reusable widgets
```

## 2. State Management (Provider)
- Use **Provider** for all state-related logic.
- **ChangeNotifier**: Business logic and UI state should reside in a class extending `ChangeNotifier`.
- **Usage**: Use `Consumer<T>` or `context.read<T>()`/`context.watch<T>()` to interact with providers.
- **Isolation**: Keep the `build` method clean. If a piece of UI depends on a specific part of the state, use `Selector` or wrap only that part with `Consumer`.

## 3. UI Design & Styling
- **Colors**: Always use `AppColors` (defined in `lib/app/app_colors.dart`). Never hardcode hex codes in the UI.
- **Theme**: Utilize `Theme.of(context).textTheme` for consistent typography.
- **Assets**: Reference assets using a central asset manager if available, or keep them organized in `assets/`.
- **Reusable Widgets**: If a widget is used in multiple features, move it to `lib/features/shared/presentation/widgets/`.

## 4. Localization (l10n)
- All user-facing strings must be localized.
- Add new strings to `lib/l10n/app_en.arb` (and other language files).
- Access them in the UI via `AppLocalizations.of(context)!`.

## 5. Routing
- Define a `static const String name` for every screen.
- Register new routes in `lib/app/routes.dart` (or the central routing configuration).
- Use `Navigator.pushNamed` or the preferred routing method consistently.

## 6. Coding Standards
- **Naming**: 
  - Files: `snake_case.dart`
  - Classes: `PascalCase`
  - Variables/Methods: `camelCase`
- **Linting**: Follow the standard Flutter lint rules. Fix all warnings before committing.
- **Documentation**: Provide comments for complex logic and public APIs.
- **Null Safety**: Always use null-safe types and handle potential null values appropriately.

---
*Follow these guidelines to maintain a clean, scalable, and maintainable codebase.*
