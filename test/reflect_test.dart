import 'package:test/test.dart';
import 'package:shelf_form_validator/src/reflect.dart';

class Example {
  final String name;
  final String email;
  final String password;

  Example({required this.name, required this.email, required this.password});
}

void main() {
  group('getAttributes', () {
    test('returns list of field names', () {
      final obj = Example(name: 'Alice', email: 'a@a.com', password: '1234');
      final attrs = getAttributes(obj);
      expect(attrs, containsAll(['name', 'email', 'password']));
    });
  });

  group('getAttribute', () {
    test('returns correct attribute value', () {
      final obj = Example(
        name: 'Joe',
        email: 'joe@example.com',
        password: 'secret',
      );
      expect(getAttribute(obj, 'name'), equals('Joe'));
      expect(getAttribute(obj, 'email'), equals('joe@example.com'));
    });

    test('returns fallback value if string is empty', () {
      final obj = Example(name: '', email: 'valid@example.com', password: '');
      expect(getAttribute(obj, 'name', value: 'fallback'), equals('fallback'));
      expect(getAttribute(obj, 'password', value: '1234'), equals('1234'));
    });

    test('returns actual value if not null or empty', () {
      final obj = Example(name: 'Joe', email: '', password: 'pass');
      expect(getAttribute(obj, 'name', value: 'fallback'), equals('Joe'));
    });
  });
}
