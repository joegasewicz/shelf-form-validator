import 'package:test/test.dart';
import 'package:shelf_form_validator/shelf_form_validator.dart';

class DummySchema {
  final String email;
  final String password;
  final String confirmPassword;

  DummySchema({
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

void main() {
  group('Validator', () {
    test('passes validation when inputs are valid', () {
      final schema = DummySchema(
        email: 'test@example.com',
        password: '12345678',
        confirmPassword: '12345678',
      );

      final validator =
          Validator(schema: schema)
            ..addValidator('email', [EmptyString(), ValidEmail()])
            ..addValidator('password', [
              EmptyString(),
              StringLength(stringLength: 8),
            ])
            ..addValidator('confirmPassword', [
              FieldsMatch(matchField: 'password'),
            ]);

      expect(() => validator.validate(), returnsNormally);
    });

    test('fails when fields are empty', () {
      final schema = DummySchema(email: '', password: '', confirmPassword: '');

      final validator =
          Validator(schema: schema)
            ..addValidator('email', [EmptyString()])
            ..addValidator('password', [EmptyString()]);

      expect(() => validator.validate(), throwsA(isA<ValidationException>()));
    });

    test('fails on invalid email', () {
      final schema = DummySchema(
        email: 'invalid-email',
        password: '12345678',
        confirmPassword: '12345678',
      );

      final validator = Validator(schema: schema)
        ..addValidator('email', [ValidEmail()]);

      try {
        validator.validate();
        fail('Expected ValidationException');
      } on ValidationException catch (e) {
        expect(e.errors.containsKey('email'), isTrue);
        expect(e.errors['email']!.first['error'], contains('valid email'));
      }
    });

    test('fails when fields do not match', () {
      final schema = DummySchema(
        email: 'test@example.com',
        password: 'abc12345',
        confirmPassword: 'different',
      );

      final validator = Validator(
        schema: schema,
      )..addValidator('confirmPassword', [FieldsMatch(matchField: 'password')]);

      expect(() => validator.validate(), throwsA(isA<ValidationException>()));
    });
  });
}
