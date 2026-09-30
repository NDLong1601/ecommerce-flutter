# Flutter Cubit Pattern Reference Guide

Complete reference for implementing Cubit pattern with Freezed for state management in Flutter applications following clean architecture principles.

## Table of Contents

- [Cubit Pattern Overview](#cubit-pattern-overview)
  - [Why Cubit + Freezed?](#why-cubit--freezed)
- [Directory Structure](#directory-structure)
  - [Directory Structure Rules](#directory-structure-rules)
- [Key Principles](#key-principles)
  - [1. Separation of Concerns](#1-separation-of-concerns)
  - [2. Immutability](#2-immutability)
  - [3. Single Responsibility](#3-single-responsibility)
  - [4. Dependency Injection](#4-dependency-injection)
- [State Management with Freezed](#state-management-with-freezed)
  - [Basic State Structure](#basic-state-structure)
  - [State Properties Guidelines](#state-properties-guidelines)
- [Cubit Implementation](#cubit-implementation)
  - [Basic Cubit Structure](#basic-cubit-structure)
- [UI Integration](#ui-integration)
  - [Using BlocBuilder](#using-blocbuilder)
  - [Using BlocListener](#using-bloclistener)
  - [Using BlocConsumer](#using-blocconsumer)
- [Running Code Generation](#running-code-generation)

## Cubit Pattern Overview

Cubit is a simplified version of Bloc that manages state through methods instead of events. It uses Freezed for immutable state management, providing type-safe state updates and excellent developer experience.

### Why Cubit + Freezed?

- **Simpler than Bloc**: No events, just methods
- **Type Safety**: Freezed generates immutable state classes
- **copyWith**: Easy state updates without manual boilerplate
- **Testability**: Pure functions make testing straightforward
- **Clean Architecture**: Separates business logic from UI

## Directory Structure

```
lib/cubit/
├── cubit.dart                          # Main export file
├── auth/                               # Auth feature
│   ├── auth.dart                       # Feature export
│   ├── auth_cubit.dart                 # Business logic
│   ├── auth_state.dart                 # State definition
│   └── auth_state.freezed.dart         # Generated file
└── [feature_name]/                     # Other features
    ├── [feature_name].dart
    ├── [feature_name]_cubit.dart
    ├── [feature_name]_state.dart
    └── [feature_name]_state.freezed.dart
```

### Directory Structure Rules

- **One feature per folder** - Group cubit and state together
- **Barrel files** - Each feature has an export file (e.g., `auth.dart`)
- **Main export** - `cubit.dart` exports all feature modules
- **Generated files** - Freezed generates `.freezed.dart` files (don't edit)

## Key Principles

### 1. Separation of Concerns

- **Cubit**: Contains business logic, handles operations
- **State**: Represents UI state, immutable data structure
- **UI**: Observes state changes, triggers cubit methods

### 2. Immutability

- All state classes are immutable (using Freezed)
- State updates create new instances via `copyWith`
- No direct state mutation

### 3. Single Responsibility

- Each Cubit manages one feature/domain
- Keep Cubits focused and small (< 200 lines)
- Extract complex logic to services/repositories

### 4. Dependency Injection

- Use `@injectable` for automatic registration
- Inject services via constructor
- Use GetIt for dependency resolution

## State Management with Freezed

### Basic State Structure

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'feature_name_state.freezed.dart';

@freezed
class FeatureNameState with _$FeatureNameState {
  const factory FeatureNameState({
    @Default(false) bool isLoading,
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
  }) = _FeatureNameState;
}
```

### State Properties Guidelines

#### Common State Properties

```dart
@freezed
class ExampleState with _$ExampleState {
  const factory ExampleState({
    // Loading states
    @Default(false) bool isLoading,
    @Default(false) bool isSubmitting,
    @Default(false) bool isRefreshing,
    
    // Success/Error states
    @Default(false) bool isSuccess,
    @Default('') String errorMessage,
    @Default('') String successMessage,
    
    // Data
    String? userData,
    List<Item>? items,
    
    // UI state
    @Default(0) int currentIndex,
    @Default(true) bool isEnabled,
  }) = _ExampleState;
}
```

#### State Property Naming Conventions

- **Boolean flags**: Use `is*`, `has*`, `can*` prefixes
  - `isLoading`, `isSuccess`, `hasError`
  - `canSubmit`, `hasData`
- **Error messages**: Use `errorMessage` or `apiErrorMessage`
- **Data properties**: Use descriptive nouns (`userData`, `items`, `profile`)
- **Defaults**: Always provide default values with `@Default(...)`

## Cubit Implementation

### Basic Cubit Structure

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'feature_name_state.dart';

class FeatureNameCubit extends Cubit<FeatureNameState> {
  FeatureNameCubit() : super(const FeatureNameState());

  Future<void> performAction() async {
    emit(state.copyWith(isLoading: true));
    
    try {
      // Business logic here
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
    }
  }
  
  void resetState() {
    emit(const FeatureNameState());
  }
}
```

## UI Integration

### Using BlocBuilder

```dart
BlocBuilder<SignInCubit, SignInState>(
  builder: (context, state) {
    if (state.isLoading) {
      return const CircularProgressIndicator();
    }
    
    if (state.isSuccess) {
      return const Text('Sign in successful!');
    }
    
    if (state.errorMessage.isNotEmpty) {
      return Text('Error: ${state.errorMessage}');
    }
    
    return const SignInForm();
  },
)
```

### Using BlocListener

```dart
BlocListener<SignInCubit, SignInState>(
  listener: (context, state) {
    if (state.isSuccess) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
    
    if (state.errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.errorMessage)),
      );
    }
  },
  child: SignInForm(),
)
```

### Using BlocConsumer

```dart
BlocConsumer<SignInCubit, SignInState>(
  listener: (context, state) {
    if (state.isSuccess) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  },
  builder: (context, state) {
    return SignInForm(isLoading: state.isLoading);
  },
)
```

## Running Code Generation

```bash
# Clean and regenerate
flutter pub run build_runner build --delete-conflicting-outputs
```