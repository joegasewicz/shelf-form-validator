import 'package:shelf_form_validator/src/reflect.dart';
import 'package:shelf_form_validator/src/validators.dart';

typedef ValidationType = Map<String, List<Map<String, String>>>;
typedef Validators = List<ValidationBase>;

class ValidationException implements Exception {
  final ValidationType errors;
  ValidationException(this.errors);

  ValidationType getErrors() => errors;
}

class Validator {
  final Map<String, Map<String, List<ValidationBase>>> _validators = {};
  ValidationType validationErrors = {};
  Object schema;

  Validator({required this.schema});

  void addValidator(String name, Validators validators) {
    _validators[name] = {"validators": validators};
    validationErrors[name] = [];
  }

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
