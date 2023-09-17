enum ObjectType { BOOLEAN, INTEGER, NULL, FLOAT, STRING }

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
