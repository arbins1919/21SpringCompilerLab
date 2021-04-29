%{
#include <stdio.h>
%}
%union {
	int type_int;
	float type_float;
	double type_double;
}
%token <type_int> INT
%token <type_float> FLOAT
%token OCT HEX
%token ID
%token SEMI COMMA
%token TYPE 
%token LC RC
%token STRUCT RETURN IF WHILE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%right ASSIGNOP
%left OR
%left AND
%left RELOP
%left PLUS MINUS
%left STAR DIV
%right NOT
%left LP RP LB RB DOT

%%

Program : ExtDefList  
	;
ExtDefList : ExtDef ExtDefList
	|
	; 
ExtDef : Specifier ExtDecList SEMI		
	| Specifier SEMI			
	| Specifier FunDec CompSt		
	;
ExtDecList : VarDec			
	| VarDec COMMA ExtDecList		
	;
Specifier : TYPE
	| StructSpecifier
	;
StructSpecifier : STRUCT OptTag LC DefList RC
	| STRUCT Tag
	;
OptTag : ID
	| 
	;
Tag : ID
	;

VarDec : ID
	| VarDec LB INT RB
	;
FunDec : ID LP VarList RP
	| ID LP RP
	;
VarList : ParamDec COMMA VarList
	| ParamDec
	;
ParamDec : Specifier VarDec
	;

//Statements
CompSt : LC DefList StmtList RC
	;
StmtList : Stmt StmtList
	|
	; 
Stmt : Exp SEMI
	| CompSt
	| RETURN Exp SEMI
	| IF LP Exp RP Stmt %prec LOWER_THAN_ELSE
	| IF LP Exp RP Stmt ELSE Stmt
	| WHILE LP Exp RP Stmt
	;

DefList : Def DefList
	|
	; 
Def : Specifier DecList SEMI
	;
DecList : Dec	
	| Dec COMMA DecList
	;
Dec : VarDec
	| VarDec ASSIGNOP Exp
	;

Exp : Exp ASSIGNOP Exp
	| Exp AND Exp
	| Exp OR Exp
	| Exp RELOP Exp
	| Exp PLUS Exp
	| Exp MINUS Exp
	| Exp STAR Exp
	| Exp DIV Exp
	| LP Exp RP
	| MINUS Exp
	| NOT Exp
	| ID LP Args RP
	| ID LP RP
	| Exp LB Exp RB
	| Exp DOT ID
	| ID
	| INT
	| FLOAT
	;
Args : Exp COMMA Args
	| Exp
	;

%%

#include "lex.yy.c"
int main(int argc, char** argv)
{
	if (argc <= 1) return 1;
	FILE* f = fopen(argv[1], "r");
	if (!f)
	{
		perror(argv[1]);
		return 1;
	}
	yyrestart(f);
	yyparse();
	return 0;
}
yyerror(char* msg){
	fprintf(stderr, "error:%s\n",msg);
}