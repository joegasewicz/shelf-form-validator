import 'package:shelf_form_validator/src/reflect.dart';

import 'validator.dart';

/// Base class for all validation rules.
///
/// All validators must extend this class and implement the [validate] method.
abstract class ValidationBase {
  /// Validates a single field value.
  ///
  /// - [value]: the actual value to validate.
  /// - [attrName]: the name of the field being validated.
  /// - [validationErrors]: the shared error map to add validation errors to.
  /// - [schema]: the entire object being validated, useful for cross-field comparisons.
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  });
}

/// Validator that checks if a string is not empty or blank.
///
/// Example:
/// ```dart
/// validator.addValidator('name', [EmptyString()]);
/// ```
class EmptyString extends ValidationBase {
  @override
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  }) {
    if (value == "" || value.trim().isEmpty) {
      final error = {"error": "Must not be an empty string."};
      if (validationErrors[attrName] != null) {
        validationErrors[attrName]?.add(error);
      }
    }
  }
}

/// Validator that checks if a string meets a minimum length.
///
/// Example:
/// ```dart
/// validator.addValidator('username', [StringLength(stringLength: 4)]);
/// ```
class StringLength extends ValidationBase {
  int stringLength;

  StringLength({required this.stringLength});

  @override
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  }) {
    if (value.trim().length < stringLength) {
      final error = {
        "error": "Expected string length to be at least $stringLength.",
      };
      if (validationErrors[attrName] != null) {
        validationErrors[attrName]?.add(error);
      }
    }
  }
}

/// Validator that checks if a string is a valid email address.
///
/// Example:
/// ```dart
/// validator.addValidator('email', [ValidEmail()]);
/// ```
class ValidEmail extends ValidationBase {
  @override
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  }) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w+$");
    if (!regex.hasMatch(value)) {
      final error = {"error": "You must enter a valid email."};
      if (validationErrors[attrName] != null) {
        validationErrors[attrName]?.add(error);
      }
    }
  }
}

/// Validator that checks if two fields in the schema match.
///
/// Useful for fields like `password` and `confirmPassword`.
///
/// Example:
/// ```dart
/// validator.addValidator('confirmPassword', [FieldsMatch(matchField: 'password')]);
/// ```
class FieldsMatch extends ValidationBase {
  String matchField;
  String? errorMessage;

  FieldsMatch({required this.matchField, this.errorMessage});

  @override
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  }) {
    final matchResult = getAttribute(schema!, matchField);
    if (value != matchResult) {
      final error = {
        "error":
            errorMessage?.trim().isNotEmpty == true
                ? errorMessage!
                : "Fields '$attrName' and '$matchField' should match",
      };
      if (validationErrors[attrName] != null) {
        validationErrors[attrName]?.add(error);
      }
    }
  }
}
