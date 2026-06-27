DEF BUFFER bdoc-pend-aprov FOR doc-pend-aprov .

DEF VAR d-date   AS DATE INIT TODAY .
DEF VAR de-total AS DEC INIT 0 .
DEF VAR wi       AS INTEGER INIT 0 .
DEF VAR c-narrativa AS CHAR FORMAT "x(200)" COLUMN-LABEL "Descricao" .
DEF VAR c-linha AS CHAR FORMAT "x(150)" .
DEF VAR c-nome-plan         AS CHARACTER FORMAT "x(256)"  NO-UNDO .
DEF VAR c-nome-anexos       AS CHARACTER FORMAT "x(256)"  NO-UNDO .



/*--------------- Definicao para usar o Excel ------------------*/
DEFINE VARIABLE h-acomp       AS   HANDLE                 NO-UNDO .
DEFINE VAR chexcelapplication AS COM-HANDLE .
DEFINE VAR chworkbook         AS COM-HANDLE .
DEFINE VAR chworksheet        AS COM-HANDLE .



ASSIGN d-date = d-date - 1 .


{utp/utapi019.i}
run utp/utapi019.p persistent set h-utapi019.
create tt-envio2.
assign tt-envio2.versao-integracao = 1
       tt-envio2.exchange    = yes
       tt-envio2.destino     = "toxa@adler.com.br" 
       tt-envio2.copia       = "clayson@adler.com.br" 

    /*
    tt-envio2.destino     = "marcio.pereira@hpelzer.com.br" 
    tt-envio2.copia       = "" 
    */

       tt-envio2.assunto     = "Teste de envio ADLER 2 " + STRING (  d-date , "99/99/9999"  )  
       tt-envio2.importancia = 2
       tt-envio2.log-enviada = NO
       tt-envio2.log-lida    = NO 
       tt-envio2.acomp       = NO
       tt-envio2.formato     = "TEXTO".
       



create tt-mensagem.
    assign 
        tt-mensagem.seq-mensagem = 1
        tt-mensagem.mensagem  = "   O relat½rio de Aprova?„es das Compras (MRO) da PELZER BAHIA, PLANTA 402 - DDA   do dia " + 
                            STRING ( d-date, "99/99/9999" ) + 
                            " , esta no documento em Anexo !!!"  + CHR(13) .


create tt-mensagem.
    assign 
        tt-mensagem.seq-mensagem = 2 
        tt-mensagem.mensagem  = CHR(13) + "   Favor N€O responder a essa mensagem automÿtica !!!"  .


output to value(session:temp-directory + "envemail.txt").       

run pi-execute2 in h-utapi019 (input table tt-envio2,
                               input table tt-mensagem,    
          	                   output table tt-erros).


output close.

if  return-value = "NOK" then do:
    for each tt-erros:
        disp tt-erros with 1 column width 300.
    end.                               
end.

delete procedure h-utapi019.

