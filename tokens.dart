// class TokenType {
//   static const ASSIGN = "ASSIGN";
//   static const PLUS = "PLUS";
//   static const EOF = "EOF";
//   static const LPAREN = "LPAREN";
//   static const RPAREN = "RPAREN";
//   static const LBRACE = "LBRACE";
//   static const RBRACE = "RBRACE";
//   static const COMMA = "COMMA";
//   static const SEMICOLON = "SEMICOLON";
//   static const MINUS = "MINUS";
//   static const DIVISION = "DIVISION";
//   static const MULTIPLICATION = "MULTIPLICATION";
//   static const LT = "LT";
//   static const GT = "GT";
//   static const NOT_EQ = "NOT_EQ";
//   static const NEGATION = "NEGATION";
//   static const INT = "INT";
//   static const ILLEGAL = "ILLEGAL";
//   static const FALSE = "FALSE";
//   static const FUNCTION = "FUNCTION";
//   static const LET = "LET";
//   static const TRUE = "TRUE";
//   static const IF = "IF";
//   static const ELSE = "ELSE";
//   static const RETURN = "RETURN";
//   static const EQ = "EQ";
//   static const STRING = "STRING";
//   static const COLON = "COLON";
//   static const LBRACKET = "LBRACKET";
//   static const IDENTIFIER = "IDENTIFIER";
//   static const DIF = "DIF";
//   static const INTEGER = "INTEGER";
//   static const VAR = 'VARIABLE';
//   static const IDENT = "IDENT";
// }
// // enum TokenType {
// //   ASSIGN,
// //   PLUS,
// //   EOF,
// //   LPAREN,
// //   RPAREN,
// //   LBRACE,
// //   RBRACE,
// //   COMMA,
// //   SEMICOLON,
// //   MINUS,
// //   DIVISION,
// //   MULTIPLICATION,
// //   LT,
// //   GT,
// //   NOT_EQ,
// //   NEGATION,
// //   INT,
// //   ILLEGAL,
// //   FALSE,
// //   FUNCTION,
// //   LET,
// //   TRUE,
// //   IF,
// //   ELSE,
// //   RETURN,
// //   EQ,
// //   STRING,
// //   COLON,
// //   LBRACKET,
// //   IDENTIFIER,
// //   DIF,
// //   INTEGER,
// //   VAR,
// //   IDENT,
// // }

// class Token {
//   final TokenType tokenType;
//   final String literal;

//   Token(this.tokenType, this.literal);

//   @override
//   String toString() {
//     return 'Type: $tokenType, Literal: $literal';
//   }

//   String lookupTokenType(String literal) {
//     final keywords = {
//       'funcion': TokenType.FUNCTION,
//       'variable': TokenType.LET,
//       'si': TokenType.IF,
//       'si_no': TokenType.ELSE,
//       'regresa': TokenType.RETURN,
//       'verdadero': TokenType.TRUE,
//       'falso': TokenType.FALSE,
//     };

//     return keywords[literal] ?? TokenType.IDENTIFIER;
//   }
// }

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
