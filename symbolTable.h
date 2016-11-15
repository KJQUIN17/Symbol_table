/***
    Kyle Quinn
    CSCI 364 - Compiler Construction
    symbolTable.h

***/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

bin_tree* search_for_parent(char *type){
    bin_tree* found = NULL;
    int i;
    for(i = top-1; i >= 0; i--){
        bin_tree *temp = Stack.stk[i].root;
        found = searchTree(type, temp);
        if(found != NULL){
            return found;            
        }
   
    }
    printf("Sorry, got null!\n");
    return NULL;
}

void parse_var_id_list(idnodeptr list, char *typeName){
    idnodeptr temp = NULL;
    bin_tree *findInserted;
    bin_tree *typeSearch;
    while(list != NULL){
        int check = addSymbol(list->name);
        if(check != -1){
            findInserted = searchTree(list->name, Stack.stk[top-1].root);
            typeSearch = search_for_parent(typeName);
            findInserted->data.kind = mallocCopy(typeSearch->data.kind);
            int comp = strcmp(findInserted->data.kind, "array");
            if(typeSearch != NULL){
                findInserted->data.parent_type = typeSearch;
                findInserted->data.size = typeSearch->data.size;
            }else{
                printf("Sorry, its NULL\n");
            }
        }
        temp = list;
        list = list->next;
        findInserted = NULL;
        typeSearch = NULL;
    }
}

void parse_exception_list(idnodeptr list){
    idnodeptr temp = NULL;
    bin_tree *findInserted;
    bin_tree *typeSearch;
    while(list != NULL){
        int check = addSymbol(list->name);
        if(check != -1){
            findInserted = searchTree(list->name, Stack.stk[top-1].root);
            findInserted->data.kind = mallocCopy("exception");
            findInserted->data.size = 1;
            findInserted->data.isParam = 0;
        }
        temp = list;
        list = list->next;
        findInserted = NULL;
        typeSearch = NULL;
    }
}

/* bin_tree *parse_param_list(idnodeptr list, char *mode, char *typeName){ */
/*     bin_tree *previousNode = NULL; */
/*     bin_tree *returnNode = NULL; */
/*     bin_tree *findInserted; */
/*     bin_tree *typeSearch; */
/*     idnodeptr temp = NULL; */
/*     int comp; */
/*     int comp2; */

/*     while(list != NULL){ */
/*         int check = addSymbol(list->name); */
/*         if(check != -1){ */
/* /\*             findInserted = searchTree(list->name, Stack.stk[Stack.top].root); *\/ */
/*             findInserted = searchTree(list->name, Stack.stk[top-1].root); */

/*             findInserted->data.kind = mallocCopy("param"); */
/*             typeSearch = search_for_parent(typeName); */
/*             if(typeSearch == NULL){ */
/*                 printf("Error: Type does not exist!\n"); */
/*                 return; */
/*             } */
/*             findInserted->data.parent_type = typeSearch; */
/*             findInserted->data.isParam = 1; */
/*             findInserted->data.size = typeSearch->data.size; */
/*             findInserted->data.mode = mallocCopy(mode); */

/*             if(previousNode !=NULL){ */
/*                 previousNode->data.next_param = findInserted; */
/*             } */

/*             returnNode = findInserted; */
/*             previousNode = findInserted; */
/*         } */

/*         temp = list; */
/*         list = list->next; */
/*         findInserted = NULL; */
/*         typeSearch = NULL; */
/*         free(temp); */
/*     } */

/*     if(returnNode != NULL){ */
/*         return returnNode; */
/*     } */
/* } */


