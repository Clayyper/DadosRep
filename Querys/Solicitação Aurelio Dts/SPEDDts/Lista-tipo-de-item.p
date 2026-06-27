/************************************************************/
/**         PROGRAMA PARA LISTA O TIPO DO ITEM             **/
/************************************************************/  
DEF VAR c-desc-tipo-item AS CHAR FORMAT "x(30)".


OUTPUT TO v:/TEMP/Lista-TipodoItem.txt.

PUT "Lista Tipo do Item para Todos os Itens Ativos (Relacionamento do Item X Estabelecimento - CD0147)"  SKIP(1)
    "Estab"         AT 01
    "Item"          AT 08
    "Tipo do Item"  AT 28
    SKIP
    "-----"               AT 01  
    "----------------"    AT 08
    "------------------------------"  AT 28
    SKIP.

FOR EACH item-uni-estab NO-LOCK,
    EACH ITEM where
         item.it-codigo = item-uni-estab.it-codigo and
         item.cod-obsoleto = 1 NO-LOCK:  /* 1 - Ativo */
    
  PUT  item-uni-estab.cod-estabel FORMAT "x(3)"   AT 01
       item-uni-estab.it-codigo   FORMAT "x(16)"  AT 08.
  IF substring(item-uni-estab.char-1,133,1) = "" THEN   ASSIGN c-desc-tipo-item = "Nao informado".
  IF substring(item-uni-estab.char-1,133,1) = "a" THEN  ASSIGN c-desc-tipo-item = "10- Outros Insumos".
  IF substring(item-uni-estab.char-1,133,1) = "b" THEN  ASSIGN c-desc-tipo-item = "99- Outras".
  IF substring(item-uni-estab.char-1,133,1) = "0" THEN  ASSIGN c-desc-tipo-item = "0 - Mercadoria para Revenda".
  IF substring(item-uni-estab.char-1,133,1) = "1" THEN  ASSIGN c-desc-tipo-item = "1 - Materia Prima".
  IF substring(item-uni-estab.char-1,133,1) = "2" THEN  ASSIGN c-desc-tipo-item = "2 - Embalagem".
  IF substring(item-uni-estab.char-1,133,1) = "3" THEN  ASSIGN c-desc-tipo-item = "3 - Produto em Processo".
  IF substring(item-uni-estab.char-1,133,1) = "4" THEN  ASSIGN c-desc-tipo-item = "4 - Produto Acabado".
  IF substring(item-uni-estab.char-1,133,1) = "5" THEN  ASSIGN c-desc-tipo-item = "5 - SubProduto".
  IF substring(item-uni-estab.char-1,133,1) = "6" THEN  ASSIGN c-desc-tipo-item = "6 - Produto Intermediario".
  IF substring(item-uni-estab.char-1,133,1) = "7" THEN  ASSIGN c-desc-tipo-item = "7 - Material de Uso e Consumo".
  IF substring(item-uni-estab.char-1,133,1) = "8" THEN  ASSIGN c-desc-tipo-item = "8 - Ativo Imobilizado".
  IF substring(item-uni-estab.char-1,133,1) = "9" THEN  ASSIGN c-desc-tipo-item = "9 - Servicos".

  put c-desc-tipo-item FORMAT "x(30)"  AT 28
      SKIP.
 END.
