DEF TEMP-TABLE  tt-doc-fisc
    FIELD cod-estabel  LIKE it-doc-fisc.cod-estabel
    FIELD serie        LIKE it-doc-fisc.serie
    FIELD nr-doc-fis   LIKE it-doc-fisc.nr-doc-fis
    FIELD cod-emitente Like it-doc-fisc.cod-emitente
    FIELD nat-operacao LIKE it-doc-fisc.nat-operacao
    FIELD nr-seq-doc   LIKE it-doc-fisc.nr-seq-doc
    FIELD it-codigo    LIKE it-doc-fisc.it-codigo
    FIELD val-pis      LIKE it-doc-fisc.val-pis 
    FIELD aliq-pis     LIKE it-doc-fisc.aliq-pis
    FIELD val-cofins   LIKE it-doc-fisc.val-cofins
    FIELD aliq-cofins  LIKE it-doc-fisc.aliq-cofins.
    

    
DEF VAR c-arquivo AS CHAR FORMAT "x(50)".
UPDATE c-arquivo.

MESSAGE "SEARCH(c-arquivo): " SEARCH(c-arquivo) VIEW-AS ALERT-BOX.

 INPUT FROM VALUE(SEARCH(c-arquivo)).
REPEAT :
     CREATE tt-doc-fisc.
     IMPORT DELIMITER ";" tt-doc-fisc.
END.
INPUT CLOSE.

MESSAGE "CAN-FIND(FIRST tt-doc-fisc): " CAN-FIND(FIRST tt-doc-fisc) VIEW-AS ALERT-BOX.

FOR EACH tt-doc-fisc exclusive-lock.
     
MESSAGE tt-doc-fisc.nr-doc-fis  VIEW-AS ALERT-BOX.

END.
