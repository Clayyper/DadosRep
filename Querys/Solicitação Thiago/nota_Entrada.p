/*--------------- Doc ------------------
Nome do especifico: ad0001
Nome: Relat½rio Normal Venda
Fun?’o:Emitir relat½rio de normal de venda, contendo informacao de nota,data emissao,cliente e item com seu respectivo NCM.
Setores:Comercial,Controladorio, Fiscal
Data da Cria?’o: 04/02/2014
Vers’o:1.0
Data da Modifica?’o:00/00/0000
™tens Modificados:

Autor: Clayson Oliveira

*/

DEF VAR h-acomp AS HANDLE NO-UNDO.
def var i-conta as int no-undo.

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.

RUN pi-inicializar IN h-acomp (INPUT "Processando").

/*--------------- Definicao para usar o Excel ------------------*/
DEFINE VAR chexcelapplication AS COM-HANDLE .
DEFINE VAR chworkbook         AS COM-HANDLE .
DEFINE VAR chworksheet        AS COM-HANDLE .
DEF VAR c-nome-plan     AS   CHARACTER NO-UNDO .
DEF VAR wi              AS   INTEGER INIT 0 NO-UNDO .


/*--------------- Definicao para tela ------------------*/

DEFINE VARIABLE wh AS WIDGET-HANDLE.
CREATE WIDGET-POOL "janela" PERSISTENT.
IF wh = ? OR NOT VALID-HANDLE(wh) THEN
CREATE WINDOW wh IN WIDGET-POOL "janela"
assign SENSITIVE = TRUE
       VISIBLE   = TRUE
       WIDTH-CHARS = 80
       height-chars = 15.
assign THIS-PROCEDURE:CURRENT-WINDOW = wh.


DEF VAR v_estab_ini     AS CHAR FORMAT "999"                        LABEL 'Estab ini'              NO-UNDO.
DEF VAR v_estab_fim     AS CHAR FORMAT "999"        INIT 999        LABEL 'Estab fim'              NO-UNDO.
DEF VAR v_nota_ini      AS CHAR FORMAT "9999999"                    LABEL 'Nota Incio'             NO-UNDO.
DEF VAR v_nota_fim      AS CHAR FORMAT "9999999"    INIT 9999999    LABEL 'Nota fim'               NO-UNDO.
DEF VAR v_cli_ini       AS INT                                      LABEL 'Cliente Inicio'         NO-UNDO.
DEF VAR v_cli_fim       AS INT                      INIT 999        LABEL 'Cliente Fim'            NO-UNDO.
DEF VAR v_dat_ini       AS DATE FORMAT "99/99/9999" INIT TODAY      LABEL 'Data da Inicio'         NO-UNDO.
DEF VAR v_dat_fim       AS DATE FORMAT "99/99/9999" INIT TODAY      LABEL 'Data da Fim'            NO-UNDO.


      
/* UPDATE v_estab_ini            */
/*        v_estab_fim            */
/*        v_nota_ini             */
/*        v_nota_fim             */
/*        v_cli_ini              */
/*        v_cli_fim              */
/*        v_dat_ini              */
/*        v_dat_fim  WITH 1 COL. */
       
       
       
       
def var v-nomepessoa    like emscad.cliente.nom_pessoa   column-label "Razao-Social".
def var v-descitem      like mgcad.item.desc-item        column-label "Desc_item".

DEF TEMP-TABLE tt-exec NO-UNDO
    FIELD nr-nota-fis   LIKE docum-est.nro-docto
    FIELD serie         LIKE docum-est.serie-docto
    FIELD dt-emis-nota  LIKE docum-est.dt-emissao
    FIELD cod-emitente  LIKE docum-est.cod-emitente
    FIELD nom_pessoa    LIKE emscad.cliente.nom_pessoa
    FIELD it-codigo     LIKE item-doc-est.it-codigo
    FIELD desc-item     LIKE item.desc-item
    FIELD class-fiscal  LIKE item.class-fiscal
    FIELD vl-preuni     LIKE item-doc-est.preco-unit[1]
    FIELD qt-faturada   AS DEC FORMAT ">>>>,>>9.9999" 
    FIELD vl-tot-item   LIKE item-doc-est.preco-total[1].

CREATE  "excel.application" chexcelapplication.
chworkbook  = chexcelapplication:workbooks:add("\\192.168.0.248\totvs\especificos\adler\doc\Relatorio_normal_vendas.xlsx").
chworksheet = chexcelapplication:Sheets("Vendas") . 
ASSIGN c-nome-plan = "c:\temp\Relatorio_normal_vendas.xlsx" .

ASSIGN wi = 3 .

for each docum-est use-index documento
            where nro-docto >= ""
              and nro-docto <= "ZZZZZZZZZZZZZZ"
              and cod-emitente >= 0
              and cod-emitente <= 999999999
              and dt-emissao >= 01/01/2014
              and dt-emissao <= 02/18/2014
             /*  and ( */
/*                     (nat-operacao >= ('510101') and nat-operacao <= ('510106')) */
/*                     or */
/*                     (nat-operacao >= ('510201') and nat-operacao <= ('510206')) */
/*                     or */
/*                     (nat-operacao >= ('610101') and nat-operacao <= ('610103')) */
/*                     or */
/*                     (nat-operacao >= ('610201') and nat-operacao <= ('610203')) */
/*                     or */
/*                     nat-operacao=('710101') */
/*                    ) */
              and cod-estabel >= "101"
              and cod-estabel <= "101"              
              /* and nota-fiscal.idi-sit-nf-eletro = 3 */ NO-LOCK
    ,each natur-oper of docum-est no-lock
     where natur-oper.tipo = 1 /* 1= entrada, 2= saida, 3 = servico */ :

    ASSIGN i-conta = i-conta + 1.

    RUN pi-acompanhar IN h-acomp ( INPUT STRING(i-conta) ).
                   
                   
    for each emscad.fornecedor 
            where emscad.fornecedor.cdn_fornecedor = docum-est.cod-emitente no-lock:
     assign v-nomepessoa=fornecedor.nom_pessoa.
    end.
 
    
    for each item-doc-est of docum-est no-lock
       ,EACH mgcad.item of item-doc-est no-lock:

        CREATE tt-exec NO-ERROR.
        ASSIGN tt-exec.nr-nota-fis   = docum-est.nro-docto
               tt-exec.serie         = docum-est.serie-docto
               tt-exec.dt-emis-nota  = docum-est.dt-emissao   
               tt-exec.cod-emitente  = docum-est.cod-emitente
               tt-exec.nom_pessoa    = v-nomepessoa
               tt-exec.it-codigo     = item-doc-est.it-codigo
               tt-exec.desc-item     = item.desc-item
               tt-exec.class-fiscal  = item.class-fiscal
               tt-exec.vl-preuni     = item-doc-est.preco-unit[1]
               tt-exec.qt-faturada   = item-doc-est.quantidade
               tt-exec.vl-tot-item   = item-doc-est.preco-total[1].




                 
                /* chworksheet:range("A" + STRING(wi) ):VALUE  = docum-est.nro-docto .       */
                /* chworksheet:range("B" + STRING(wi) ):VALUE  = docum-est.serie-docto .             */
                /* chworksheet:range("C" + STRING(wi) ):VALUE  = docum-est.dt-emissao      . */
                /* chworksheet:range("D" + STRING(wi) ):VALUE  = docum-est.cod-emitente .      */
                /* chworksheet:range("E" + STRING(wi) ):VALUE  = v-nomepessoa       .            */
                /* chworksheet:range("F" + STRING(wi) ):VALUE  = item-doc-est.it-codigo  .       */
                /* chworksheet:range("G" + STRING(wi) ):VALUE  = item.desc-item.                 */
                /* chworksheet:range("H" + STRING(wi) ):VALUE  = item.class-fiscal.              */
                /* chworksheet:range("I" + STRING(wi) ):VALUE  = item-doc-est.preco-unit[1].         */
                /* chworksheet:range("J" + STRING(wi) ):VALUE  = item-doc-est.quantidade.    */
                /* chworksheet:range("K" + STRING(wi) ):VALUE  = item-doc-est.preco-total[1]  .     */
                /*                                                                               */
                /* ASSIGN wi = wi + 1 .                                                          */
       
    end.   
 
         
 end.
/*    */
/* FOR EACH tt-exec NO-LOCK: */
/*    */
/*     ASSIGN chworksheet:range("A" + STRING(wi) ):VALUE  = tt-exec.nr-nota-fis */
/*            chworksheet:range("B" + STRING(wi) ):VALUE  = tt-exec.serie */
/*            chworksheet:range("C" + STRING(wi) ):VALUE  = tt-exec.dt-emis-nota */
/*            chworksheet:range("D" + STRING(wi) ):VALUE  = tt-exec.cod-emitente */
/*            chworksheet:range("E" + STRING(wi) ):VALUE  = tt-exec.nom_pessoa */
/*            chworksheet:range("F" + STRING(wi) ):VALUE  = tt-exec.it-codigo */
/*            chworksheet:range("G" + STRING(wi) ):VALUE  = tt-exec.desc-item */
/*            chworksheet:range("H" + STRING(wi) ):VALUE  = tt-exec.class-fiscal */
/*            chworksheet:range("I" + STRING(wi) ):VALUE  = tt-exec.vl-preuni */
/*            chworksheet:range("J" + STRING(wi) ):VALUE  = tt-exec.qt-faturada */
/*            chworksheet:range("K" + STRING(wi) ):VALUE  = tt-exec.vl-tot-item. */
/*    */
/*     ASSIGN wi = wi + 1 . */
/*    */
/* END. */

output to c:/temp/nota_entrada.csv.
    
    put "Nota;Serie;Data Emissao;Cod Cliente;Nome Cliente;Item;Desc Item;NCM;Valor Unidade;Quantidade;Valor Total" skip.

    FOR EACH tt-exec NO-LOCK:
    
        PUT tt-exec.nr-nota-fis ";"
        tt-exec.serie           ";"
        tt-exec.dt-emis-nota    ";"
        tt-exec.cod-emitente    ";"
        tt-exec.nom_pessoa      ";"
        tt-exec.it-codigo       ";"
        tt-exec.desc-item       ";"
        tt-exec.class-fiscal    ";"
        tt-exec.vl-preuni       ";"
        tt-exec.qt-faturada     ";"
        tt-exec.vl-tot-item SKIP.    
    
    END.
    
 output close.
 
 RUN pi-finalizar IN h-acomp.

 /*
chworksheet:PrintOut(YES).   
*/

DOS SILENT DEL VALUE(c-nome-plan). 

chworksheet:SaveAs (c-nome-plan).

chworkbook:CLOSE(YES).

RELEASE OBJECT chexcelapplication   .
RELEASE OBJECT chworkbook           .
RELEASE OBJECT chworksheet          .


 
message "Relat½rio gerado no c:\temp\Relatorio_normal_vendas.xlsx " view-as alert-box.

DELETE WIDGET-POOL "janela".

