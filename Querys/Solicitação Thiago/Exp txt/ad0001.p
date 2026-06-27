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

OUTPUT TO VALUE('C:\TEMP\NotasItens.TXT').

for each nota-fiscal where nota-fiscal.idi-sit-nf-eletro=3 
              and dt-atualiza>= v_dat_ini 
              and dt-atualiza<= v_dat_fim
              and (
                    (nat-operacao >= ('510101') and nat-operacao <= ('510106'))
                    or
                    (nat-operacao >= ('510201') and nat-operacao <= ('510206'))
                    or
                    (nat-operacao >= ('610101') and nat-operacao <= ('610103'))
                    or
                    (nat-operacao >= ('610201') and nat-operacao <= ('610203'))
                    or
                    nat-operacao=('710101')
                   )
              and cod-estabel>= v_estab_ini
              and cod-estabel<= v_estab_fim
              and nr-nota-fis>= v_nota_ini
              and nr-nota-fis<= v_nota_fim
              and cod-emitente >= v_cli_ini
              and cod-emitente <= v_cli_fim      no-lock:
                   
                   
    for each emscad.cliente 
            where emscad.cliente.cdn_cliente=nota-fiscal.cod-emitente:
     assign v-nomepessoa=cliente.nom_pessoa.
    end.
 
    
    for each it-nota-fisc
             where  it-nota-fisc.nr-nota-fis=nota-fiscal.nr-nota-fis:
             for each mgcad.item
                      where item.it-codigo=it-nota-fisc.it-codigo:
                 
                                  
                PUT unformatted nota-fiscal.nr-nota-fis ";"  nota-fiscal.serie ";" nota-fiscal.dt-atualiza ";"  nota-fiscal.cod-emitente ";"  v-nomepessoa ";" it-nota-fisc.it-codigo ";" 
                    item.desc-item ";" item.class-fiscal ";" it-nota-fisc.vl-preuni ";"  it-nota-fisc.qt-faturada[1] ";" it-nota-fisc.vl-tot-item skip.
             end.
     
    
       
    end.   
 
         
 end.
 
 OUTPUT CLOSE.

 
message "Fim de Programa" view-as alert-box.

DELETE WIDGET-POOL "janela".
