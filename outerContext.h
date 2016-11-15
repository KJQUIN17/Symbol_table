#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <ctype.h>

void Outer_Context(){

    push("Outer Context");

    insert("integer", &(Stack.stk[top-1].root));
    bin_tree *newContext = searchTree("integer", Stack.stk[top-1].root);
    newContext->data.kind = mallocCopy("type");
    newContext->data.size = 1;

    insert("boolean", &(Stack.stk[top-1].root));
    newContext = searchTree("boolean", Stack.stk[top-1].root);
    newContext->data.kind = mallocCopy("type");
    newContext->data.size = 1;

    insert("true", &(Stack.stk[top-1].root));
    newContext = searchTree("true", Stack.stk[top-1].root);
    newContext->data.kind = mallocCopy("value");
    newContext->data.size = 1;

    insert("false", &(Stack.stk[top-1].root));
    newContext = searchTree("false", Stack.stk[top-1].root);
    newContext->data.kind = mallocCopy("value");
    newContext->data.size = 1;

    insert("maxint", &(Stack.stk[top-1].root));
    newContext = searchTree("maxint", Stack.stk[top-1].root);
    newContext->data.kind = mallocCopy("value");
    newContext->data.size = 1;

}
