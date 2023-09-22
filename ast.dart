import 'tokens.dart';

abstract class ASTNode {
  String tokenLiteral();
}

class Statement extends ASTNode {
  final Token token;

  Statement(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }
}

abstract class Expression implements ASTNode {
  Token token;

  Expression(this.token);

  @override
  String tokenLiteral() => token.literal;
}

class Program extends ASTNode {
  late List<Statement> statements;

  Program({required this.statements});

  @override
  String tokenLiteral() {
    if (statements.isNotEmpty) {
      return statements[0].tokenLiteral();
    }
    return '';
  }

  @override
  String toString() {
    List<String> out = [];
    for (var statement in statements) {
      out.add(statement.toString());
    }
    return out.join('');
  }
}

class Identifier extends Expression {
  String value;

  Identifier(Token token, this.value) : super(token);

  @override
  String toString() => value;
}

class LetStatement extends Statement {
  late final Identifier? name;
  late final Expression? value;

  LetStatement(Token token, {this.name, this.value}) : super(token);

  @override
  String toString() => '${tokenLiteral()} $name = $value;';
}

// class ReturnStatement extends Statement {
//   late final Expression? returnValue;

//   ReturnStatement(Token token, {this.returnValue}) : super(token);

//   @override
//   String toString() => '${tokenLiteral()} ${returnValue.toString()};';
// }
class ReturnStatement extends Statement {
  late final Expression? returnValue;

  ReturnStatement(Token token, {Expression? returnValue})
      : returnValue = returnValue, // Initialize returnValue first
        super(token); // Call super constructor last

  @override
  String toString() => '${tokenLiteral()} ${returnValue.toString()};';
}

class ExpressionStatement extends Statement {
  late final Expression? expression;

  ExpressionStatement(Token token, Expression expression)
      : expression = expression,
        super(token);

  @override
  String toString() => expression.toString();
}

class Integer extends Expression {
  int? value;

  Integer(Token? token, {int? value}) : super(token!) {
    this.value = value;
  }

  @override
  String toString() => value.toString();
}

class Prefix extends Expression {
  final String operator;
  Expression? right;

  Prefix(Token token, this.operator, {this.right}) : super(token);

  @override
  String toString() => '($operator$right)';
}

class Infix extends Expression {
  final Expression left;
  final String operator;
  late final Expression? right;

  Infix(Token token, this.left, this.operator) : super(token);

  @override
  String toString() => '(${left.toString()} $operator ${right.toString()})';
}

class Boolean extends Expression {
  final bool? value;

  Boolean(Token token, bool bool, {this.value}) : super(token);

  @override
  String toString() => tokenLiteral();
}

class Block extends Statement {
  List<Statement> statements;

  Block(Token token, this.statements) : super(token);

  @override
  String toString() {
    final out = <String>[];
    for (final statement in statements) {
      out.add(statement.toString());
    }
    return out.join('');
  }
}

class Funcion extends Expression {
  late final List<Identifier> parameters;
  late final Block? body;

  Funcion(Token token, {this.parameters = const [], this.body}) : super(token);

  @override
  String toString() {
    String paramList = parameters.map((param) => param.toString()).join(', ');
    return '${tokenLiteral()}($paramList) ${body.toString()}';
  }
}

class If extends Expression {
  late final Expression? condition;
  late final Block? consequence;
  late final Block? alternative;

  If(Token token, {this.condition, this.consequence, this.alternative})
      : super(token);

  @override
  String toString() {
    var out = 'si ${condition.toString()} ${consequence.toString()}';
    if (alternative != null) {
      out += 'si_no ${alternative.toString()}';
    }
    return out;
  }
}

class Call extends Expression {
  Expression function;
  List<Expression>? arguments;

  Call(Token token, this.function, {this.arguments}) : super(token);

  @override
  String toString() {
    assert(arguments != null);
    final argList = arguments!.map((arg) => arg.toString()).join(', ');
    return '${function.toString()}($argList)';
  }
}
