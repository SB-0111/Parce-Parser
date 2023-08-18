import 'dart:io';
import 'lexer.dart';
import 'tokens.dart';

void startRepl() {
  while (true) {
    stdout.write("Enter a command: ");
    stdout.write('>> ');
    final source = stdin.readLineSync();

    if (source == 'salir()') {
      print("Nos Fui");
      break;
    }

    final lexer = Lexer(source!);
    Token token;

    do {
      token = lexer.nextToken();
      if (token.type != TokenType.EOF) {
        print("Token: ${token.type}, Literal: ${token.literal}");
      }
    } while (token.type != TokenType.EOF);
  }
}
