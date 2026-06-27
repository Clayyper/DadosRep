/*--------------- Doc ------------------
Nome do especifico: ad0001
Nome: Relat¢rio Normal Venda
Fun‡Æo:Emitir relat¢rio de normal de venda, contendo informacao de nota,data emissao,cliente e item com seu respectivo NCM.
Setores:Comercial,Controladorio, Fiscal
Data da Cria‡Æo: 04/02/2014
VersÆo:1.0
Data da Modifica‡Æo:00/00/0000
Ötens Modificados:

Autor: Clayson Oliveira

*/




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


      
UPDATE v_estab_ini
       v_estab_fim
       v_nota_ini
       v_nota_fim 
       v_cli_ini
       v_cli_fim
       v_dat_ini
       v_dat_fim  WITH 1 COL.
       
       
       
       
def var v-nomepessoa    like emscad.cliente.nom_pessoa   column-label "Razao-Social".
def var v-descitem      like mgcad.item.desc-item        column-label "Desc_item".



CREATE  "excel.application" chexcelapplication.
chworkbook  = chexcelapplication:workbooks:add("\\192.168.0.248\totvs\especificos\adler\doc\Relatorio_normal_vendas.xlsx").
chworksheet = chexcelapplication:Sheets("Vendas") . 
ASSIGN c-nome-plan = "c:\temp\Relatorio_normal_vendas.xlsx" .

ASSIGN wi = 3 .

for each nota-fiscal use-index nfftrm-20
            where dt-emis-nota >= v_dat_ini 
              and dt-emis-nota <= v_dat_fim
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
              and cod-estabel>= v_estab_ini
              and cod-estabel<= v_estab_fim
              and nr-nota-fis>= v_nota_ini
              and nr-nota-fis<= v_nota_fim
              and cod-emitente >= v_cli_ini
              and cod-emitente <= v_cli_fim
              and nota-fiscal.idi-sit-nf-eletro=3      no-lock:
                   
                   
    for each emscad.cliente 
            where emscad.cliente.cdn_cliente=nota-fiscal.cod-emitente:
     assign v-nomepessoa=cliente.nom_pessoa.
    end.
 
    
    for each it-nota-fisc
             where  it-nota-fisc.nr-nota-fis=nota-fiscal.nr-nota-fis:
             for each mgcad.item
                      where item.it-codigo=it-nota-fisc.it-codigo:
                 
                chworksheet:range("A" + STRING(wi) ):VALUE  = nota-fiscal.nr-nota-fis .
                chworksheet:range("B" + STRING(wi) ):VALUE  = nota-fiscal.serie .
                chworksheet:range("C" + STRING(wi) ):VALUE  = nota-fiscal.dt-atualiza       .
                chworksheet:range("D" + STRING(wi) ):VALUE  = nota-fiscal.cod-emitente .
                chworksheet:range("E" + STRING(wi) ):VALUE  = v-nomepessoa       .
                chworksheet:range("F" + STRING(wi) ):VALUE  = it-nota-fisc.it-codigo  .  
                chworksheet:range("G" + STRING(wi) ):VALUE  = item.desc-item.  
                chworksheet:range("H" + STRING(wi) ):VALUE  = item.class-fiscal.  
                chworksheet:range("I" + STRING(wi) ):VALUE  = it-nota-fisc.vl-preuni. 
                chworksheet:range("J" + STRING(wi) ):VALUE  = it-nota-fisc.qt-faturada[1].
                chworksheet:range("K" + STRING(wi) ):VALUE  = it-nota-fisc.vl-tot-item  .
                    
                ASSIGN wi = wi + 1 .
             end.
     
    
       
    end.   
 
         
 end.
 

 /*
chworksheet:PrintOut(YES).   
*/

DOS SILENT DEL VALUE(c-nome-plan). 

chworksheet:SaveAs (c-nome-plan).

chworkbook:CLOSE(YES).

RELEASE OBJECT chexcelapplication   .
RELEASE OBJECT chworkbook           .
RELEASE OBJECT chworksheet          .


 
message "Relat¢rio gerado no c:\temp\Relatorio_normal_vendas.xlsx " view-as alert-box.

DELETE WIDGET-POOL "janela".
