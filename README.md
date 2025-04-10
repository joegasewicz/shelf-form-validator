# shelf_form_validator

A lightweight, extensible Dart validation framework designed for form data in backend apps using Shelf, or any Dart CLI/VM environment.

---

## 📦 Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  shelf_form_validator: ^0.1.0
```

Then run:

```bash
dart pub get
```

Or install it via the command line:

```bash
dart pub add shelf_form_validator
```

---

## ✨ Features

- Simple API for form validation
- Plug-and-play validator classes (e.g. `EmptyString`, `StringLength`, `ValidEmail`, etc.)
- Provides reflection helper functions for schema validation
- Can validate any schema object with a `final` field structure

---

## ✨ Quick Start

### Validator

```dart
final validator = Validator(schema: data)
  ..addValidator('email', [EmptyString(), ValidEmail()])
  ..addValidator('password', [EmptyString(), StringLength(stringLength: 8)]);

validator.validate();
```

### Create a Dart Schema

```dart
class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});
}
```

### Combined Your Schema & Validator

```dart
class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  factory Login.fromFormData(Map<String, String> formData) {
    final login = Login(
      email: formData['email'] ?? '',
      password: formData['password'] ?? '',
    );

    final validator = Validator(schema: login)
      ..addValidator('email', [EmptyString(), ValidEmail()])
      ..addValidator('password', [EmptyString(), StringLength(stringLength: 8)]);

    validator.validate();

    return login;
  }
}
```

---

Minimal example using just two fields:

```dart
class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  factory Login.fromFormData(Map<String, String> formData) {
    final login = Login(
      email: formData['email'] ?? '',
      password: formData['password'] ?? '',
    );

    final validator = Validator(schema: login)
      ..addValidator('email', [EmptyString(), ValidEmail()])
      ..addValidator('password', [EmptyString(), StringLength(stringLength: 8)]);

    validator.validate();

    return login;
  }
}
```

---

## ✨ Example Usage

### Define your schema:
```dart
import 'package:web/utils/validation.dart';

class Register {
  final String firstName;
  final String lastName;
  final String email;
  final String emailConfirm;
  final String password;

  Register({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.emailConfirm,
    required this.password,
  });

  factory Register.fromFormData(Map<String, String> formData) {
    final register = Register(
      firstName: formData["first_name"] ?? "",
      lastName: formData["last_name"] ?? "",
      email: formData["email"] ?? "",
      emailConfirm: formData["email_confirm"] ?? "",
      password: formData["password"] ?? "",
    );

    // Create and run validator
    Validator validator = Validator(schema: register)
      ..addValidator("firstName", [EmptyString(), StringLength(stringLength: 2)])
      ..addValidator("lastName", [EmptyString(), StringLength(stringLength: 2)])
      ..addValidator("email", [EmptyString(), ValidEmail()])
      ..addValidator("emailConfirm", [EmptyString(), FieldsMatch(matchField: "email")])
      ..addValidator("password", [EmptyString(), StringLength(stringLength: 8)]);

    validator.validate();

    return register;
  }
}
```

---

## 🔄 Using `ValidationException` Inside a Shelf handler

```dart
@override
Future<Response> post(Request request) async {
  final body = await request.readAsString();
  final formData = Uri.splitQueryString(body);

  try {
    final registerData = Register.fromFormData(formData);
    // Proceed with successful data
  } on ValidationException catch (error) {
    print("Validation errors: ${error.errors}");
    return Response.badRequest(body: jsonEncode(error.errors));
  }
}
```

---

## 🏃 Validators

| Validator       | Description                                      | Example Usage                                                                 |
|----------------|--------------------------------------------------|--------------------------------------------------------------------------------|
| `EmptyString`   | Fails if the string is empty or only whitespace | `addValidator('name', [EmptyString()])`                                       |
| `StringLength`  | Ensures string is at least a certain length     | `addValidator('password', [StringLength(stringLength: 8)])`                   |
| `ValidEmail`    | Validates a basic email format                  | `addValidator('email', [ValidEmail()])`                                       |
| `FieldsMatch`   | Verifies one field matches another              | `addValidator('confirmPassword', [FieldsMatch(matchField: 'password')])`      |

---

## 🔧 Extending with Custom Validators

```dart
class MinNumber extends ValidationBase {
  final int min;
  MinNumber(this.min);

  @override
  void validate(String value, String attrName, ValidationType validationErrors, {Object? schema}) {
    if (int.tryParse(value) == null || int.parse(value) < min) {
      validationErrors[attrName] ??= [];
      validationErrors[attrName]!.add({"error": "Must be at least \$min"});
    }
  }
}
```

---

## ⚖️ License

MIT

