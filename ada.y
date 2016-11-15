%{

/* Kyle Quinn
   Ada Grammar
   CSCI 364 Compiler Construction
   File: ada.y
*/

#include <stdio.h>
/* #include <stdlib.h> */
/* #include <math.h> */
/* #include <ctype.h> */
/* #include <string.h> */
#include "utility.h"
#include "binary_tree.h"
#include "outerContext.h"
#include "symbolTable.h"

    extern int lineno;
    int yydebug = 1;
    idnodeptr id_data;

%}

%token IS BEG END PROCEDURE ID NUMBER TYPE ARRAY RAISE OTHERS
%token RECORD IN OUT RANGE CONSTANT DERIVES EXCEPTION NULLWORD LOOP IF STAR
%token THEN ELSEIF ELSE EXIT WHEN AND OR EQ NEQ LT GT GTE LTE TICK
%token NOT EXP ARROW OF DOTDOT ENDIF ENDREC ENDLOOP EXITWHEN

%type <integer> NUMBER
%type <integer> constant_option
%type <integer> constant_expression

%type <var> ID
%type <var> identifier
%type <var> procedure_specification
%type <var> procedure_header
%type <var> mode
%type <var> type_name
%type <var> main_specification

%type <expr_node_ptr> formal_parameter_part
%type <expr_node_ptr> parameters
%type <expr_node_ptr> actual_parameter_part

%type <id_list_ptr> identifier_list

%union {
	int integer;
	char *var;
    struct bin_tree *expr_node_ptr;
    struct node *expr_list;
    struct symbol *symbol_table_ptr;
    struct idnode *id_list_ptr;
    struct exprNode *exprN;
}

%%
program                        : main_body {printf ("\n*******\nDone.\n*******\n");}
                               ;
main_body                      : main_specification IS declarative_part_sequence BEG
                               /* { */
                               /* /\*     if(Stack.top >= 1){ *\/ */
                               /*       if(top >= 1){ */
                               /*           printf("got here in mainbody\n"); */
                               /*         bin_tree *search = search_for_parent($1); */
                               /*     } */
                               /* } */
                                 sequence_of_statements exception_part the_end
                               ;
main_specification             : PROCEDURE identifier
                               {
                                   print_inorder(Stack.stk[top-1].root);
                                   push($2);
                               }  
                               ;
procedure_body                 : procedure_specification IS declarative_part_sequence BEG sequence_of_statements exception_part the_end
                               ;
the_end                        : END ';'
                               {
                                   while(top > 1){
                                       pop();
                                   }
                               }
procedure_specification        : procedure_header formal_parameter_part
                               {
                                   $$ = $1;
                                   if(top > 1){                                                                          
                                       insert($1, &(Stack.stk[top-1].root));
                                       bin_tree *find_inserted = searchTree($1, Stack.stk[top-1].root);
                                       find_inserted->data.kind = mallocCopy("procedure");
                                       find_inserted->data.parent_type = NULL;
                                   }
                               }
                               ;
procedure_header               : PROCEDURE identifier
                               {
                                   $$ = $2;
                                   /* offset = 4; */
                                   push($2);
                               }
                               ;
formal_parameter_part          : '(' parameters ')'
                               {
                                   $$ = $2;
                               }
                               | /* empty */
                               {
                                   $$ = NULL;
                               }
                               ;
parameters                     : identifier_list ':' mode type_name ';' parameters
                               {
                                   $$ = NULL;
                               }
                               | identifier_list ':' mode type_name
                               {
                                   $$ = NULL;
                               }
                               ;
identifier_list                : identifier
                               {
                                 id_data = addName($1, id_data);
                                 $$ = id_data;
                               }
                               | identifier ',' identifier_list 
                               {
                                 id_data = addName($1, id_data);
                                 id_data->next = (struct idnode*)malloc(sizeof(struct idnode));
                                 $$ = id_data;
                                 id_data->next = $3;
                               }
                               ;
mode                           : IN 
                               {$$ = mallocCopy("in");}
                               | OUT
                               {$$ = mallocCopy("out");}
                               | IN OUT
                               {$$ = mallocCopy("in out");}
                               | /* empty */
                               {$$ = mallocCopy("in");}
                               ;
type_name                      : identifier {$$ = $1;}
                               ; 
declarative_part_sequence      : declarative_part procedure_sequence
                               ;
procedure_sequence             : procedure_body procedure_sequence
                               | /* empty */
                               ;
declarative_part               : decl ';' declarative_part
                               | /* empty */
                               /* { */
                               /*     if(top >= 1){ */
                               /*         bin_tree *search = search_for_parent(Stack.stk[top-1].name); */
                               /*     } */
                               /* } */
                               ; 
decl                           : array_type_definition 
				               | record_type_definition
				               | name_type_definition 
                               | variable_declaration
				               | constant_variable_declaration
				               | exception_type_definition
                               ;
array_type_definition          : TYPE identifier IS ARRAY '(' constant_option DOTDOT constant_option ')' OF type_name
                               {
                                   int check = addSymbol($2);
                                   if(check != -1){
                                       bin_tree* newArr = searchTree($2, Stack.stk[top-1].root);
                                       newArr->data.kind = mallocCopy("array");
                                       newArr->data.lower = $6;
                                       newArr->data.upper = $8;
                                       bin_tree* findType = search_for_parent($11);
                                       newArr->data.component_type = findType;
                                       int length = $8-$6;
                                       newArr->data.size = length * findType->data.size;
                                   }
                               }
                               ;
constant_option                : NUMBER {$$ = $1;}
                               ;
constant_expression            : NUMBER {$$ = $1;}
                               ;
record_type_definition         : TYPE identifier IS RECORD component_list ENDREC
                               ;
component_list                 : variable_declaration ';' component_list
                               | variable_declaration ';'
                               ;
variable_declaration           : identifier_list ':' type_name
                               {
                                   parse_var_id_list($1, $3);
                                   id_data = NULL;

                                   printf("line#: %d - ", lineno);
                                   print_list($1);
                                   printf(": %s \n", $3);
                               }
                               ; 
name_type_definition           : TYPE identifier IS RANGE constant_option DOTDOT constant_option
                               {
                                   int check = addSymbol($2);
                                   if(check != -1){
                                       bin_tree *newRange = searchTree($2, Stack.stk[top-1].root);
                                       newRange->data.kind = mallocCopy("named type");
                                       newRange->data.parent_type = NULL;
                                   }
                               }
                               ;
constant_variable_declaration  : identifier_list ':' CONSTANT DERIVES constant_expression
                               ;
exception_type_definition      : identifier_list ':' EXCEPTION
                               {
                                   parse_exception_list($1);
                                   id_data = NULL;
                               }
                               ;
sequence_of_statements         : statement_type sequence_of_statements
                               | /* empty */
                               ;
statement_type                 : NULLWORD ';'
                               | assignment_statement ';'
                               | procedure_call ';'
                               | loop_statement ';'
                               | if_statement ';'
                               | raise_exception ';'
                               | expression ';'
                               ;
assignment_statement           : identifier DERIVES expression
                               ;
procedure_call                 : identifier optional_actual_parameter_part
                               ;
loop_statement                 : LOOP sequence_of_statements loop_exit ENDLOOP
                               ;
loop_exit                      : EXIT ';'
                               | EXITWHEN expression ';'
                               | /* empty */
                               ;
if_statement                   : IF expression THEN sequence_of_statements if_more ENDIF
                               ;
if_more                        : ELSEIF expression THEN sequence_of_statements if_more
                               | ELSE sequence_of_statements
                               | /* empty */
                               ;
raise_exception                : RAISE identifier
                               ;
expression                     : relation boolean_operator_list 
                               ;
boolean_operator_list          : boolean_operator relation boolean_operator_list
                               | /* empty */
                               ;
relation                       : simple_expression relational_operator_list
                               ;
relational_operator_list       : relational_operator simple_expression relational_operator_list
                               | /* empty */
                               ;
simple_expression              : term adding_operator_list
                               | '-' term adding_operator_list
                               ;
adding_operator_list           : adding_operator term adding_operator_list
                               | /* empty */
                               ;
term                           : factor multiplying_operator_list
                               ;
multiplying_operator_list      : multiplying_operator factor multiplying_operator_list
                               | /* empty */
                               ;
factor                         : primary primary_list
                               | NOT primary
                               ;
primary_list                   : STAR primary primary_list
                               | /* empty */
                               ;
primary                        : NUMBER
                               {
                                   /* printf("%d, primary NUMBER\n", lineno); */
                                   /* $$ = $1; */
                                   /* $$ = (exprNode*)malloc(sizeof(exprNode*)); */
                                   /* $$->value = $1; */
                               }
                               | identifier
                               {
                                   /* printf("%d, primary ID\n", lineno); */
                                   /* $$ = (exprNode*)malloc(sizeof(exprNode*)); */
                               }
                               | '(' expression ')'
                               {
                                   /* printf("%d, primary (expression)\n", lineno); */
                                   /* $$ = (exprNode*)malloc(sizeof(exprNode*)); */
                                   /* $$ = $2; */
                               }
                               ;
boolean_operator               : AND /* {$$ = 0;} */
                               | OR  /* {$$ = 1;} */
                               ;
relational_operator            : EQ  /* {$$ = 1;} */
                               | NEQ /* {$$ = 2;} */
                               | LTE /* {$$ = 3;} */
                               | GTE /* {$$ = 4;} */
                               | GT  /* {$$ = 5;} */
                               | LT  /* {$$ = 6;} */
                              
                               ;
adding_operator                : '+' /* {$$ = 1;} */
                               | '-' /* {$$ = -1;} */
                               ;
multiplying_operator           : '*' /* {$$ = 1;} */
                               | '/' /* {$$ = -1;} */
                               ;
optional_actual_parameter_part : '(' actual_parameter_part ')'
                               ;

actual_parameter_part          : expression ',' actual_parameter_part
                               {
                                   /* $$ = $1; */
                                   /* $1->data.next_param = $3; */
                               }
                               | expression
                               {
                                   /* $$ = (exprNode*)malloc(sizeof(exprNode*)); */
                                   /* $$ = $1; */
                               }
                               ;
exception_part                 : EXCEPTION exception_body
                               | /* empty */
                               ;
exception_body                 : WHEN choice_sequence ARROW sequence_of_statements exception_body
                               | WHEN OTHERS ARROW sequence_of_statements
                               | /* empty */
                               ;
choice_sequence                : identifier choice_sequence
                               | '|' identifier choice_sequence
                               | /* empty */
                               ;	
identifier                     : ID {$$ = $1;}
                               ;
		 
%%

#include <stdio.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

main(){

    Outer_Context();
	yyparse();

}
