DEF TEMP-TABLE tt-itens
    FIELD tt-it-codigo   LIKE ITEM.it-codigo
    FIELD tt-tipo        AS INT.
DEF VAR c-arquivo AS CHAR FORMAT "x(50)".
DEF VAR c-estabel LIKE estabelec.cod-estabe.
UPDATE c-arquivo SKIP
       c-estabel.
INPUT FROM VALUE(SEARCH(c-arquivo)).
REPEAT :
     CREATE tt-itens.
     IMPORT DELIMITER ";" tt-itens.
END.
INPUT CLOSE.
FOR EACH tt-itens.
    FIND ITEM  WHERE
         ITEM.it-codigo = tt-itens.tt-it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN NEXT.
    FIND ITEM-uni-estab WHERE
         item-uni-estab.cod-estabel = c-estabel AND
         item-uni-estab.it-codigo = ITEM.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab THEN
       ASSIGN substring(item-uni-estab.char-1,133,1) = string(tt-itens.tt-tipo).
    ASSIGN substring(ITEM.char-2,212,1) = string(tt-itens.tt-tipo).
END.


