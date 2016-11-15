/* Kyle Quinn
   Ada Grammar
   CSCI 364 Compiler Construction
   File: utility.h
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>
#include <string.h>

typedef struct idnode{
    char *name;
    struct idnode *next;
} *idnodeptr;

idnodeptr addName(char *input, idnodeptr list);

void print_list(idnodeptr node){
    idnodeptr check = node;
    while(check != NULL){
        if(check->name != NULL){
            printf("%s ", check->name);
        }
        check = check->next;
    }
}

char* mallocCopy(char *str1){
    char *str2 = malloc(sizeof(str1) +1);
    strcpy(str2, str1);
    return str2;
}

idnodeptr addName(char *input, idnodeptr list){
    idnodeptr temp = (idnodeptr)malloc(sizeof(struct idnode));
    temp->next = list;
    list = temp;
    temp->name = mallocCopy(input);
    return list;
}
