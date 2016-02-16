/* {SYMBOL}        return 'SYMBOL' */
LETTER          [a-zA-Z]
DIGIT           [0-9]
HEXDIGIT        [a-fA-F0-9]
MNEMONIC        [a-zA-Z][a-zA-Z\.]*
REGISTER        \$[a-z0-9]+
SYMBOL          [a-zA-Z_\.][a-zA-Z0-9_\.]*
FP              [0-9]+\.[0-9]+

%%
"#".*           /* ignore comment */
","             return 'COMMA';
"("             return 'LPAREN';
")"             return 'RPAREN';
".align"        return 'ALIGN';
".ascii"        return 'ASCII';
".asciiz"       return 'ASCIIZ';
".byte"         return 'BYTE';
".data"         return 'DATA';
".double"       return 'DOUBLE';
".extern"       return 'EXTERN';
".float"        return 'FLOAT';
".globl"        return 'GLOBL';
".macro"        return 'MACRO';
".macro_end"    return 'MACROEND';
".half"         return 'HALF';
".kdata"        return 'KDATA';
".ktext"        return 'KTEXT';
".space"        return 'SPACE';
".text"         return 'TEXT';
".word"         return 'WORD';
{MNEMONIC}      return 'MNEMONIC';
{REGISTER}      return 'REGISTER';
\"(\\.|[^"])*\" return 'STRINGLITERAL';
{FP}            return 'FPLITERAL';
0x{HEXDIGIT}+   return 'HEXLITERAL';
{DIGIT}+        return 'INTLITERAL';
\s+             /* skip whitespace */
