OUTPUT TO VALUE('C:\TEMP\ItenNAlterados.TXT').
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

FOR EACH tt-doc-fisc.
    FIND it-doc-fisc WHERE
        it-doc-fisc.cod-estabel = tt-doc-fisc.cod-estabel
        and it-doc-fisc.serie = tt-doc-fisc.serie
        and it-doc-fisc.nr-doc-fis = tt-doc-fisc.nr-doc-fis
        and it-doc-fisc.cod-emitente = tt-doc-fisc.cod-emitente
        and it-doc-fisc.nat-operacao = tt-doc-fisc.nat-operacao
        and it-doc-fisc.nr-seq-doc = tt-doc-fisc.nr-seq-doc
        and it-doc-fisc.it-codigo = tt-doc-fisc.it-codigo NO-ERROR.
    IF NOT AVAIL it-doc-fisc THEN NEXT.
    
    /*PUT unformatted tt-doc-fisc.cod-estabel ";" tt-doc-fisc.serie ";" tt-doc-fisc.nr-doc-fis ";" tt-doc-fisc.cod-emitente ";" 
        tt-doc-fisc.nat-operacao ";" tt-doc-fisc.nr-seq-doc ";" tt-doc-fisc.it-codigo skip. */
        
    assign it-doc-fisc.val-pis=tt-doc-fisc.val-pis.    
    assign it-doc-fisc.val-cofins=tt-doc-fisc.val-cofins.    
    ASSIGN substring(it-doc-fisc.char-2,22,4) = '1,65'.
    ASSIGN substring(it-doc-fisc.char-2,30,4) = '7,60'.        


END.
OUTPUT CLOSE.
