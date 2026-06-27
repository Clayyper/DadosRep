
DEF TEMP-TABLE tt-itens
    FIELD au-num-nfe              LIKE es-entr-forn.au-num-nfe
    FIELD au-serie                LIKE es-entr-forn.au-serie
    FIELD au-data-nfe             LIKE es-entr-forn.au-data-nfe
    FIELD c-cnpj-transmissor      LIKE es-entr-forn.c-cnpj-transmissor 
    FIELD cod-emitente            LIKE emitente.cod-emitente
    FIELD nome-abrev              LIKE emitente.nome-abrev
    FIELD ad-cod-item             LIKE es-entr-forn.ad-cod-item
    FIELD ad-num-ped              LIKE es-entr-forn.ad-num-ped.

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
/*     MESSAGE tt-itens.au-num-nfe         */
/*             tt-itens.au-serie           */
/*             tt-itens.c-cnpj-transmissor */
/*             tt-itens.ad-cod-item        */
/*         VIEW-AS ALERT-BOX.              */




    FIND es-entr-forn WHERE int(es-entr-forn.au-num-nfe)            EQ  int(tt-itens.au-num-nfe)
                        AND es-entr-forn.au-serie                   EQ  string(tt-itens.au-serie)
                        AND es-entr-forn.c-cnpj-transmissor         EQ  REPLACE(tt-itens.c-cnpj-transmissor,"'","")
                        AND es-entr-forn.ad-cod-item                EQ  tt-itens.ad-cod-item NO-ERROR.

    IF AVAIL es-entr-forn THEN DO:
        ASSIGN es-entr-forn.ad-num-ped = tt-itens.ad-num-ped.
/*         MESSAGE "achou" VIEW-AS ALERT-BOX. */

    END.
   
                               
END.




