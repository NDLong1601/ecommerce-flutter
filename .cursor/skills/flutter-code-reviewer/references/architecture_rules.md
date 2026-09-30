# KAT Architecture Rules

Architectural guidelines and patterns for KAT Flutter applications.

## Clean Architecture Layers

### 1. Presentation Layer
- **Location**: `lib/modules/{feature}/presentation/`
- **Components**: `ui/screens/`, `ui/widgets/`, `bloc/` or `cubit/`
- **Rules**:
  - Controllers (Cubit/Bloc) contain only presentation logic
  - No direct dependency on data layer
  - Use dependency injection for use cases
  - Handle UI state with immutable classes

### 2. Domain Layer
- **Location**: `lib/modules/{feature}/domain/`
- **Components**: `entities/`, `enums/`, `failures/`
- **Rules**:
  - Pure Dart code only (no Flutter dependencies)
  - Contains business rules and logic
  - Independent of external frameworks

### 3. Application Layer
- **Location**: `lib/modules/{feature}/application/`
- **Components**: `use_case/`, `repository/` (interfaces)
- **Rules**:
  - Use cases contain business logic
  - Repository interfaces define contracts
  - Each use case has single responsibility

### 4. Infrastructure Layer
- **Location**: `lib/modules/{feature}/infrastructure/`
- **Components**: `data_sources/`, `dto/`, `repositories/` (implementations)
- **Rules**:
  - Implements repository interfaces
  - Handles data transformation (DTO ↔ Entity)
  - Manages caching strategies

### 5. Shared/Core Layer
- **Location**: `lib/shared/` or `lib/core/`
- **Components**: `constants/`, `extensions/`, `utils/`, `widgets/`
- **Rules**:
  - Reusable across features
  - No feature-specific logic

## Module Organization

### Feature-based Structure
```
lib/modules/{feature_name}/
├── application/
│   ├── repository/
│   └── use_case/
├── domain/
│   ├── entities/
│   ├── enums/
│   └── failures/
├── infrastructure/
│   ├── data_sources/
│   ├── dto/
│   └── repositories/
└── presentation/
    ├── bloc/ or cubit/
    └── ui/
        ├── screens/
        └── widgets/
```

### Dependency Rules
- **Presentation** → Application → Domain
- **Infrastructure** → Application → Domain
- **Shared/Core** can be used by any layer
- No circular dependencies
- Higher layers cannot depend on lower layers

## Cross-Module Dependencies

### Module Isolation Rules
- ❌ **FORBIDDEN**: Direct imports between feature modules, including:
  - Relative path imports: `../../other_module/`
  - Package imports: `package:kat_einvoice_app/modules/{other_module}/...`
  - Any file in `lib/modules/{feature_A}/` must NOT import from `lib/modules/{feature_B}/`
- ✅ **ALLOWED**: Access through shared layer, dependency injection, event bus

### How to Detect Cross-Module Violations
For every file under `lib/modules/{feature}/`, scan ALL import statements and verify:
1. No import contains `modules/{other_feature}/` where `{other_feature}` ≠ `{feature}`
2. This applies to BOTH relative imports (`../`) AND absolute package imports (`package:...`)
3. Imports from `lib/shared/`, `lib/core/`, or external packages are allowed

**Example violations:**
```dart
// File: lib/modules/onboarding/presentation/bloc/some_cubit.dart

// ❌ VIOLATION - importing from another module via package import
import 'package:kat_einvoice_app/modules/invoice/application/use_case/use_case.dart';
import 'package:kat_einvoice_app/modules/invoice/domain/entities/entities.dart';
import 'package:kat_einvoice_app/modules/invoice/infrastructure/models/some_request.dart';

// ✅ OK - importing from same module
import 'package:kat_einvoice_app/modules/onboarding/application/use_case/use_case.dart';

// ✅ OK - importing from shared layer
import 'package:kat_einvoice_app/shared/shared.dart';

// ✅ OK - importing external packages
import 'package:kat_infrastructure/kat_infrastructure.dart';
```

### Module Communication Patterns
When cross-module data is needed, use one of these patterns:
1. **Shared Layer**: Move common entities, services, events to `lib/shared/`
2. **Dependency Injection**: Register shared interfaces in GetIt, inject abstractions
3. **Event-Driven**: Use event bus for loose coupling between modules

## File Location Validation

### Required Locations
- **Entities**: `lib/modules/{feature}/domain/entities/`
- **DTOs**: `lib/modules/{feature}/infrastructure/dto/`
- **Use Cases**: `lib/modules/{feature}/application/use_case/`
- **Repository Interfaces**: `lib/modules/{feature}/application/repository/`
- **Repository Implementations**: `lib/modules/{feature}/infrastructure/repositories/`
- **Cubits/Blocs**: `lib/modules/{feature}/presentation/bloc/` or `cubit/`
- **Data Sources**: `lib/modules/{feature}/infrastructure/data_sources/`
- **Screens**: `lib/modules/{feature}/presentation/ui/screens/`
- **Widgets**: `lib/modules/{feature}/presentation/ui/widgets/`

## Import Validation Rules

### Layer ↔ Folder Path Mapping
Use this mapping to determine which layer a file belongs to:
- **Presentation Layer**: files under `modules/{feature}/presentation/` (including `bloc/`, `ui/screens/`, `ui/widgets/`)
- **Application Layer**: files under `modules/{feature}/application/` (including `use_case/`, `repository/`)
- **Domain Layer**: files under `modules/{feature}/domain/` (including `entities/`, `enums/`, `failures/`)
- **Infrastructure Layer**: files under `modules/{feature}/infrastructure/` (including `data_sources/`, `dto/`, `models/`, `repositories/`)

### Allowed Layer Dependencies
- **Presentation** → can import from → **Application**, **Domain**
- **Infrastructure** → can import from → **Application**, **Domain**
- **Application** → can import from → **Domain** only
- **Domain** → can import from → **Domain** only (no other layers)
- Any layer → can import from → **Shared/Core** (`lib/shared/`, `lib/core/`) and external packages

### Forbidden Layer Dependencies
- ❌ **Presentation** must NOT import from **Infrastructure** (`infrastructure/data_sources/`, `infrastructure/dto/`, `infrastructure/models/`, `infrastructure/repositories/`)
- ❌ **Domain** must NOT import from **Presentation**, **Application**, or **Infrastructure**
- ❌ **Application** must NOT import from **Presentation** or **Infrastructure**
- ❌ **Infrastructure** must NOT import from **Presentation**

### How to Detect Layer Violations
For every file, determine its layer from the folder path, then scan ALL imports:
1. Determine the file's layer using the **Layer ↔ Folder Path Mapping** above
2. Check every import for paths containing layer folder names (`/presentation/`, `/application/`, `/domain/`, `/infrastructure/`)
3. Verify the import's layer is in the **Allowed Layer Dependencies** for the file's layer
4. Flag any import that violates the dependency direction

**Example violations:**
```dart
// File: lib/modules/onboarding/presentation/bloc/some_cubit.dart
// This file is in PRESENTATION layer

// ❌ VIOLATION - Presentation importing from Infrastructure layer
import 'package:kat_einvoice_app/modules/onboarding/infrastructure/models/create_declaration_request.dart';
import 'package:kat_einvoice_app/modules/onboarding/infrastructure/dto/some_dto.dart';

// ✅ OK - Presentation importing from Application layer
import 'package:kat_einvoice_app/modules/onboarding/application/use_case/use_case.dart';

// ✅ OK - Presentation importing from Domain layer
import 'package:kat_einvoice_app/modules/onboarding/domain/entities/entities.dart';
```

### Domain Layer Import Rules
- **Must NOT import**: `package:flutter/`, `package:flutter_bloc/`, HTTP clients, anything from `infrastructure/`, `application/`, `presentation/`
- **Can import**: `package:dartz/`, domain entities, core utilities

### Infrastructure Layer Import Rules
- **Must NOT import**: Flutter UI widgets, Bloc/Cubit classes, anything from `presentation/`
- **Can import**: HTTP clients, local storage, domain entities, DTOs, application layer interfaces

### Application Layer Import Rules
- **Must NOT import**: Flutter UI widgets, DTOs, data sources, anything from `infrastructure/` or `presentation/`
- **Can import**: Domain entities, repository interfaces (within same layer)

### Presentation Layer Import Rules
- **Must NOT import**: DTOs, data sources, repository implementations, anything from `infrastructure/`
- **Can import**: Flutter widgets, Bloc/Cubit, application layer use cases, domain entities

## State Management Architecture

### Cubit/Bloc Pattern
- Use **Cubit** for simple state management
- Use **Bloc** for complex event-driven scenarios
- State classes must be immutable
- Controllers coordinate between UI and domain layer

## Dependency Injection

### GetIt Configuration
- **Singleton**: Services, repositories, API clients
- **Factory**: Use cases
- **Lazy Singleton**: Controllers (Cubit/Bloc)

## Repository Pattern

### Interface Definition
- Repository interfaces in `application/repository/`
- Repository implementations in `infrastructure/repositories/`
- Return `Either<Failure, Success>` for error handling

## Navigation Architecture

### AutoRoute Configuration
- Centralized route definitions
- Use `extras` for data passing
- Support deep linking when needed
- Type-safe navigation

## Error Handling

### Either Pattern
- Use `dartz` Either for error handling
- Left side for failures, Right side for success
- Consistent across all layers

## Performance Considerations

### Widget Architecture
- Avoid deep nesting (max 3-4 levels)
- Extract to smaller widgets
- Use const constructors
- Implement proper disposal

### Data Architecture
- Implement caching strategies
- Use pagination for large datasets
- Optimize API calls
- Handle offline scenarios

## Security Architecture

### Data Protection
- No hardcoded secrets
- Secure storage for sensitive data
- Input validation at boundaries
- Proper authentication/authorization

## Validation Checklist

### File Location Validation
- [ ] Entities only in `domain/entities/`
- [ ] DTOs only in `infrastructure/dto/`
- [ ] Use cases only in `application/use_case/`
- [ ] Repository interfaces only in `application/repository/`
- [ ] Repository implementations only in `infrastructure/repositories/`
- [ ] Cubits/Blocs only in `presentation/bloc/` or `cubit/`
- [ ] Data sources only in `infrastructure/data_sources/`

### Cross-Module Import Validation
- [ ] No cross-module imports via relative paths (`../../other_module/`)
- [ ] No cross-module imports via package paths (`package:app/modules/{other_module}/`)
- [ ] Every import in `modules/{feature}/` referencing `modules/` points to the SAME `{feature}`

### Layer Dependency Validation
- [ ] Presentation layer does NOT import from `infrastructure/` (no DTOs, models, data sources, repository impls)
- [ ] Application layer does NOT import from `infrastructure/` or `presentation/`
- [ ] Domain layer does NOT import from `infrastructure/`, `application/`, or `presentation/`
- [ ] Domain layer has no Flutter imports (`package:flutter/`, `package:flutter_bloc/`)
- [ ] Infrastructure layer does NOT import from `presentation/`

### Architecture Validation
- [ ] Clean architecture layers respected
- [ ] Layer dependency direction followed (see Allowed Layer Dependencies)
- [ ] Single responsibility principle applied
- [ ] No circular dependencies
- [ ] Proper separation of concerns
- [ ] Module isolation maintained