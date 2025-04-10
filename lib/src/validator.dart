import 'package:shelf_form_validator/src/reflect.dart';
import 'package:shelf_form_validator/src/validators.dart';

/// A map representing validation errors per field, where each field maps
/// to a list of error message maps.
typedef ValidationType = Map<String, List<Map<String, String>>>;

/// A list of validator instances used to validate a single field.
typedef Validators = List<ValidationBase>;

/// An exception that holds validation errors collected from a Validator.
class ValidationException implements Exception {
  final ValidationType errors;
  ValidationException(this.errors);

  ValidationType getErrors() => errors;
}

/// A validation engine that registers field-level validators and validates
/// an object schema by reflecting its fields.
class Validator {
  final Map<String, Map<String, List<ValidationBase>>> _validators = {};
  ValidationType validationErrors = {};
  Object schema;

  /// Adds a list of validators for a specific field name.
  ///
  /// Example:
  /// ```dart
  /// final validator = Validator(schema: user);
  /// validator.addValidator('email', [EmptyString(), ValidEmail()]);
  /// ```
  Validator({required this.schema});

  void addValidator(String name, Validators validators) {
    _validators[name] = {"validators": validators};
    validationErrors[name] = [];
  }

  /// Validates all registered fields and their validators against the schema.
  /// Throws [ValidationException] if any errors are found.
  ///
  /// Example:
  /// ```dart
  /// try {
  ///   validator.validate();
  /// } on ValidationException catch (e) {
  ///   print(e.getErrors());
  /// }
  /// ```
  void validate() {
    final attributesNames = getAttributes(schema);
    for (final attrName in attributesNames) {
      final attrValue = getAttribute(schema, attrName);
      if (_validators[attrName] != null) {
        for (var validator in _validators[attrName]!["validators"]!) {
          validator.validate(
            attrValue,
            attrName,
            validationErrors,
            schema: schema,
          );
        }
      }
    }
    for (var error in validationErrors.entries) {
      if (error.value.isNotEmpty) {
        throw ValidationException(validationErrors);
      }
    }
  }
}
