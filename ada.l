%{

/* Kyle Quinn
   ada.l
*/
#include "y.tab.h"
#include <stdio.h>
#include <string.h>

int lineno = 0;

%}

%%
[ \t]+                  /*ignore*/
"--".*                  /*ignore*/
[\n]                    {lineno++;}
"is"                    {return IS;}
"if"			{return IF;}
"type"			{return TYPE;}
"end if"		{return ENDIF;}
"end record"		{return ENDREC;}
"end loop"		{return ENDLOOP;}
"exit when"		{return EXITWHEN;}
"of"			{return OF;}
"begin"			{return BEG;}
"end"                   {return END;}
".."			{return DOTDOT;}
"procedure"		{return PROCEDURE;}
"array"			{return ARRAY;}
"record"		{return RECORD;}
"in"			{return IN;}
"out"			{return OUT;}
"range"			{return RANGE;}
"constant"		{return CONSTANT;}
":="			{return DERIVES;}
"exception"		{return EXCEPTION;}
"nullword"		{return NULLWORD;}
"loop"			{return LOOP;}
"then"			{return THEN;}
"elsif"			{return ELSEIF;}
"else"			{return ELSE;}
"exit"			{return EXIT;}
"when"			{return WHEN;}
"and"			{return AND;}
"or"			{return OR;}
"not"			{return NOT;}
"="			{return EQ;}
"/="			{return NEQ;}
">"			{return GT;}
"<"			{return LT;}
">="			{return GTE;}
"<="			{return LTE;}
"=>"                    {return ARROW;}
"**"			{return STAR;}
"raise"			{return RAISE;}
"others"		{return OTHERS;}
[0-9]+  		{yylval.integer = atoi(yytext); return NUMBER;}
[a-zA-Z][a-zA-Z0-9\_]*  {yylval.var = malloc(sizeof(yytext)); yylval.var = strdup(yytext); return ID;} 
.                       {return yytext[0];}
%%

yyerror (char *s){
    printf("%d : %s at the %s symbol.\n", lineno, s, yytext);
    }