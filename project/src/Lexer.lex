import java_cup.runtime.*;

%%
%class Lexer
%unicode
%cup
%line
%column

%{
  private boolean debug_mode;
  public  boolean debug()            { return debug_mode; }
  public  void    debug(boolean mode){ debug_mode = mode; }

  private void print_lexeme(int type, Object value){
    if(!debug()){ return; }

    System.out.print("<");
    switch(type){
      case sym.EQUAL:
        System.out.print("="); break;
      case sym.SEMICOL:
        System.out.print(";"); break;
      case sym.PLUS:
        System.out.print("+"); break;
      case sym.MINUS:
        System.out.print("-"); break;
      case sym.MULT:
        System.out.print("*"); break;
      case sym.DIV:
        System.out.print("/"); break;
      case sym.LPAREN:
        System.out.print("("); break;
      case sym.RPAREN:
        System.out.print(")"); break;
      case sym.INTEGER:
        System.out.printf("INT %d", value); break;
      case sym.IDENTIFIER:
        System.out.printf("IDENT %s", value); break;
    }
    System.out.print(">  ");
  }

  private Symbol symbol(int type) {
    print_lexeme(type, null);
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    print_lexeme(type, value);
    return new Symbol(type, yyline, yycolumn, value);
  }

%}

Whitespace = \r|\n|\r\n|" "|"\t"
Letter = [a-zA-Z]
Digit = [0-9]
Char = .
String = .*
IdChar = {Letter} | {Digit} | _
Identifier = {Letter}{IdChar}*
PosInteger = [1-9]{Digit}*
Integer = 0 | {PosInteger}
Float = {Integer}\.{Digit}{Digit}* | \.{Digit}{Digit}*
Rational = {Integer}\/{PosInteger} | {Integer}_{PosInteger}\/{PosInteger}
Comment = #.*"\n" | \/#.*#\/

%%
<YYINITIAL> {
	{Comment}		{ /*return nothing*/ }

	"main"			{ return symbol(sym.MAIN);}
	"bool"			{ return symbol(sym.KBOOL);}
	"char"			{ return symbol(sym.KCHAR);}
	"dict"			{ return symbol(sym.DICT);}
	"int"			{ return symbol(sym.KINT);}
	"rat"			{ return symbol(sym.KRAT);}
	"float"			{ return symbol(sym.KFLOAT);}
	"top"			{ return symbol(sym.TOP);}
	"seq"			{ return symbol(sym.SEQ);}
	"in"         	{ return symbol(sym.IN);        }
	"T"         	{ return symbol(sym.TRUE);        }
	"F"         	{ return symbol(sym.FALSE);        }
	"tdef"         	{ return symbol(sym.TDEF);        }
	"fdef"         	{ return symbol(sym.FDEF);        }
	"void"         	{ return symbol(sym.VOID);        }
	"alias"         { return symbol(sym.ALIAS);        }
	"if"         	{ return symbol(sym.IF);        }
	"elif"         	{ return symbol(sym.ELIF);        }
	"else"         	{ return symbol(sym.ELSE);        }
	"forall"        { return symbol(sym.FORALL);        }
	"while"         { return symbol(sym.WHILE);        }
	"read"         	{ return symbol(sym.READ);        }
	"print"         { return symbol(sym.PRINT);        }
	"return"        { return symbol(sym.RETURN);        }
	"od"        	{ return symbol(sym.OD);        }
	"do"        	{ return symbol(sym.DO);        }
	"fi"        	{ return symbol(sym.FI);        }
	"len"        	{ return symbol(sym.LEN);        }
	"then"        	{ return symbol(sym.THEN);        }
	
	{Rational}		{ return symbol(sym.RATIONAL, yytext());}
	{Float} 	 	{ return symbol(sym.FLOAT, yytext());   }
	{Integer}     	{ return symbol(sym.INTEGER,
                                Integer.parseInt(yytext())); }
	"'"{Char}"'"	{ return symbol(sym.CHARACTER, yytext()); }
	"\""{String}"\""	{ return symbol(sym.CHARACTER, yytext()); }
	{Identifier}  	{ return symbol(sym.IDENTIFIER, yytext());   }

	{Whitespace}  	{ /* do nothing */               }
	"<="          	{ return symbol(sym.LESSEQUAL);     }
	">="          	{ return symbol(sym.MOREEQUAL);     }
	"=="          	{ return symbol(sym.ISEQUAL);     }
	"!="          	{ return symbol(sym.NOTEQUAL);     }
	"{"          	{ return symbol(sym.LCURLY);     }
	"}"          	{ return symbol(sym.RCURLY);     }
	"["          	{ return symbol(sym.LSQUARE);     }
	"]"          	{ return symbol(sym.RSQUARE);     }
	"="          	{ return symbol(sym.EQUAL);      }
	";"           	{ return symbol(sym.SEMICOL);    }
	"+"           	{ return symbol(sym.PLUS);       }
	"-"           	{ return symbol(sym.MINUS);      }
	"*"           	{ return symbol(sym.MULT);       }
	"/"           	{ return symbol(sym.DIV);        }
	"("           	{ return symbol(sym.LPAREN);     }
	")"          	{ return symbol(sym.RPAREN);     }
	"<"          	{ return symbol(sym.LESSTHAN);     }
	">"				{ return symbol(sym.MORETHAN);	}
	"!"          	{ return symbol(sym.NOT);     }
	"&&"          	{ return symbol(sym.AND);     }
	"||"          	{ return symbol(sym.OR);     }
	"^"          	{ return symbol(sym.POWER);     }
	"::"			{ return symbol(sym.DCOLON);		}
	":"				{ return symbol(sym.COLON);		}
	","				{ return symbol(sym.COMMA);	}
	"."				{ return symbol(sym.DOT);	}
}

[^]  {
  System.out.println("file:" + (yyline+1) +
    ":0: Error: Invalid input '" + yytext()+"'");
  return symbol(sym.BADCHAR);
}

