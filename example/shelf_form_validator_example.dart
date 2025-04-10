import 'package:shelf_form_validator/shelf_form_validator.dart';

class Login {
  final String email;
  final String password;

  Login({required this.email, required this.password});

  factory Login.fromForm(Map<String, String> data) {
    final login = Login(
      email: data['email'] ?? '',
      password: data['password'] ?? '',
    );

    final validator =
        Validator(schema: login)
          ..addValidator('email', [EmptyString(), ValidEmail()])
          ..addValidator('password', [
            EmptyString(),
            StringLength(stringLength: 8),
          ]);

    validator.validate();

    return login;
  }
}
