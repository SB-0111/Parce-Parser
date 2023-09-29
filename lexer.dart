import 'tokens.dart';

class Lexer {
  String _source;
  String _character = '';
  int _readPosition = 0;
  int _position = 0;

  Lexer(this._source) {
    _readCharacter();
  }

  Token nextToken() {
    _skipWhitespace();

    if (_match(RegExp(r'^=$'))) {
      if (_peekCharacter() == '=') {
        final token = _makeTwoCharacterToken(TokenType.EQ);
        return token;
      } else {
        final token = Token(TokenType.ASSIGN, _character);
        _readCharacter();
        return token;
      }
    } else if (_match(RegExp(r'^\+$'))) {
      final token = Token(TokenType.PLUS, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^$'))) {
      final token = Token(TokenType.EOF, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^\($'))) {
      final token = Token(TokenType.LPAREN, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^\)$'))) {
      final token = Token(TokenType.RPAREN, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^{$'))) {
      final token = Token(TokenType.LBRACE, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^}$'))) {
      final token = Token(TokenType.RBRACE, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^,$'))) {
      final token = Token(TokenType.COMMA, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^;$'))) {
      final token = Token(TokenType.SEMICOLON, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^-$'))) {
      final token = Token(TokenType.MINUS, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^/$'))) {
      final token = Token(TokenType.DIVISION, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^\*$'))) {
      final token = Token(TokenType.MULTIPLICATION, _character);
      _readCharacter();
      return token;
    } else if (_match(RegExp(r'^<$'))) {
      if (_peekCharacter() == '=') {
        final token = _makeTwoCharacterToken(TokenType.LTE);
        return token;
      } else {
        final token = Token(TokenType.LT, _character);
        _readCharacter();
        return token;
      }
    } else if (_match(RegExp(r'^>$'))) {
      if (_peekCharacter() == '=') {
        final token = _makeTwoCharacterToken(TokenType.GTE);
        return token;
      } else {
        final token = Token(TokenType.GT, _character);
        _readCharacter();
        return token;
      }
    } else if (_match(RegExp(r'^!$'))) {
      if (_peekCharacter() == '=') {
        final token = _makeTwoCharacterToken(TokenType.DIF);
        return token;
      } else {
        final token = Token(TokenType.NEGATION, _character);
        _readCharacter();
        return token;
      }
    } else if (_isLetter(_character)) {
      final literal = _readIdentifier();
      final tokenType = lookupTokenType(literal);
      return Token(tokenType, literal);
    } else if (_isNumber(_character)) {
      final literal = _readNumber();
      return Token(TokenType.INTEGER, literal);
    } else {
      final token = Token(TokenType.ILLEGAL, _character);
      _readCharacter();
      return token;
    }
  }

  bool _isLetter(String character) {
    return RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ_]$').hasMatch(character);
  }

  bool _isNumber(String character) {
    return RegExp(r'^\d$').hasMatch(character);
  }

  Token _makeTwoCharacterToken(TokenType tokenType) {
    final prefix = _character;
    _readCharacter();
    final suffix = _character;
    final token = Token(tokenType, '$prefix$suffix');
    _readCharacter();
    return token;
  }

  void _readCharacter() {
    if (_readPosition >= _source.length) {
      _character = '';
    } else {
      _character = _source[_readPosition];
    }

    _position = _readPosition;
    _readPosition++;
  }

  String _readIdentifier() {
    final initialPosition = _position;

    var isFirstLetter = true;
    while (_isLetter(_character) || (!isFirstLetter && _isNumber(_character))) {
      _readCharacter();
      isFirstLetter = false;
    }

    return _source.substring(initialPosition, _position);
  }

  String _readNumber() {
    final initialPosition = _position;

    while (_isNumber(_character)) {
      _readCharacter();
    }

    return _source.substring(initialPosition, _position);
  }

  String _peekCharacter() {
    if (_readPosition >= _source.length) {
      return '';
    }

    return _source[_readPosition];
  }

  void _skipWhitespace() {
    while (RegExp(r'^\s$').hasMatch(_character)) {
      _readCharacter();
    }
  }

  bool _match(RegExp pattern) {
    return pattern.firstMatch(_character) != null;
  }
}
