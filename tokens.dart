enum TokenType {
  ASSIGN,
  COMMA,
  DIF,
  DIVISION,
  ELSE,
  EOF,
  EQ,
  FALSE,
  FUNCTION,
  IDENTIFIER,
  IF,
  GT,
  GTE,
  ILLEGAL,
  INTEGER,
  LBRACE,
  LET,
  LPAREN,
  LT,
  LTE,
  MINUS,
  MULTIPLICATION,
  NEGATION,
  PLUS,
  RBRACE,
  RETURN,
  RPAREN,
  SEMICOLON,
  TRUE,
  NOT_EQ,
  EQEQ,
  NEQ,
}

class Token {
  final TokenType token_type;
  final String literal;

  Token(this.token_type, this.literal);

  @override
  String toString() {
    return 'Type: $token_type, Literal $literal';
  }
}

TokenType lookupTokenType(String literal) {
  final keywords = {
    'funcion': TokenType.FUNCTION,
    'variable': TokenType.LET,
    'si': TokenType.IF,
    'si_no': TokenType.ELSE,
    'regresa': TokenType.RETURN,
    'verdadero': TokenType.TRUE,
    'falso': TokenType.FALSE,
  };

  return keywords[literal] ?? TokenType.IDENTIFIER;
}
