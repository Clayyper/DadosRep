/*EMS206*/
FOR EACH  nota-fiscal EXCLUSIVE-LOCK
    WHERE nota-fiscal.cod-estabel  = '101'
    AND   nota-fiscal.serie        = '6'
    AND   nota-fiscal.nr-nota-fis  = '0003029':

    FIND FIRST sit-nf-eletro EXCLUSIVE-LOCK
         WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
         AND   sit-nf-eletro.cod-serie    = nota-fiscal.serie
         AND   sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis NO-ERROR.

    /*OBSERVA€ÇO:******************************************************************************/
    /*ap¢s definir dt-cancela = ? o valor da posi‡Æo 3 do campo IECFOAT no FT0904 passa para N*/
    /******************************************************************************************/
  
     ASSIGN nota-fiscal.dt-cancela   = ?
            nota-fiscal.desc-cancela = "".

     IF AVAIL sit-nf-eletro THEN DO:

         /*  2 = Em processamento no EAI          */
         /*  3 = Uso autorizado                   */		 
         /*  7 = Documento Inutilizado            */
         /* 12 = NF-e em Processo de Cancelamento */

          ASSIGN sit-nf-eletro.idi-sit-nf-eletro = 2. 

     END. 

    DISP nota-fiscal.cod-estabel
         nota-fiscal.serie
         nota-fiscal.nr-nota-fis
         nota-fiscal.dt-cancela
         INT(sit-nf-eletro.idi-sit-nf-eletro)
         {diinc/i01di135.i 04 sit-nf-eletro.idi-sit-nf-eletro} FORMAT "X(200)"
         WITH 1 COL WIDTH 333.

END.

/*
/*TOTVS 11*/
for each nota-fiscal exclusive-lock
     WHERE nota-fiscal.cod-estabel = "101"
     AND   nota-fiscal.serie       = "2"
     AND   nota-fiscal.nr-nota-fis = "0009416".
             
    FOR EACH sit-nf-eletro  
       WHERE sit-nf-eletro.cod-estabel  = nota-fiscal.cod-estabel
         AND sit-nf-eletro.cod-serie    = nota-fiscal.serie  
         AND sit-nf-eletro.cod-nota-fis = nota-fiscal.nr-nota-fis EXCLUSIVE-LOCK.
         
        
         
         ASSIGN sit-nf-eletro.idi-sit-nf-eletro = 1 NO-ERROR. /*NFE GERADA*/ */
         
          message "sit-nf-eletro" skip
                 sit-nf-eletro.cod-estabel skip
                 sit-nf-eletro.cod-serie skip
                 sit-nf-eletro.cod-nota-fis skip
                 sit-nf-eletro.idi-sit-nf-eletro skip
                 {diinc/i01di135.i 04 sit-nf-eletro.idi-sit-nf-eletro}
                 view-as alert-box.
         
    end.
     
    /*ASSIGN nota-fiscal.dt-cancela   = ?*/
           nota-fiscal.desc-cancela = ""
           nota-fiscal.idi-sit-nf-eletro = 1.
           
    message "Nota Fiscal" skip
             nota-fiscal.cod-estabel skip
             nota-fiscal.serie skip
             nota-fiscal.nr-nota-fis skip
             nota-fiscal.dt-cancela skip
             nota-fiscal.idi-forma-emis-nf-eletro skip
             {diinc/i01di135.i 04 nota-fiscal.idi-forma-emis-nf-eletro} skip
             nota-fiscal.idi-sit-nf-eletro skip
             {diinc/i01di135.i 04 nota-fiscal.idi-sit-nf-eletro}
             view-as alert-box.
     
end.
*/
