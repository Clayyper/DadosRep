Define Variable v_ch_excelapplication As COM-HANDLE                NO-UNDO . 
Define Variable v_nome_arquivo_padrao AS CHARACTER FORMAT "x(40)" NO-UNDO .
Define Variable v_ch_excelbook      As COM-HANDLE                  NO-UNDO .
Define Variable v_ch_excelsheet     As COM-HANDLE                  NO-UNDO .
Define Variable v_nome_arq_local    As Character    Format "x(30)" NO-UNDO .
Define Variable v_num_celula        AS INTEGER NO-UNDO .

/*Defini‡Æo do modelo do relatorio de aprovacao ccusto*/
ASSIGN v_nome_arquivo_padrao = SEARCH("doc\RelAprovCCusto.xls")
       v_num_celula = 2.

CREATE "excel.application" v_ch_excelapplication. 

ASSIGN v_ch_excelbook =v_ch_excelapplication:Workbooks:OPEN(v_nome_arquivo_padrao)
               v_ch_excelsheet=v_ch_excelapplication:Sheets("Dados") .

 ASSIGN v_nome_arq_local = "c:\temp\RelatorioAprovCCusto" + string(TIME) + ".xls".

 IF SEARCH(v_nome_arq_local) <> ? THEN OS-DELETE VALUE(v_nome_arq_local).
        v_ch_excelsheet:Saveas(v_nome_arq_local, 1, "", "", FALSE, FALSE, 1) NO-ERROR.

        v_ch_excelsheet:Unprotect("ccpplz_0306_1462"). 
FOR EACH pedido-compr NO-LOCK
    WHERE cod-estabel = "101"
    AND situacao = 1
/*     AND data-pedido >= 08/17/2015 */
/*     AND data-pedido <= 08/17/2015 */
    AND YEAR(data-pedido) = YEAR(TODAY)
    :
/*     DISP data-pedido situacao cod-emitente cod-estabel WITH 1 COLUMN WIDTH 320. */

    FOR EACH ordem-compra OF pedido-compr:
              v_ch_excelsheet:range( "A" + STRING(v_num_celula) ):VALUE = num-pedido .
              v_ch_excelsheet:range( "B" + STRING(v_num_celula) ):VALUE = data-pedido .
              v_ch_excelsheet:range( "D" + STRING(v_num_celula) ):VALUE = numero-ordem .
              v_ch_excelsheet:range( "E" + STRING(v_num_celula) ):VALUE = it-codigo .
              v_ch_excelsheet:range( "F" + STRING(v_num_celula) ):VALUE = ct-codigo .
              FIND emscad.ccusto WHERE emscad.ccusto.cod_ccusto = ordem-compra.sc-codigo NO-ERROR.
                  IF  AVAIL emscad.ccusto THEN DO:
                    v_ch_excelsheet:range( "G" + STRING(v_num_celula) ):VALUE = ordem-compra.sc-codigo + "-" + emscad.ccusto.des_tit_ctbl.
                  END.
              v_ch_excelsheet:range( "H" + STRING(v_num_celula) ):VALUE = qt-solic.
              v_ch_excelsheet:range( "I" + STRING(v_num_celula) ):VALUE = preco-fornec .
              v_ch_excelsheet:range( "J" + STRING(v_num_celula) ):VALUE = (qt-solic * preco-fornec) .
        ASSIGN v_num_celula = v_num_celula + 1.
    END.
        
END.

 v_ch_excelbook:Save.
 v_ch_excelapplication:visible = TRUE.   
 RELEASE OBJECT v_ch_excelsheet       .
 RELEASE OBJECT v_ch_excelbook        .
