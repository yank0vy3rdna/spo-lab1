identifier: "[a-zA-Z_][a-zA-Z_0-9]*"; // идентификатор
str: "\"[^\"\\]*(?:\\.[^\"\\]*)*\""; // строка, окруженная двойными кавычками
char: "'[^']'"; // одиночный символ в одинарных кавычках
hex: "0[xX][0-9A-Fa-f]+"; // шестнадцатеричный литерал
bits: "0[bB][01]+"; // битовый литерал
dec: "[0-9]+"; // десятичный литерал
bool: 'true'|'false'; // булевский литерал
list<item>: (item (',' item)*)?; // список элементов, разделённых запятыми

source: sourceItem*;

typeRef: {
    |builtin: 'bool'|'byte'|'int'|'uint'|'long'|'ulong'|'char'|'string';
    |custom: identifier;
    |array: typeRef '[' (',')* ']';
};
funcSignature: typeRef? identifier '(' list<argDef> ')' {
    argDef: typeRef? identifier;
}
sourceItem: {
    |funcDef: funcSignature (statement.block|';');
}
statement: {
    |var: typeRef list<identifier ('=' expr)?> ';'; // for static typing
    |if: 'if' '(' expr ')' statement ('else' statement)?;
    |block: '{' statement* '}';
    |while: 'while' '(' expr ')' statement;
    |do: 'do' block 'while' '(' expr ')' ';';
    |break: 'break' ';';
    |expression: expr ';'
};
expr: { // присваивание через '='
    |binary: expr binOp expr; // где binOp - символ бинарного оператора
    |unary: unOp expr; // где unOp - символ унарного оператора
    |braces: '(' expr ')';
    |call: expr '(' list<expr> ')';
    |indexer: expr '[' list<expr> ']';
    |place: identifier;
    |literal: bool|str|char|hex|bits|dec;
};
