# Flutter E-commerce App - AI Coding Agent Guide

## Architecture Overview

This Flutter e-commerce app uses **Clean Architecture** with state management via **Cubit (flutter_bloc)** and **dependency injection via Injectable/GetIt**.

**Core layers:**
- `lib/screens/` - UI screens organized by feature (splash/, home/)
- `lib/cubit/` - Business logic with Cubit pattern (auth/, home/)
- `lib/repositories/` - Data layer abstractions
- `lib/services/` - Service implementations (remote/, local/)
- `lib/models/` - Data models (request/, response/)
- `lib/router/` - Navigation with go_router
- `lib/di/` - Dependency injection configuration
- `lib/core/` - Shared utilities, constants, logging, assets

## Code Generation & Build Commands

**Critical:** This project uses code generators. Always run after modifying files with annotations:

```bash
dart run build_runner build --delete-conflicting-outputs
```

**When to run:**
- After changing any `@freezed` state classes (in `lib/cubit/*/` files)
- After modifying `@JsonSerializable` models (in `lib/models/`)
- After adding new `@Injectable` services
- After changing `flutter_gen` configuration for assets

**Asset generation:**
```bash
dart run build_runner build
```
This generates `lib/core/assets_gen/` for type-safe asset references.

## Dependency Injection Pattern

Uses **Injectable** with GetIt. Register dependencies in `lib/di/third_party_module.dart`:

```dart
@module
abstract class ThirdPartyModule {
  @preResolve
  Future<SharedPreferences> get sharedPreferences => SharedPreferences.getInstance();
  
  FlutterSecureStorage get flutterSecureStorage => FlutterSecureStorage();
}
```

**Service registration:**
- `@LazySingleton(as: Interface)` - Lazy singleton with interface binding (see `ConsoleAppLogger`)
- `@Injectable()` - Factory pattern
- `@Singleton()` - Eager singleton
- `@preResolve` - Async initialization

Access via `getIt<Type>()` from `lib/di/injector.dart`.

## State Management with Cubit + Freezed

All state classes use **Freezed** for immutability. Pattern in `lib/cubit/`:

```dart
@freezed
class HomeState with _$HomeState {
  const factory HomeState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default('') String apiErrorMessage,
  }) = _HomeState;
}
```

Cubit pattern emits state copies:
```dart
emit(state.copyWith(isLoading: true));
```

**Don't manually edit `.freezed.dart` or `.g.dart` files** - they're generated.

## Model Serialization

Two patterns used:

1. **Freezed + JSON (preferred for complex models with unions):**
   - State classes in `lib/cubit/`
   
2. **json_serializable (simpler models):**
   ```dart
   @JsonSerializable()
   class MockRequestModel {
     final String url;
     factory MockRequestModel.fromJson(Map<String, dynamic> json) => 
       _$MockRequestModelFromJson(json);
   }
   ```

## Firebase Integration

Initialized in `main.dart` before DI:
```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
await configureDependencies();
```

Services configured: Auth, Firestore, Storage, Messaging, Analytics, Crashlytics, Google Sign-In.

## Navigation Pattern

Uses **go_router** configured in `lib/router/app_router.dart`:
- Route names in `lib/router/route_name.dart` as constants
- Initial route: `RouteName.splashRoute`
- All routes defined declaratively in `router` instance

**Add new routes:**
```dart
GoRoute(
  path: RouteName.newRoute,
  name: RouteName.newRoute,
  builder: (context, state) => const NewScreen(),
),
```

## UI & Theming

- **Screen utils:** `flutter_screenutil` with design size `414x896` (set in main.dart)
- **Theme constants:** `lib/theme/app_colors.dart`, `lib/theme/app_typography.dart`
- **Custom fonts:** CircularStd (Bold, Book, Medium), Gabarito - configured in pubspec.yaml
- **Type-safe assets:** Use generated classes from `lib/core/assets_gen/`

## Storage Strategy

**Secure data:** Use `FlutterSecureStorage` (tokens, sensitive data)
**General data:** Use `SharedPreferences` (theme, language)

See pattern in `lib/services/local/local_storage.dart`.

## Logging Pattern

Custom logger abstraction at `lib/core/logging/`:
- Interface: `AppLogger`
- Implementation: `ConsoleAppLogger` (uses logger package)
- Inject via `getIt<AppLogger>()`
- Methods: `i()`, `e()`, `f()`, `crash()`

## Development Workflows

**Run app:**
```bash
flutter run
```

**Format code:**
```bash
dart format .
```

**Analyze:**
```bash
flutter analyze
```

**Clean build:**
```bash
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

## Project Conventions

- **Barrel files:** Each directory exports via `*.dart` (e.g., `lib/cubit/cubit.dart`)
- **Feature organization:** Group by feature (auth/, home/) not by layer
- **State naming:** Use `isLoading`, `isSuccess`, `apiErrorMessage` pattern consistently
- **Repository pattern:** Repositories are abstractions, actual implementation in services/
- **Constants:** Centralized in `lib/core/constants/`
- **Extensions:** Custom extensions in `lib/core/extensions/`

## Common Pitfalls

- Forgetting to run build_runner after Freezed/Injectable changes
- Manually editing generated files
- Not using `getIt` for dependency injection
- Hardcoding asset paths instead of using generated classes
- Missing `await configureDependencies()` before runApp

## Dart General Guidelines

### Basic Principles
* Use English for all code and documentation.
* Always declare the type of each variable and function (parameters and return value).
* Avoid using any.
* Create necessary types.
* Don't leave blank lines within a function.
* One export per file.

### Nomenclature
* Use PascalCase for classes.
* Use camelCase for variables, functions, and methods.
* Use underscores_case for file and directory names.
* Use UPPERCASE for environment variables.
* Avoid magic numbers and define constants.
* Start each function with a verb.
* Use verbs for boolean variables. Example: isLoading, hasError, canDelete, etc.
* Use complete words instead of abbreviations and correct spelling.
* Except for standard abbreviations like API, URL, etc.
* Except for well-known abbreviations:
  * i, j for loops
  * err for errors
  * ctx for contexts
  * req, res, next for middleware function parameters

### Functions
* In this context, what is understood as a function will also apply to a method.
* Write short functions with a single purpose. Less than 20 instructions.
* Name functions with a verb and something else.
  * If it returns a boolean, use isX or hasX, canX, etc.
  * If it doesn't return anything, use executeX or saveX, etc.
* Avoid nesting blocks by:
  * Early checks and returns.
  * Extraction to utility functions.
* Use higher-order functions (map, filter, reduce, etc.) to avoid function nesting.
* Use arrow functions for simple functions (less than 3 instructions).
* Use named functions for non-simple functions.
* Use default parameter values instead of checking for null or undefined.
* Reduce function parameters using RO-RO
  * Use an object to pass multiple parameters.
  * Use an object to return results.
  * Declare necessary types for input arguments and output.
* Use a single level of abstraction.

### Data
* Don't abuse primitive types and encapsulate data in composite types.
* Avoid data validations in functions and use classes with internal validation.
* Prefer immutability for data.
* Use readonly for data that doesn't change.
* Use as const for literals that don't change.

### Classes
* Follow SOLID principles.
* Prefer composition over inheritance.
* Declare interfaces to define contracts.
* Write small classes with a single purpose.
  * Less than 200 instructions.
  * Less than 10 public methods.
  * Less than 10 properties.

### Exceptions
* Use exceptions to handle errors you don't expect.
* If you catch an exception, it should be to:
  * Fix an expected problem.
  * Add context.
* Otherwise, use a global handler.

### Testing
* Follow the Arrange-Act-Assert convention for tests.
* Name test variables clearly.
  * Follow the convention: inputX, mockX, actualX, expectedX, etc.
* Write unit tests for each public function.
* Use test doubles to simulate dependencies.
  * Except for third-party dependencies that are not expensive to execute.
* Write acceptance tests for each module.
  * Follow the Given-When-Then convention.
