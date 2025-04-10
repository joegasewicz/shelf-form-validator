import 'dart:mirrors';

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
