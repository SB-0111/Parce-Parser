enum ObjectType { BOOLEAN, INTEGER, NULL, FLOAT, STRING, RETURN }

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

  Object? get(String name) {
    return store[name];
  }

  void set(String name, Object value) {
    store[name] = value;
  }

  void delete(String name) {
    store.remove(name);
  }
}
