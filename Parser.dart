import 'ast.dart';
import 'lexer.dart';
import 'tokens.dart';

typedef PrefixParseFn = Expression? Function();
typedef InfixParseFn = Expression? Function(Expression left);
typedef PrefixParseFns = Map<TokenType, PrefixParseFn>;
typedef InfixParseFns = Map<TokenType, InfixParseFn>;

enum Precedence {
  LOWEST,
  EQUALS,
  LESSGREATER,
  SUM,
  PRODUCT,
  PREFIX,
  CALL,
}

final Map<TokenType, Precedence> PRECEDENCES = {
  TokenType.EQ: Precedence.EQUALS,
  TokenType.DIF: Precedence.EQUALS,
  TokenType.LT: Precedence.LESSGREATER,
  TokenType.GT: Precedence.LESSGREATER,
  TokenType.PLUS: Precedence.SUM,
  TokenType.MINUS: Precedence.SUM,
  TokenType.DIVISION: Precedence.PRODUCT,
  TokenType.MULTIPLICATION: Precedence.PRODUCT,
  TokenType.LPAREN: Precedence.CALL,
};

class Parser {
  final Lexer _lexer;
  Token? _currentToken;
  Token? _peekToken;
  final List<String> _errors = [];
  late final PrefixParseFns _prefixParseFns;
  late final InfixParseFns _infixParseFns;

  Parser(this._lexer) {
    _advanceTokens();
    _advanceTokens();
    _prefixParseFns = _registerPrefixFns();
    _infixParseFns = _registerInfixFns();
  }

  List<String> get errors => _errors;

  Program parseProgram() {
    final program = Program(statements: []);

    while (_currentToken!.token_type != TokenType.EOF) {
      // print(_currentToken!.token_type);
      final statement = _parseStatement();

      if (statement != null) {
        program.statements.add(statement);
      }

      _advanceTokens();
    }

    return program;
  }

  void _advanceTokens() {
    _currentToken = _peekToken;
    _peekToken = _lexer.nextToken();
  }

  Precedence _currentPrecedence() {
    try {
      return PRECEDENCES[_currentToken!.token_type]!;
    } catch (e) {
      return Precedence.LOWEST;
    }
  }

  bool _expectedToken(TokenType tokenType) {
    if (_peekToken!.token_type == tokenType) {
      _advanceTokens();
      return true;
    }

    _expectedTokenError(tokenType);
    return false;
  }

  void _expectedTokenError(TokenType tokenType) {
    final error =
        'Se esperaba que el siguiente token fuera $tokenType pero se obtuvo ${_peekToken!.token_type}';
    _errors.add(error);
  }

  Block _parseBlock() {
    final blockStatement = Block(_currentToken!, []);

    _advanceTokens();

    while (_currentToken!.token_type != TokenType.RBRACE &&
        _currentToken!.token_type != TokenType.EOF) {
      final statement = _parseStatement();

      if (statement != null) {
        blockStatement.statements.add(statement);
      }

      _advanceTokens();
    }

    return blockStatement;
  }

  Boolean _parseBoolean() {
    return Boolean(_currentToken!, _currentToken!.token_type == TokenType.TRUE);
  }

  Call _parseCall(Expression function) {
    final call = Call(_currentToken!, function);
    call.arguments = _parseCallArguments()?.cast<Expression>() ?? [];

    return call;
  }

  List<Expression?>? _parseCallArguments() {
    final arguments = <Expression?>[];

    if (_peekToken!.token_type == TokenType.RPAREN) {
      _advanceTokens();
      return arguments;
    }

    _advanceTokens();
    final expression = _parseExpression(Precedence.LOWEST);
    if (expression != null) {
      arguments.add(expression);
    }

    while (_peekToken!.token_type == TokenType.COMMA) {
      _advanceTokens();
      _advanceTokens();
      final expression = _parseExpression(Precedence.LOWEST);
      if (expression != null) {
        arguments.add(expression);
      }
    }

    if (!_expectedToken(TokenType.RPAREN)) {
      return null;
    }

    return arguments;
  }

  Expression? _parseExpression(Precedence precedence) {
    try {
      // print(_prefixParseFns[_currentToken!.token_type]);
      final prefixParseFn = _prefixParseFns[_currentToken!.token_type];
      if (prefixParseFn == null) {
        final message =
            "No se encontro ninguna funcion para parsear ${_currentToken!.literal} (Token type: ${_currentToken!.token_type})";
        _errors.add(message);
        return null;
      }

      var leftExpression = prefixParseFn();

      while (_peekToken!.token_type != TokenType.SEMICOLON &&
          precedence.index < _peekPrecedence().index) {
        final infixParseFn = _infixParseFns[_peekToken!.token_type];

        if (infixParseFn == null) {
          return leftExpression;
        }

        _advanceTokens();
        leftExpression = infixParseFn(leftExpression!);
      }

      return leftExpression;
    } catch (e) {
      return null;
    }
  }

  ExpressionStatement? _parseExpressionStatement() {
    final expression = _parseExpression(Precedence.LOWEST);

    if (expression == null) {
      // Handle the case where expression is null (an error or unexpected input).
      _errors.add('Failed to parse expression statement.');
      return null;
    }

    if (_peekToken!.token_type == TokenType.SEMICOLON) {
      _advanceTokens();
    }

    return ExpressionStatement(_currentToken!, expression);
  }

  Expression? _parseGroupedExpression() {
    _advanceTokens();
    final expression = _parseExpression(Precedence.LOWEST);

    if (!_expectedToken(TokenType.RPAREN)) {
      return null;
    }

    return expression;
  }

  Functions? _parseFunction() {
    late final Functions function = Functions(_currentToken!);

    if (!_expectedToken(TokenType.LPAREN)) {
      return null;
    }

    function.parameters = _parseFunctionParameters();

    if (!_expectedToken(TokenType.LBRACE)) {
      return null;
    }

    function.body = _parseBlock();

    return function;
  }

  List<Identifier> _parseFunctionParameters() {
    final params = <Identifier>[];

    if (_peekToken!.token_type == TokenType.RPAREN) {
      _advanceTokens();
      return params;
    }

    _advanceTokens();
    final identifier = Identifier(
      _currentToken!,
      _currentToken!.literal,
    );
    params.add(identifier);

    while (_peekToken!.token_type == TokenType.COMMA) {
      _advanceTokens();
      _advanceTokens();
      final identifier = Identifier(
        _currentToken!,
        _currentToken!.literal,
      );
      params.add(identifier);
    }

    if (!_expectedToken(TokenType.RPAREN)) {
      return [];
    }

    return params;
  }

  Identifier _parseIdentifier() {
    return Identifier(
      _currentToken!,
      _currentToken!.literal,
    );
  }

  If? _parseIf() {
    final ifExpression = If(_currentToken!);

    if (!_expectedToken(TokenType.LPAREN)) {
      return null;
    }

    _advanceTokens();
    ifExpression.condition = _parseExpression(Precedence.LOWEST);

    if (!_expectedToken(TokenType.RPAREN)) {
      return null;
    }

    if (!_expectedToken(TokenType.LBRACE)) {
      return null;
    }

    ifExpression.consequence = _parseBlock();

    if (_peekToken!.token_type == TokenType.ELSE) {
      _advanceTokens();
      if (!_expectedToken(TokenType.LBRACE)) {
        return null;
      }
      ifExpression.alternative = _parseBlock();
    }

    return ifExpression;
  }

  Infix _parseInfixExpression(Expression left) {
    assert(_currentToken != null);
    final infix = Infix(_currentToken!, left, _currentToken!.literal);

    final precedence = _currentPrecedence();

    _advanceTokens();

    final right = _parseExpression(precedence);
    if (right == null) {
      // Handle the case where parsing the right expression fails.
      return infix; // Or return null or handle the error appropriately.
    }

    infix.right = right;

    return infix;
  }

  Integer? _parseInt() {
    final integer = Integer(_currentToken!);
    // print(_currentToken!.literal);
    if (int.tryParse(_currentToken!.literal) != null) {
      integer.value = int.parse(_currentToken!.literal);
    } else {
      final message =
          'No se ha podido parsear ${_currentToken!.literal} como entero.';
      _errors.add(message);
      return null;
    }

    return integer;
  }

  LetStatement? _parseLetStatement() {
    final letStatement = LetStatement(_currentToken!);

    if (!_expectedToken(TokenType.IDENTIFIER)) {
      return null;
    }

    letStatement.name = _parseIdentifier();

    if (!_expectedToken(TokenType.ASSIGN)) {
      return null;
    }

    _advanceTokens();
    letStatement.value = _parseExpression(Precedence.LOWEST);

    if (_peekToken!.token_type == TokenType.SEMICOLON) {
      _advanceTokens();
    }

    return letStatement;
  }

  Prefix _parsePrefixExpression() {
    final prefixExpression = Prefix(
      _currentToken!,
      _currentToken!.literal,
    );

    _advanceTokens();
    prefixExpression.right = _parseExpression(Precedence.PREFIX)!;

    return prefixExpression;
  }

  ReturnStatement? _parseReturnStatement() {
    final returnStatement = ReturnStatement(_currentToken!);

    _advanceTokens();
    returnStatement.returnValue = _parseExpression(Precedence.LOWEST);

    if (_peekToken!.token_type == TokenType.SEMICOLON) {
      _advanceTokens();
    }

    return returnStatement;
  }

  Statement? _parseStatement() {
    if (_currentToken!.token_type == TokenType.LET) {
      return _parseLetStatement();
    } else if (_currentToken!.token_type == TokenType.RETURN) {
      return _parseReturnStatement();
    } else {
      return _parseExpressionStatement();
    }
  }

  Precedence _peekPrecedence() {
    try {
      return PRECEDENCES[_peekToken!.token_type]!;
    } catch (e) {
      return Precedence.LOWEST;
    }
  }

  Map<TokenType, InfixParseFn> _registerInfixFns() {
    return {
      TokenType.PLUS: (left) => _parseInfixExpression(left),
      TokenType.MINUS: (left) => _parseInfixExpression(left),
      TokenType.DIVISION: (left) => _parseInfixExpression(left),
      TokenType.MULTIPLICATION: (left) => _parseInfixExpression(left),
      TokenType.EQ: (left) => _parseInfixExpression(left),
      TokenType.DIF: (left) => _parseInfixExpression(left),
      TokenType.LT: (left) => _parseInfixExpression(left),
      TokenType.GT: (left) => _parseInfixExpression(left),
      TokenType.LPAREN: (left) => _parseCall(left),
    };
  }

  Map<TokenType, PrefixParseFn> _registerPrefixFns() {
    return {
      TokenType.FALSE: () => _parseBoolean(),
      TokenType.FUNCTION: () => _parseFunction(),
      TokenType.IDENTIFIER: () => _parseIdentifier(),
      TokenType.IF: () => _parseIf(),
      TokenType.INTEGER: () => _parseInt(),
      TokenType.LPAREN: () => _parseGroupedExpression(),
      TokenType.MINUS: () => _parsePrefixExpression(),
      TokenType.NEGATION: () => _parsePrefixExpression(),
      TokenType.TRUE: () => _parseBoolean(),
    };
  }
}
