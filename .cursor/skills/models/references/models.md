# Flutter Models Reference Guide

Complete reference for creating and maintaining data models in Flutter applications following KAT team standards and clean architecture principles.

## Table of Contents

1. [Model Structure Overview](#model-structure-overview)
2. [Key Principles](#key-principles)

---

## Model Structure Overview

Models in the KAT architecture are organized as follows:

```
lib/models/
├── models.dart                 # Main export file
├── request/                    # Request models (DTOs sent to API)
│   ├── request.dart           # Request exports
│   └── *_request.dart         # Individual request models
└── response/                   # Response models (DTOs from API)
    ├── response.dart          # Response exports
    └── *_response.dart        # Individual response models
```

### Directory Structure Rules

- **One model per file** - Each model class should be in its own file
- **Barrel files** - Use `request.dart` and `response.dart` to export models
- **Main export** - `models.dart` exports all sub-modules
- **Subdirectories** - Group related models if needed (e.g., `response/user/`, `response/product/`)

---

## Key Principles

### 1. Model Types

#### Request Models
Data transfer objects sent TO APIs (login credentials, form data)

```dart
// lib/models/request/login_request.dart
@JsonSerializable()
class LoginRequestModel {
  final String email;
  final String password;

  LoginRequestModel({
    required this.email,
    required this.password,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
```

#### Response Models
Data transfer objects received FROM APIs (user info, API responses)

```dart
// lib/models/response/user_info.dart
@JsonSerializable()
class UserInfoModel {
  @JsonKey(name: 'first_name')
  final String firstName;

  @JsonKey(name: 'last_name')
  final String lastName;

  final String email;

  UserInfoModel({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
```
