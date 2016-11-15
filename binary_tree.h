/***
    Kyle Quinn
    CSCI 364 - Compiler Construction
    binary_tree.h

***/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>

typedef struct stack stack;
typedef struct bin_tree bin_tree;
typedef struct node node;
typedef struct symbol symbol;
typedef struct eNode eNode;

#define MAXSIZE 1000


struct symbol{

    char *kind;                // describe the kind of node
    char *name;                // the identifier name
    char *mode;                // if a formal parameter, in, out, in out
    int value;                 // if a number, the integer value
    int size;
    int lower;                 // last indice of an array
    int upper;                 // first indice of an array
    int isParam;
    bin_tree *parent_type;     // if a variable, parent type
    bin_tree *next_param;      // if a formal parameter, the next formal parameter
    bin_tree *component_type;  // if an array type, the type of the components
    eNode *eList;
    /* pointer *left;          // pointer to the nodes children */
    /* pointer *right;         // pointer to the nodes children */
};

struct bin_tree{ // Binary Tree
    symbol data;
    bin_tree *right;
    bin_tree *left;
};

struct node{
    char *name; //name attribute
    bin_tree *root; // root attribute
};

struct eNode{
    char *str;
    int index;
    int pcVal;
    eNode *next;
};

struct stack{
    node stk[MAXSIZE]; // initialize stack and size
    /* int top;  // stack attribute top */
};


/* *** Symbol Table *** */

stack Stack;  // initialize stack s
int top = 0;

void print_inorder(bin_tree *tree){
    if (tree){
        print_inorder(tree->left);
        printf("%s - %s\n",tree->data.name, tree->data.kind);
        if(tree->data.parent_type != NULL){
            printf(": w/ parent type %s\n", tree->data.parent_type->data.name);
        }
        print_inorder(tree->right);
    }
} // end print_inorder

void push(char *nameA){
    /* if (Stack.top == (MAXSIZE)){ */
    if(top == (MAXSIZE)){
    
        printf ("Error: Stack is Full!\n");
    }else{
        printf("\n*** Pushing new scope for %s ***\n", nameA);
        /* printf("stack.top = %d\n", top); */
        /* Stack.stk[Stack.top].root = NULL; */
        /* Stack.stk[Stack.top].name = mallocCopy(nameA); */
        Stack.stk[top].root = NULL;
        Stack.stk[top].name = mallocCopy(nameA);
        /* Stack.top = Stack.top + 1; */
        top++;

    }
} // end push

void pop (){
    /* if (Stack.top == 0){ */
    if (top <= -1){
        printf ("Error: Stack is Empty!\n");
    }else{
        /* printf("\n*** Popping Scope for %s ***\n", Stack.stk[Stack.top-1].name); */

        printf("\n*** Popping Scope for %s ***\n", Stack.stk[top-1].name);
        print_inorder(Stack.stk[top-1].root); // do I need this?
        /* Stack.top = Stack.top - 1; */
        top--;
    }
} // end pop

void insert(char *name, bin_tree **tree){

    if(*tree == NULL){
        *tree = (bin_tree*)malloc(sizeof(bin_tree));
        (*tree)->left = NULL;
        (*tree)->right = NULL;
        (*tree)->data.name = mallocCopy(name);
    }else{
        int comp = strncmp(name, (*tree)->data.name, 1000);
        if(comp < 0){
            insert(name, &((*tree)->left));
        }else{
            insert(name, &((*tree)->right));
        }
    }
} // end insert

void deltree(bin_tree *tree){

    if (tree){
        deltree(tree->left);
        deltree(tree->right);
        free(tree);
    }
} // end deltree

bin_tree* searchTree(char *name, bin_tree *tree){
    if(tree != NULL){
        int comp = strcmp(name, tree->data.name);
        if(comp < 0){
            return searchTree(name, tree->left);
        } else if(comp > 0){
            return searchTree(name, tree->right);
        }else{
            /* printf("tree is returned: \n"); */
            /* print_inorder(tree); */
            return tree;
        }
    }
    return NULL;
} //end searchTree

int addSymbol(char *symbol){
    /* if (Stack.top == -1){ */
        if (top <= 0){
        printf ("Error: Stack is Empty!\n");
        return -1;
    }

    /* bin_tree *found = searchTree(symbol, Stack.stk[Stack.top].root); */
        bin_tree *found = searchTree(symbol, Stack.stk[top-1].root);    
            /* printf("stack.top-1 in add symbol = %d\n", top-1); */


    if(found != NULL){
        printf("Error: Symbol already exists in local tree!\n");
        return -1;

    }else{
        /* insert(symbol, &(Stack.stk[Stack.top].root)); */
        insert(symbol, &(Stack.stk[top-1].root));
        /* printf("Added symbol to local tree!\n"); */
        return 0;
    }
}

