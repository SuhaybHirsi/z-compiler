# Lexer and Parser

Please put your Lexer.lex and Parser.cup files into the src subdirectory.

To build, issue `make`.

To test, issue `make test`.

java -cp bin;lib/java-cup-11b-runtime.jar Main show-lexing input_file
java -cp bin;lib/java-cup-11b-runtime.jar Main show-parsing input_file | dot -Tpng > parser.png