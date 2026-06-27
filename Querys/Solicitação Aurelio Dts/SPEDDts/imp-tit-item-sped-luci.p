DEF TEMP-TABLE tt-itens
    FIELD cod-estabel    LIKE estabelec.cod-estabel
    FIELD tt-it-codigo   LIKE ITEM.it-codigo
    FIELD tt-tipo        AS INT.

DEF VAR c-arquivo AS CHAR FORMAT "x(50)".
UPDATE c-arquivo.

MESSAGE "SEARCH(c-arquivo): " SEARCH(c-arquivo) VIEW-AS ALERT-BOX.

 INPUT FROM VALUE(SEARCH(c-arquivo)).
REPEAT :
     CREATE tt-itens.
     IMPORT DELIMITER ";" tt-itens.
END.
INPUT CLOSE.

MESSAGE "CAN-FIND(FIRST tt-itens): " CAN-FIND(FIRST tt-itens) VIEW-AS ALERT-BOX.

FOR EACH tt-itens.
    FIND ITEM  WHERE
         ITEM.it-codigo = tt-itens.tt-it-codigo NO-ERROR.
    IF NOT AVAIL ITEM THEN NEXT.
    FIND ITEM-uni-estab WHERE
         item-uni-estab.cod-estabel = tt-itens.cod-estabel AND
         item-uni-estab.it-codigo   = ITEM.it-codigo NO-ERROR.
    IF AVAIL item-uni-estab THEN
       ASSIGN substring(item-uni-estab.char-1,133,1) = string(tt-itens.tt-tipo).
    ASSIGN substring(ITEM.char-2,212,1) = string(tt-itens.tt-tipo).
END.


