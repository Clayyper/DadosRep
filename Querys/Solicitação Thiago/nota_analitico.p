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
       
       
       
       
def var v-nomepessoa    like emscad.cliente.nom_pessoa      column-label "Razao-Social".
def var v-descitem      like mgcad.item.desc-item           column-label "Desc_item".
def var v-notadev       Like mgmov.devol-cli.nro-docto      column-label "Docum_Entrada".
def var v-qtdev         Like mgmov.devol-cli.qt-devolvida   column-label "Qtde_Devol".
def var v-valdev        Like mgmov.devol-cli.vl-devol       column-label "Valor_Devol".
def var v-datadev       Like mgmov.devol-cli.dt-devol       column-label "Data_Devol".
def var v-natoper       Like mgmov.devol-cli.nat-operacao   column-label "Nat_OperDevol".




DEF TEMP-TABLE tt-exec NO-UNDO
    FIELD nr-nota-fis   LIKE nota-fiscal.nr-nota-fis
    FIELD serie         LIKE nota-fiscal.serie
    FIELD dt-emis-nota  LIKE nota-fiscal.dt-emis-nota
    FIELD cod-emitente  LIKE nota-fiscal.cod-emitente
    FIELD nom_pessoa    LIKE emscad.cliente.nom_pessoa
    FIELD it-codigo     LIKE it-nota-fisc.it-codigo
    FIELD desc-item     LIKE item.desc-item
    FIELD class-fiscal  LIKE item.class-fiscal
    FIELD vl-preuni     LIKE it-nota-fisc.vl-preuni
    FIELD qt-faturada   AS DEC FORMAT ">>>>,>>9.9999" 
    FIELD vl-tot-item   LIKE it-nota-fisc.vl-tot-item
    FIELD nat-operacao  LIKE nota-fiscal.nat-operacao
    FIELD nro-docto     LIKE devol-cli.nro-docto
    FIELD qt-devolvida  LIKE devol-cli.qt-devolvida
    FIELD vl-devol      LIKE devol-cli.vl-devol
    FIELD dt-devol      LIKE devol-cli.dt-devol
    FIELD dev-natoper   LIKE devol-cli.nat-operacao.
    

CREATE  "excel.application" chexcelapplication.
chworkbook  = chexcelapplication:workbooks:add("\\192.168.0.248\totvs\especificos\adler\doc\Relatorio_normal_vendas.xlsx").
chworksheet = chexcelapplication:Sheets("Vendas") . 
ASSIGN c-nome-plan = "c:\temp\Relatorio_normal_vendas.xlsx" .

ASSIGN wi = 3 .

for each nota-fiscal use-index nfftrm-20
            where dt-emis-nota >= 01/01/2014
              and dt-emis-nota <= 03/06/2014
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
              and nr-nota-fis >= ""
              and nr-nota-fis <= "ZZZZZZZZZZZZZZ"
              and cod-emitente >= 0
              and cod-emitente <= 999999999
              and nota-fiscal.idi-sit-nf-eletro = 3 NO-LOCK
    ,each natur-oper of nota-fiscal no-lock
     where natur-oper.tipo = 2 /* 1= entrada, 2= saida, 3 = servico */ :

    ASSIGN i-conta = i-conta + 1.

    RUN pi-acompanhar IN h-acomp ( INPUT STRING(i-conta) ).
                   
                   
    for each emscad.cliente 
            where emscad.cliente.cdn_cliente=nota-fiscal.cod-emitente no-lock:
     assign v-nomepessoa=cliente.nom_pessoa.
    end.
    
        
    for each it-nota-fisc of nota-fiscal no-lock
       ,EACH mgcad.item of it-nota-fisc no-lock:
       
       assign v-notadev  = ''
                   v-qtdev    =  0
                   v-valdev   =  0
                   v-natoper  =  ''
                   v-datadev  =  today.
       
        for each mgmov.devol-cli no-lock
        where devol-cli.it-codigo=it-nota-fisc.it-codigo
            and devol-cli.nr-nota-fis = nota-fiscal.nr-nota-fis:
            assign v-notadev  =  devol-cli.nro-docto
                   v-qtdev    =  devol-cli.qt-devolvida
                   v-valdev   =  devol-cli.vl-devol
                   v-natoper  =  devol-cli.nat-operacao
                   v-datadev  =  devol-cli.dt-devol.                
                   
        end.

        CREATE tt-exec NO-ERROR.
        ASSIGN tt-exec.nr-nota-fis   = nota-fiscal.nr-nota-fis
               tt-exec.serie         = nota-fiscal.serie
               tt-exec.dt-emis-nota  = nota-fiscal.dt-emis-nota   
               tt-exec.cod-emitente  = nota-fiscal.cod-emitente
               tt-exec.nom_pessoa    = v-nomepessoa
               tt-exec.it-codigo     = it-nota-fisc.it-codigo
               tt-exec.desc-item     = item.desc-item
               tt-exec.class-fiscal  = item.class-fiscal
               tt-exec.vl-preuni     = it-nota-fisc.vl-preuni
               tt-exec.qt-faturada   = it-nota-fisc.qt-faturada[1]
               tt-exec.vl-tot-item   = it-nota-fisc.vl-tot-item
               tt-exec.nat-operacao  = nota-fiscal.nat-operacao
               tt-exec.nro-docto     = v-notadev
               tt-exec.qt-devolvida  = v-qtdev
               tt-exec.vl-devol      = v-valdev
               tt-exec.dt-devol      = v-datadev
               tt-exec.dev-natoper   = v-natoper.
.




                 
                /* chworksheet:range("A" + STRING(wi) ):VALUE  = nota-fiscal.nr-nota-fis .       */
                /* chworksheet:range("B" + STRING(wi) ):VALUE  = nota-fiscal.serie .             */
                /* chworksheet:range("C" + STRING(wi) ):VALUE  = nota-fiscal.dt-emis-nota      . */
                /* chworksheet:range("D" + STRING(wi) ):VALUE  = nota-fiscal.cod-emitente .      */
                /* chworksheet:range("E" + STRING(wi) ):VALUE  = v-nomepessoa       .            */
                /* chworksheet:range("F" + STRING(wi) ):VALUE  = it-nota-fisc.it-codigo  .       */
                /* chworksheet:range("G" + STRING(wi) ):VALUE  = item.desc-item.                 */
                /* chworksheet:range("H" + STRING(wi) ):VALUE  = item.class-fiscal.              */
                /* chworksheet:range("I" + STRING(wi) ):VALUE  = it-nota-fisc.vl-preuni.         */
                /* chworksheet:range("J" + STRING(wi) ):VALUE  = it-nota-fisc.qt-faturada[1].    */
                /* chworksheet:range("K" + STRING(wi) ):VALUE  = it-nota-fisc.vl-tot-item  .     */
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

output to c:/temp/nota_analitico.csv.
    
    put "Nota;Serie;NatOp;Data Emissao;Cod Cliente;Nome Cliente;Item;Desc Item;NCM;Valor Unidade;Quantidade;Valor Total;Docum Devol;Qtde Devol;Valor Devol;Data Devol;Dev NatOper" skip.

    FOR EACH tt-exec NO-LOCK:
    
        PUT tt-exec.nr-nota-fis ";"
        tt-exec.serie           ";"
        tt-exec.nat-operacao    ";"
        tt-exec.dt-emis-nota    ";"
        tt-exec.cod-emitente    ";"
        tt-exec.nom_pessoa      ";"
        tt-exec.it-codigo       ";"
        tt-exec.desc-item       ";"
        tt-exec.class-fiscal    ";"
        tt-exec.vl-preuni       ";"
        tt-exec.qt-faturada     ";"
        tt-exec.vl-tot-item     ";"
        tt-exec.nro-docto       ";"
        tt-exec.qt-devolvida    ";"
        tt-exec.vl-devol        ";"
        tt-exec.dt-devol        ";"
        tt-exec.dev-natoper     SKIP.    
    
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

