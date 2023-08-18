class TokenType {
  static const ASSIGN = "ASSIGN";
  static const PLUS = "PLUS";
  static const EOF = "EOF";
  static const LPAREN = "LPAREN";
  static const RPAREN = "RPAREN";
  static const LBRACE = "LBRACE";
  static const RBRACE = "RBRACE";
  static const COMMA = "COMMA";
  static const SEMICOLON = "SEMICOLON";
  static const MINUS = "MINUS";
  static const DIVISION = "DIVISION";
  static const MULTIPLICATION = "MULTIPLICATION";
  static const LT = "LT";
  static const GT = "GT";
  static const NOT_EQ = "NOT_EQ";
  static const NEGATION = "NEGATION";
  static const INT = "INT";
  static const ILLEGAL = "ILLEGAL";
  static const FALSE = "FALSE";
  static const FUNCTION = "FUNCTION";
  static const LET = "LET";
  static const TRUE = "TRUE";
  static const IF = "IF";
  static const ELSE = "ELSE";
  static const RETURN = "RETURN";
  static const EQ = "EQ";
  static const STRING = "STRING";
  static const COLON = "COLON";
  static const LBRACKET = "LBRACKET";
  static const IDENTIFIER = "IDENTIFIER";
}

class Token {
  final String type;
  final String literal;

  Token(this.type, this.literal);
}
