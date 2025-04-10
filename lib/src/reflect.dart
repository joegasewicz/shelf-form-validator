import 'dart:mirrors';

/// Returns a list of instance variable names (as strings) from the given object.
///
/// This uses Dart's `dart:mirrors` to reflect on the runtime type of the object
/// and extract all declared instance fields, excluding static members and
/// constructor symbols.
///
/// Example:
/// ```dart
/// class User {
///   final String name;
///   final String email;
///   User(this.name, this.email);
/// }
///
/// final fields = getAttributes(User('Joe', 'joe@example.com'));
/// print(fields); // ['name', 'email']
/// ```
List<String> getAttributes(Object schemaObject) {
  Type type = schemaObject.runtimeType;
  final List<String> properties = [];
  final mirror = reflectClass(type);
  for (var decl in mirror.declarations.values) {
    final propName = MirrorSystem.getName(decl.simpleName);
    final className = MirrorSystem.getName(reflectClass(type).simpleName);
    if (!propName.contains(".") && propName != className) {
      properties.add(propName);
    }
  }
  return properties;
}

/// Retrieves the value of a named attribute from an object using reflection.
///
/// If an optional [value] is provided and the actual attribute value is `null`
/// or an empty string, this function returns the fallback [value].
///
/// Example:
/// ```dart
/// final user = User('Joe', '');
/// final name = getAttribute(user, 'name');         // returns 'Joe'
/// final email = getAttribute(user, 'email', value: 'N/A'); // returns 'N/A'
/// ```
dynamic getAttribute(Object obj, String name, {dynamic value}) {
  final instanceMirror = reflect(obj);
  var attrValue = instanceMirror.getField(Symbol(name)).reflectee;
  if (value != null) {
    if (attrValue == null ||
        (attrValue is String && attrValue.trim().isEmpty)) {
      return value;
    }
  }
  return attrValue;
}
