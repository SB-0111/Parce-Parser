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

class Expression extends ASTNode {
  final Token token;

  Expression(this.token);

  @override
  String tokenLiteral() {
    return token.literal;
  }
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
    final out = <String>[];
    for (final statement in statements) {
      out.add(statement.toString());
    }

    return out.join('');
  }
}

class Identifier extends Expression {
  final String value;

  Identifier(Token token, this.value) : super(token);

  @override
  String toString() {
    return value;
  }
}

class LetStatement extends Statement {
  late final Identifier? name;
  late final Expression? value;

  LetStatement(Token token, {this.name, this.value}) : super(token);

  @override
  String toString() {
    return '${tokenLiteral()} ${name.toString()} = ${value.toString()};';
  }
}

class ReturnStatement extends Statement {
  late final Expression? returnValue;

  ReturnStatement(Token token, {this.returnValue}) : super(token);

  @override
  String toString() {
    return '${tokenLiteral()} ${returnValue.toString()};';
  }
}

class ExpressionStatement extends Statement {
  late final Expression? expression;

  ExpressionStatement(Token token, Expression expression)
      : expression = expression,
        super(token);

  @override
  String toString() {
    return expression.toString();
  }
}

class Integer extends Expression {
  int? value;

  Integer(Token? token, {int? value}) : super(token!) {
    this.value = value;
  }
  @override
  String toString() {
    return value.toString();
  }
}

class Prefix extends Expression {
  final String operator;
  late final Expression? right;

  Prefix(Token token, this.operator, {this.right}) : super(token);

  @override
  String toString() {
    return '($operator${right.toString()})';
  }
}

class Infix extends Expression {
  final Expression left;
  final String operator;
  late final Expression? right;

  Infix(Token token, this.left, this.operator) : super(token);

  @override
  String toString() {
    return '(${left.toString()} $operator ${right.toString()})';
  }
}

class Boolean extends Expression {
  final bool? value;

  Boolean(Token token, bool bool, {this.value}) : super(token);

  @override
  String toString() {
    return tokenLiteral();
  }
}

class Block extends Statement {
  final List<Statement> statements;

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

class Functions extends Expression {
  late final List<Identifier> parameters;
  late final Block? body;

  Functions(Token token, {this.parameters = const [], this.body})
      : super(token);

  @override
  String toString() {
    final paramList =
        parameters.map((parameter) => parameter.toString()).join(', ');
    return '${tokenLiteral()}($paramList) ${body.toString()}';
  }
}

class Call extends Expression {
  final Expression function;
  late final List<Expression>? arguments;

  Call(Token token, this.function, {this.arguments}) : super(token);

  @override
  String toString() {
    assert(arguments != null);
    final argList =
        arguments!.map((argument) => argument.toString()).join(', ');
    return '${function.toString()}($argList)';
  }
}
