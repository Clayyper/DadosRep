/*******************************************************************************
 * Programa : ES0097A.P
 * Descricao: IMPRESSÇO DE ETIQUETAS VDA4902 Version 4 para a FORD
 * Autor    : MµRCIO
 * Data     : Mar‡o/2013
 * Versao   : 2.01.000 - Versao Inicial 
 ******************************************************************************/
/*-------------- Parametros  -----------------------------------------------*/

DEFINE INPUT PARAMETER c-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO .
DEFINE INPUT PARAMETER c-serie       LIKE nota-fiscal.serie       NO-UNDO .
DEFINE INPUT PARAMETER c-nr-nota-ini LIKE nota-fiscal.nr-nota-fis NO-UNDO .
DEFINE INPUT PARAMETER c-nr-nota-fim LIKE nota-fiscal.nr-nota-fis NO-UNDO .

/*
DEFINE VAR c-cod-estabel LIKE nota-fiscal.cod-estabel NO-UNDO INIT "403" .
DEFINE VAR c-serie       LIKE nota-fiscal.serie       NO-UNDO INIT "143" .
DEFINE VAR c-nr-nota-ini LIKE nota-fiscal.nr-nota-fis NO-UNDO INIT "0100031" .
DEFINE VAR c-nr-nota-fim LIKE nota-fiscal.nr-nota-fis NO-UNDO INIT "0100031" .
*/

DEFINE VARIABLE chexcelapplication AS COM-HANDLE NO-UNDO .
DEFINE VARIABLE chworkbook         AS COM-HANDLE NO-UNDO .
DEFINE VARIABLE chworksheet        AS COM-HANDLE NO-UNDO .
DEFINE VARIABLE c-linha            AS CHAR NO-UNDO .
DEFINE VARIABLE c-nome-plan        AS CHARACTER FORMAT "x(256)"  NO-UNDO .
DEFINE VARIABLE de-peso-bruto      AS DEC  NO-UNDO .
DEFINE VARIABLE de-peso-liquido    AS DEC  NO-UNDO .
DEFINE VARIABLE i-nr-embalagens    AS DEC  NO-UNDO .
DEFINE VARIABLE c-it-codigo        AS CHAR NO-UNDO .
DEFINE VARIABLE c-unload-point     AS CHAR NO-UNDO .

/*
DEFINE BUFFER bitem-embal FOR item-embal .
*/

FOR EACH nota-fiscal NO-LOCK 
                     WHERE nota-fiscal.cod-estabel EQ c-cod-estabel
                     AND   nota-fiscal.serie       EQ c-serie
                     AND   nota-fiscal.nr-nota-fis GE c-nr-nota-ini
                     AND   nota-fiscal.nr-nota-fis LE c-nr-nota-fim
                     :

    FOR EACH nota-embal OF nota-fiscal NO-LOCK :


        ASSIGN i-nr-embalagens = 0 .
        FOR EACH item-embal OF nota-embal  NO-LOCK :
            ASSIGN i-nr-embalagens = i-nr-embalagens + 1 .
        END.

        FOR EACH item-embal OF nota-embal NO-LOCK 
                                          BREAK BY item-embal.it-codigo 
                                                BY item-embal.sigla-emb :

            /*
            IF FIRST-OF(item-embal.it-codigo) THEN DO:
                ASSIGN i-nr-embalagens = 0 .
                FOR EACH bitem-embal OF nota-embal 
                                        WHERE bitem-embal.it-codigo EQ item-embal.it-codigo NO-LOCK :
                    ASSIGN i-nr-embalagens = i-nr-embalagens + 1 .
                END.
            END.
            */

            CREATE  "excel.application" chexcelapplication.
            ASSIGN c-linha = PROPATH .
            IF c-linha MATCHES ("*des206b*")  THEN chworkbook  = chexcelapplication:workbooks:OPEN("T:\esp206b\doc\VDA4902V04.xlsx") .
            ELSE chworkbook  = chexcelapplication:workbooks:OPEN("T:\esp206b\doc\VDA4902V04.xlsx") .
            chworksheet = chexcelapplication:Sheets("VDA_Ford") .                      

            ASSIGN c-nome-plan = SESSION:TEMP-DIRECTORY + "Etiq_VDA.xlsx"  .

            FIND it-nota-fisc OF item-embal NO-LOCK NO-ERROR .
            FIND ped-venda OF it-nota-fisc NO-LOCK NO-ERROR .
            ASSIGN c-unload-point = "" .
            IF AVAIL ped-venda THEN DO:
                FIND es-ped-venda OF ped-venda NO-LOCK NO-ERROR .
                IF AVAIL es-ped-venda  THEN DO:
                    ASSIGN 
                        c-unload-point = STRING ( INT(es-ped-venda.cod-planta), "99" ) + " - " + STRING( INT ( es-ped-venda.cod-doca), "99" )  .
                END.
            END.


            FIND embalag OF item-embal NO-LOCK NO-ERROR .
            FIND ITEM WHERE ITEM.it-codigo EQ item-embal.it-codigo NO-LOCK NO-ERROR .

            ASSIGN c-it-codigo = ITEM.it-codigo .
            FIND item-cli WHERE item-cli.it-codigo  EQ item-embal.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .
            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .

            IF ITEM.desc-nacional NE "" THEN ASSIGN c-it-codigo = ITEM.desc-nacional  .

            ASSIGN de-peso-liquido = ITEM.peso-bruto * item-embal.dec-1 .
            ASSIGN de-peso-bruto   = ( ITEM.peso-bruto * item-embal.dec-1 ) + embalag.peso-embal .


            chworksheet:range("O4"):VALUE  = TRIM( c-unload-point ).

            chworksheet:range("D9"):VALUE  = TRIM( nota-fiscal.serie + nota-fiscal.nr-nota-fis ).
            chworksheet:range("C11"):VALUE = "*" + TRIM( nota-fiscal.serie + nota-fiscal.nr-nota-fis ) + "*" .

            chworksheet:range("O13"):VALUE = de-peso-liquido .
            chworksheet:range("S13"):VALUE = de-peso-bruto   .
            chworksheet:range("W13"):VALUE = i-nr-embalagens .

            chworksheet:range("C16"):VALUE  = TRIM( c-it-codigo ).
            chworksheet:range("M16"):VALUE = "*" + REPLACE( TRIM( c-it-codigo ) , " " , "" )  + "*" .

            chworksheet:range("C21"):VALUE  = item-embal.dec-1 .
            chworksheet:range("H21"):VALUE = "*" + TRIM( STRING(item-embal.dec-1 ) ) + "*" .

            chworksheet:range("O21"):VALUE  = TRIM(ITEM.desc-inter ) .

            chworksheet:range("O25"):VALUE  = TRIM(embalag.descricao ) .

            chworksheet:range("C26"):VALUE  = "LQR0"   .
            chworksheet:range("H26"):VALUE  = "*LQR0*" .

            chworksheet:range("O29"):VALUE  = STRING(nota-fiscal.dt-emis, "99/99/9999" ) .

            chworksheet:range("U29"):VALUE  = TRIM(ITEM.inform-compl) .

            chworksheet:range("C31"):VALUE  = item-embal.int-1 .
            chworksheet:range("H31"):VALUE  = "*" + TRIM( STRING ( item-embal.int-1 ) ) + "*" . 

            chworksheet:range("O33"):VALUE  = "*" + TRIM( STRING ( item-embal.serie + item-embal.nr-nota-fis + STRING(item-embal.nr-seq-fat, "999") +  STRING(item-embal.int-1, "999") ) )  + "*" . 


            chworksheet:PrintOut(YES).          
            OS-DELETE VALUE ( c-nome-plan ) NO-ERROR .  
            chworksheet:SaveAs(c-nome-plan).
            chworkbook:CLOSE(YES).
            RELEASE OBJECT chexcelapplication   .
            RELEASE OBJECT chworkbook           .
            RELEASE OBJECT chworksheet          .


        END.

    END.




END.
