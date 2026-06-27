def var v-nomepessoa    like emscad.cliente.nom_pessoa   column-label "Razao-Social".
def var v-descitem      like mgcad.item.desc-item        column-label "Desc_item".
OUTPUT TO VALUE('C:\TEMP\NotasItens.TXT').

for each nota-fiscal where nota-fiscal.idi-sit-nf-eletro=3 
              and dt-atualiza>=01/01/2014 
              and dt-atualiza<=01/31/2014
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
                   ) no-lock:
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
                 
  
                    
