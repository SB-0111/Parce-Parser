import 'dart:io';
import 'lexer.dart';
import 'parser.dart';
import 'evaluator.dart';
import 'objects.dart';

void startRepl() {
  while (true) {
    stdout.write('>> ');
    final source = stdin.readLineSync().toString();
    // var source = 'hola';
    // var source = '1 + 2';
    // var source = '6>=6';

    if (source == 'salir()') {
      print("Nos Fuimos");
      break;
    }
    final Lexer lexer = Lexer(source);
    final parser = Parser(lexer);
    final program = parser.parseProgram();
    Enviroment env = Enviroment();
    final evaluated = evaluate(program, env);
    if (evaluated.runtimeType.toString() != "Null") {
      print(evaluated!.inspect());
    }
  }
}

void main(List<String> args) {
  startRepl();
}
