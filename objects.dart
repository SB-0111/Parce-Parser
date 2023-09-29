import 'ast.dart';

enum ObjectType { BOOLEAN, INTEGER, NULL, FLOAT, STRING, RETURN, FUNCTION }

abstract class Object {
  ObjectType type();
  String inspect();
}

class Integer extends Object {
  int value;

  Integer(this.value);

  @override
  ObjectType type() {
    return ObjectType.INTEGER;
  }

  @override
  String inspect() {
    return value.toString();
  }
}

class Boolean extends Object {
  bool value;

  Boolean(this.value);

  @override
  ObjectType type() {
    return ObjectType.BOOLEAN;
  }

  @override
  String inspect() {
    return value.toString();
  }
}

class Null extends Object {
  @override
  ObjectType type() {
    return ObjectType.NULL;
  }

  @override
  String inspect() {
    return 'nulo';
  }
}

class Float extends Object {
  double value;

  Float(this.value);

  @override
  ObjectType type() {
    return ObjectType.FLOAT;
  }

  @override
  String inspect() {
    return value.toString();
  }
}

class Return extends Object {
  Object value;

  Return(this.value);

  @override
  ObjectType type() {
    return ObjectType.NULL;
  }

  @override
  String inspect() {
    return value.inspect();
  }
}

//Esta clase es la que va a utilizar para guardar las variables
class Enviroment {
  Map<String, Object> store = {};
  Map<String, Object> outer = {};

  Enviroment([this.outer = const {}]);

  dynamic get(String name) {
    try {
      return store[name];
    } catch (e) {
      if (outer[name] != null) {
        return outer[name];
      } else {
        throw Exception('Variable no definida');
      }
    }
  }

  void set(String name, dynamic value) {
    store[name] = value;
  }

  void delete(String name) {
    store.remove(name);
  }
}

class Functions extends Object {
  List<String> parameters;
  Block body;
  Enviroment env;

  Functions(this.parameters, this.body, this.env);

  @override
  ObjectType type() {
    return ObjectType.FUNCTION;
  }

  @override
  String inspect() {
    parameters.join(', ');
    return 'funcion($parameters) {\n${body.toString()}\n}';
  }
}

class StringObject extends Object {
  String value;

  StringObject(this.value);

  @override
  ObjectType type() {
    return ObjectType.STRING;
  }

  @override
  String inspect() {
    return value;
  }
}
