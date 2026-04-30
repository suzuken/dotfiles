%{
// headers
%}

%union{
    expr Expression
    token Token
}

%type<expr> program
%type<expr> expr
%token<token> NUMBER

%left '+'

%%

program
    : expr
    {
        $$ = $1
        yylex.(*Lexer).Result = $$
    }

expr
    : NUMBER
    {
    }
    | expr '+' expr
    {
    }

%%

// body
