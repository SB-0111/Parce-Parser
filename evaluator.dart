import 'objects.dart';
import 'ast.dart' as ast;

final TRUE = Boolean(true);
final FALSE = Boolean(false);
final NULL = Null();

Object _evaluateBangOperatorExpression(Object right) {
  if (right == TRUE) {
    return FALSE;
  } else if (right == FALSE || right == NULL) {
    return TRUE;
  } else {
    return FALSE;
  }
}

Object _toBooleanObject(bool value) {
  return value ? TRUE : FALSE;
}

Object _evaluateMinusOperatorExpression(Object right) {
  if (right is Integer) {
    return NULL;
  }
  final rightInt = right as Integer;
  return Integer(rightInt.value);
}

Object _evaluatePrefixExpression(String operator, Object right) {
  if (operator == "!") {
    return _evaluateBangOperatorExpression(right);
  } else if (operator == "-") {
    return _evaluateMinusOperatorExpression(right);
  } else {
    return NULL;
  }
}

Object? _evaluateIntegerInfixExpression(
  String operator,
  Object left,
  Object right,
) {
  if (left is! Integer || right is! Integer) {
    return NULL;
  }

  final leftInt = left;
  final rightInt = right;

  switch (operator) {
    case "+":
      return Integer(leftInt.value + rightInt.value);
    case "-":
      return Integer(leftInt.value - rightInt.value);
    case "*":
      return Integer(leftInt.value * rightInt.value);
    case "/":
      return Integer(leftInt.value ~/ rightInt.value);
    case "<":
      return _toBooleanObject(leftInt.value < rightInt.value);
    case "<=":
      return _toBooleanObject(leftInt.value <= rightInt.value);
    case ">":
      return _toBooleanObject(leftInt.value > rightInt.value);
    case ">=":
      return _toBooleanObject(leftInt.value >= rightInt.value);
    case "==":
      return _toBooleanObject(leftInt.value == rightInt.value);
    case "!=":
      return _toBooleanObject(leftInt.value != rightInt.value);
    default:
      return NULL;
  }
}

Object _evaluateInfixExpression(String operator, Object left, Object right) {
  if (left.type() == ObjectType.INTEGER && right.type() == ObjectType.INTEGER) {
    return _evaluateIntegerInfixExpression(operator, left, right) ?? NULL;
  } else if (operator == "==" && left == right) {
    return TRUE;
  } else if (operator == "!=" && left != right) {
    return TRUE;
  } else {
    return FALSE;
  }
}

Object? evaluate(ast.ASTNode node, [Enviroment? env]) {
  if (node is ast.Program) {
    return _evaluate_program(node, env);
  } else if (node is ast.ExpressionStatement) {
    if (node.expression != null) {
      return evaluate(node.expression!, env);
    }
  } else if (node is ast.Integer) {
    return Integer(node.value as int);
  } else if (node is ast.Boolean) {
    return _toBooleanObject(node.value as bool);
  } else if (node is ast.Prefix) {
    final right = evaluate(node.right as ast.ASTNode, env);
    if (right != null) {
      return _evaluatePrefixExpression(node.operator, right);
    }
  } else if (node is ast.Infix) {
    final left = evaluate(node.left, env);
    final right = evaluate(node.right as ast.ASTNode, env);
    if (left != null && right != null) {
      return _evaluateInfixExpression(node.operator, left, right);
    }
  } else if (node is ast.Block) {
    return _evaluate_block_statement(node, env);
  } else if (node is ast.If) {
    return _evaluateIfExpression(node, env);
  } else if (node is ast.ReturnStatement) {
    final returnValues = evaluate(node.returnValue as ast.ASTNode, env);
    if (returnValues != null) {
      return Return(returnValues);
    } else {
      throw Exception('Return value cannot be null');
    }
  } else if (node is ast.LetStatement) {
    final value = evaluate(node.value!, env);
    final real = value;
    if (value != null) {
      env!.set(node.name!.value, value);
    }
  } else if (node is ast.Identifier) {
    return _evaluate_identifier(node, env);
  }

  return NULL;
}

Object _evaluate_identifier(ast.Identifier node, [Enviroment? env]) {
  final value = env?.get(node.value);
  if (value != null) {
    return value;
  }
  throw Exception('Variable ${node.value} not found in the environment');
  // return NULL;
}

Object? _evaluateStatements(List<ast.Statement> statements, [Enviroment? env]) {
  Object? result = NULL;
  for (final statement in statements) {
    result = evaluate(statement, env);
  }
  return result;
}

bool _isTruthy(Object obj) {
  return obj != NULL && obj != FALSE;
}

Object? _evaluateIfExpression(ast.If ifExpression, [Enviroment? env]) {
  final condition = evaluate(ifExpression.condition as ast.ASTNode, env);
  if (_isTruthy(condition!)) {
    return _evaluateStatements(ifExpression.consequence!.statements, env);
  } else if (ifExpression.alternative != null) {
    return _evaluateStatements(ifExpression.alternative!.statements, env);
  }
  return NULL;
}

Object? _evaluate_program(ast.Program program, [Enviroment? env]) {
  Object? result;
  for (final statement in program.statements) {
    result = evaluate(statement, env);

    if (result != null && result.type() == ObjectType.RETURN) {
      return (result as Return).value;
    }
  }
  return result;
}

Object? _evaluate_block_statement(ast.Block block, [Enviroment? env]) {
  Object? result;
  for (final statement in block.statements) {
    result = evaluate(statement, env);

    if (result != null && (result.type() == ObjectType.RETURN)) {
      return result;
    }
  }
  return result;
}
