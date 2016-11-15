echo "**********"
echo Kyle Quinn
echo "**********"

DEBUG=true
if ${DEBUG}; then
yacc -d -v ada.y
lex ada.l
fi

/usr/bin/gcc lex.yy.c y.tab.c -o ada -ll -ly

DEBUG_RUN=false
if ${DEBUG_RUN}; then

./ada < simpExpr.ada

./ada < simpProc.ada

./ada < ck3D.ada
fi

./ada < STsimple.ada
