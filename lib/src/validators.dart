import 'package:shelf_form_validator/src/reflect.dart';

import 'validator.dart';

abstract class ValidationBase {
  void validate(
    String value,
    String attrName,
    ValidationType validationErrors, {
    Object? schema,
  });
}

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
