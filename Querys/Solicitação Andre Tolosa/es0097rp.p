/*******************************************************************************
 * Empresa  : DATASUL METROPOLITANA S/A
 * cliente  : Pelzer
 * Programa : ES0097RP.P
 * Descricao: Aviso de Embarque 
 * Autor    : M†rcio A. Pereira
 * Data     : Julho de 2004
 * Versao   : 2.00.000 - M†rcio A. Pereira
 *            Versao Inicial.
              2.00.001 - M†rcio A. Pereira  (05/08/2004)
              Alteraá∆o para permitir a geraá∆o de v†rios avisos de embarques 
              para clientes diferentes  (DSH) e (DSC) .
              2.00.002 - M†rcio A. Pereira  (22/10/2004) 
              Alterada a sequencia da leitura dos registros do item da nota-fiscal 
              de it-codigo para nr-seq-fat
              2.00.003 - M†rcio A. Pereira  (22/10/2004)
              Desenvolvida uma mascara para impressao dos Itens da VW  
              2.00.004 - M†rcio A. Pereira  (29/10/2004)
              Implementada a rotina de enviar e-mail com arquivo anexado para a Mercedes Benz 
              2.00.005 - M†rcio A. Pereira  (17/11/2004)
              Desenvolvido um novo Lay-Out para geraá∆o de arquivos do tipo EDIFACT 
              2.00.006 - M†rcio A. Pereira  (13/12/2004)
              Desenvolvido o Lay-Out para a GM  P&A e GM Mat. Prima 
              2.00.007 - M†rcio A. Pereira  (16/12/2004)
              Desenvolvido o Lay-out para a Lear (RND)
              2.00.008 - M†rcio A. Pereira  (27/12/2004)
              Desenvolvido o Lay-out para a Ford (RND)
              2.00.009 - M†rcio A. Pereira  (17/03/2005)
              Manutená∆o no programa para atualizar a tabela es-deljit
              e tambÇm para n∆o criar arquivo texto sem conteudo .
              2.00.010 - M†rcio A. Pereira (09/05/2005)
              Inclus∆o do Lay-Out da PSA 
              2.00.011 - M†rcio A. Pereira / Vagner Clemente (14/09/2005)
              Correá∆o de erro Progress (Wait for statement) 
              2.00.012 - M†rcio A. Pereira (30/08/2005)
              Envio de Notas Fiscais Complementares (Tipo 4) para a DAIMLER - Embalagens
              2.00.013 - M†rcio A. Pereira (12/02/2007)
              Arrendondamento do campo Peso Bruto do arquivo de EDIFACT da GM 
              2.00.014 - M†rcio A. Pereira (13/04/2007)
              Implementaá∆o da funá∆o de Reenvio
              2.00.015 - M†rcio A. Pereira ( 17/04/2007 )
              Mascarar os c¢digo para a Daimler 
              2.00.016 - M†rcio A. Pereira ( 22/04/2007 )
              Alteraá∆o para verificar os Numeros de Pedidos da Ford (Exportaá∆o ) 
              2.00.017 - M†rcio A. Pereira ( 04/09/2007 )
              Inclus∆o da Opc∆o para gerar arquivos no diret¢rio da Sintel 
              2.00.018 - M†rcio A. Pereira ( 25/10/2007)
              Alteraá∆o dos Lay-outs padr‰es ITP004 para padr∆o Sintel
              2.00.019 - M†rcio A. Pereira ( 18/04/2008)
              Inclus∆o dos Registros NF2 e NF4 para Clientes de DSH
              2.00.020 - M†rcio A. Pereira ( 12/09/2008)
              Criaá∆o de Log na tabela es-nota-fiscal 
              2.00.021 - M†rcio A. Pereira ( 28/04/2009 )
              Alteraá∆o da sequencia dos itens do AEG para igualar com a NF eletronica
              2.00.022 - M†rcio A. Pereira ( 06/05/2009)
              Foi interrompido a geraá∆o de avisos de embarque ITP004 para a VW .
              2.00.023 - M†rcio A. Pereira ( 27/05/2009 )
              Alterado a vers∆o do AEG, para AEGv05 apenas para clientes do DSH
              2.00.024 - M†rcio A. Pereira (11/04/2010)
              Alterado para criar um novo segmento para a NFE, atendendo solicitacoes da FAURECIA
              \\192.168.120.45\sintel\out\grupo\
              2.00.025 - M†rcio A. Pereira (11/10/2011)
              Alterado para apenas considerar os codigos de planta dos pedidos em "PROCEDURE pi-gera-AEGv02"
              
 *
 ******************************************************************************/

/* Codigos de Parceiros EDI           Envia
   200.002 = Ford        - RND                 
   200.004 = GM          - EDIFACT     X
   200.005 = VW          - RND
   200.006 = GM (P&A)    - EDIFACT     X
   200.007 = Lear        - RND         X
   200.008 = Daimler SBC - RND
   200.009 = Daimler MG  - RND
   200.010 = PSA         - EDIFACT 
   200.011 = Faurecia    - AEGv02
*/


/*------------- Definicao de Buffer -----------------------------------------*/
DEFINE BUFFER b-it-nota-fisc       FOR it-nota-fisc .
DEFINE BUFFER b-emitente           FOR emitente .    
DEFINE BUFFER b-emitente-estabelec FOR emitente .    
DEFINE BUFFER b-es-etiq-psa        FOR es-etiq-psa .

/*------------- Definicao de Temp-Table --------------------------------------*/
DEFINE TEMP-TABLE tt-param
    FIELD destino          AS INTEGER 
    FIELD arquivo          AS CHAR 
    FIELD usuario          AS CHAR FORMAT "x(12)"
    FIELD data-exec        AS DATE 
    FIELD hora-exec        AS INTEGER 
    FIELD cod-estabel    LIKE nota-fiscal.cod-estabel
    FIELD serie          LIKE nota-fiscal.serie
    FIELD cliente-ini    LIKE nota-fiscal.cod-emitente
    FIELD nr-nota-ini    LIKE nota-fiscal.nr-nota-fis
    FIELD nr-nota-fim    LIKE nota-fiscal.nr-nota-fis
    FIELD dt-emis-ini    AS   DATE FORMAT  "99/99/9999"
    FIELD dt-emis-fim    AS   DATE FORMAT  "99/99/9999" 
    FIELD reenvia        AS   LOGICAL INIT NO 
    FIELD conc           AS   LOGICAL INIT NO 
    FIELD grupo          AS   CHAR INIT "" 
    FIELD edi            AS   INTEGER .

DEFINE TEMP-TABLE tt-log-conf
    FIELD cod-estabel     LIKE nota-fiscal.cod-estabel
    FIELD serie           LIKE nota-fiscal.serie
    FIELD nr-nota-fis     LIKE nota-fiscal.nr-nota-fis
    FIELD nr-seq-fat      LIKE it-nota-fisc.nr-seq-fat
    FIELD it-codigo       LIKE it-nota-fisc.it-codigo
    FIELD dt-emissao      LIKE nota-fiscal.dt-emis-nota
    FIELD nr-pedcli       LIKE nota-fiscal.nr-pedcli
    FIELD nome-abrev      LIKE nota-fiscal.nome-ab-cli
    FIELD nat-operacao    LIKE nota-fiscal.nat-operacao
    FIELD vl-preuni       LIKE it-nota-fisc.vl-preuni
    FIELD valor-icms      LIKE nota-fiscal.vl-tot-ipi
    FIELD valor-ipi       LIKE nota-fiscal.vl-tot-ipi
    FIELD Valor-tot       LIKE nota-fiscal.vl-tot-nota
    INDEX nota cod-estabel
               serie
               nr-nota-fis
               nr-seq-fat
               it-codigo
               .

DEFINE TEMP-TABLE t-nf-edi
    FIELD cod-estabel      LIKE nota-fiscal.cod-estabel
    FIELD serie            LIKE nota-fiscal.serie
    FIELD nr-nota-fis      LIKE nota-fiscal.nr-nota-fis
    FIELD cod-parceiro-edi LIKE emitente.cod-parceiro-edi
    INDEX idx-nota IS PRIMARY UNIQUE cod-estabel serie nr-nota-fis 
    INDEX idx-parceiro cod-parceiro-edi cod-estabel serie nr-nota-fis .



DEFINE TEMP-TABLE tt-raw-digita FIELD raw-digita AS RAW .

/*-------------- Definicao Parametros -----------------------------------*/
DEFINE INPUT PARAMETER raw-param AS RAW NO-UNDO .
DEFINE INPUT PARAMETER TABLE FOR tt-raw-digita .

/*--------------- Definicao de Variaveis --------------------------------*/
DEFINE VARIABLE h-acomp          AS   HANDLE    NO-UNDO .
DEFINE VARIABLE c-cgc            AS   CHARACTER NO-UNDO .
DEFINE VARIABLE rc-cgc           AS   CHARACTER NO-UNDO .
DEFINE VARIABLE i-tam            AS   INTEGER   NO-UNDO .
DEFINE VARIABLE i-reg-trans      AS   INTEGER   NO-UNDO .
DEFINE VARIABLE i-tot-item-nf    AS   INTEGER   NO-UNDO .
DEFINE VARIABLE c-dt-emissao     AS   CHARACTER NO-UNDO .
DEFINE VARIABLE c-dt-saida       AS   CHARACTER NO-UNDO .
DEFINE VARIABLE c-dt-prvenc      AS   CHARACTER NO-UNDO .
DEFINE VARIABLE de-tot-icms      LIKE it-nota-fisc.vl-icms-it  NO-UNDO .
DEFINE VARIABLE de-tot-icms-sub  LIKE it-nota-fisc.vl-icms-it NO-UNDO .                
DEFINE VARIABLE c-sit-trib       AS   CHARACTER NO-UNDO .
DEFINE VARIABLE c-ped-lin-vw-ford     AS   CHARACTER NO-UNDO .
DEFINE VARIABLE c-ger-movto      AS   CHARACTER NO-UNDO .
DEFINE VARIABLE v_log_gerou_mov  AS   LOGICAL   NO-UNDO INIT  FALSE  .
DEFINE VARIABLE l-first          AS   LOGICAL   NO-UNDO INIT  YES .
DEFINE VARIABLE i-cod-gr-cli     LIKE emitente.cod-gr-cli NO-UNDO .
DEFINE VARIABLE c-planta         AS   CHARACTER FORMAT "x(3)"  NO-UNDO  .
DEFINE VARIABLE c-doca           LIKE es-deljit.cod-doca       NO-UNDO  .
DEFINE VARIABLE c-serie          LIKE nota-fiscal.serie        NO-UNDO .
DEFINE VARIABLE c-arq-saida      AS   CHARACTER FORMAT "x(20)" NO-UNDO .
DEFINE VARIABLE c-diretorio      AS   CHARACTER FORMAT "x(40)" NO-UNDO .
DEFINE VARIABLE c-arq-saida-full AS   CHARACTER FORMAT "x(20)" NO-UNDO .
DEFINE VARIABLE c-arq-bkp        AS   CHARACTER FORMAT "x(20)" NO-UNDO .
DEFINE VARIABLE c-peso-brut      AS   CHARACTER                NO-UNDO .
DEFINE VARIABLE de-peso-real     AS   DECIMAL FORMAT ">>>>>>>>9.999"  NO-UNDO .
DEFINE VARIABLE de-peso-cubado   AS   DECIMAL FORMAT ">>>>>>>>9.999"  NO-UNDO .
DEFINE VARIABLE de-vl-pis        AS   DEC INITIAL 0 NO-UNDO .
DEFINE VARIABLE de-vl-cofins     AS   DEC INITIAL 0 NO-UNDO .
DEFINE VARIABLE de-tot-bicmssubs AS   DEC INITIAL 0 NO-UNDO .   
DEFINE VARIABLE de-tot-icmssubs  AS   DEC INITIAL 0 NO-UNDO .   


DEF VAR l-erro AS LOGICAL INIT NO .
DEF VAR c-mod AS CHAR FORMAT "x(3)" .
DEF VAR c-cod AS CHAR FORMAT "x(9)" .
DEF VAR c-cor AS CHAR FORMAT "x(3)" .
DEF VAR wi    AS INTEGER INIT 0 .
DEF VAR c-it-codigo AS CHAR FORMAT "x(30)" LABEL "Nova Codificacao" .
DEF VAR v-comcode-cli AS CHAR NO-UNDO .
DEF VAR v-comcode-est AS CHAR NO-UNDO .
DEF VAR v-literal     AS CHAR NO-UNDO .
DEF VAR v-duns-number AS CHAR NO-UNDO .
DEF VAR de-qtde       AS DEC  NO-UNDO .
DEF VAR i-lin         AS INT  NO-UNDO .
DEF VAR c-montadora   AS CHAR NO-UNDO .
DEF VAR c-sis-emissor AS CHAR NO-UNDO .
DEF VAR c-tipo-fornec AS CHAR NO-UNDO  FORMAT "x(1)" .
DEF VAR c-codigo-interno AS CHAR FORMAT "x(8)" NO-UNDO .

DEF VAR wa AS CHAR FORMAT "x(500)" VIEW-AS EDITOR SCROLLBAR-VERTICAL 
       SIZE 58 BY 3 FONT 5  NO-UNDO .
DEF VAR wb AS CHAR FORMAT "x(10)" NO-UNDO .
DEF VAR wj AS INTEGER INIT 0 NO-UNDO .
DEF VAR wk AS INTEGER INIT 0 NO-UNDO .

DEFINE VARIABLE i-qtde-item      AS   INTEGER INITIAL 0  NO-UNDO .
DEFINE VARIABLE i-segmentos      AS   INTEGER INITIAL 0  NO-UNDO .
DEFINE VARIABLE c-data-hora      AS   CHARACTER FORMAT "x(12)" NO-UNDO .
DEFINE VARIABLE c-data-hora-ger  AS   CHARACTER FORMAT "x(12)" NO-UNDO .
DEFINE VARIABLE c-fabrica        AS   CHARACTER FORMAT "x(20)" NO-UNDO .
DEFINE VARIABLE de-vl-bicms-it   LIKE it-nota-fisc.vl-bicms-it NO-UNDO .
DEFINE VARIABLE i-nr-lin-nf      AS   INTEGER INITIAL 0  NO-UNDO .
DEFINE VARIABLE c-qualif-transp  AS   CHAR NO-UNDO .
DEFINE VARIABLE c-modo-transp    AS   CHAR NO-UNDO .
DEFINE VARIABLE c-codigo-transp  AS   CHAR NO-UNDO .
DEFINE VARIABLE c-un-emb         AS   CHAR NO-UNDO .
DEFINE VARIABLE de-qt-entrega    AS   DEC NO-UNDO .

DEF NEW GLOBAL SHARED VAR v_cod_usuar_corren AS CHARACTER FORMAT "x(12)":U LABEL  "Usu†rio Corrente" COLUMN-LABEL  "Usu†rio Corrente" NO-UNDO .

{CDP/CDMENS.I}
{cdp/cdfreeac.i} 
{utp/utapi009.i}

/*--------------- Definiá∆o de Streams ----------------------------------*/
DEFINE STREAM edi .      /* Edi Novo   */
DEFINE STREAM ediant .   /* Edi Antigo */

/*--------------- Definicao de Frames -----------------------------------*/
DEFINE FRAME f_impressao
        HEADER 
        "Est"               AT  01
        "Serie"             AT  05
        "Nr Nota"           AT  11
        "Emissao"           AT  23
        "Nr.Pedido"         AT  35
        "Nome Abrev"        AT  49
        "Nat.Op"            AT  61
        "Seq"               AT  70
        "Item"              AT  76
        FILL("-",3)         AT  01       FORMAT "x(03)"
        FILL("-",05)        AT  05       FORMAT "x(05)"
        FILL("-",10)        AT  11       FORMAT "x(10)"
        FILL("-",10)        AT  23       FORMAT "x(10)"
        FILL("-",12)        AT  35       FORMAT "x(12)"
        FILL("-",10)        AT  49       FORMAT "x(10)"
        FILL("-",06)        AT  61       FORMAT "x(06)"
        FILL("-",04)        AT  70       FORMAT "x(04)"
        FILL("-",16)        AT  76       FORMAT "x(16)"
        WITH WIDTH 132 PAGE-TOP STREAM-IO NO-BOX .


/*--------------- Definiá∆o de Functions --------------------------------*/
/*  Troca o CiscoCode pela Planta */
FUNCTION fn-localiza-planta-gm RETURNS CHAR (INPUT p-string AS CHAR ) .
    DEFINE VAR c-texto AS CHAR CASE-SENSITIVE NO-UNDO .
    
    ASSIGN c-texto = p-string .
    CASE c-texto :
        WHEN "23005" THEN ASSIGN c-texto = "MX" .
        WHEN "23762" THEN ASSIGN c-texto = "2E" .
        WHEN "23764" THEN ASSIGN c-texto = "2M" .
        WHEN "23765" THEN ASSIGN c-texto = "RA" .
        WHEN "23780" THEN ASSIGN c-texto = "MT" .
        WHEN "51160" THEN ASSIGN c-texto = "30" .
        WHEN "72475" THEN ASSIGN c-texto = "G1" .
        WHEN "72477" THEN ASSIGN c-texto = "4M" .
        WHEN "72479" THEN ASSIGN c-texto = "09" .
        WHEN "72480" THEN ASSIGN c-texto = "BE" .
        WHEN "72481" THEN ASSIGN c-texto = "02" .
        WHEN "72664" THEN ASSIGN c-texto = "CK" .
        WHEN "72667" THEN ASSIGN c-texto = "4E" .
        WHEN "72668" THEN ASSIGN c-texto = "4J" .
        WHEN "72669" THEN ASSIGN c-texto = "C2" .
        WHEN "72671" THEN ASSIGN c-texto = "B1" .
        WHEN "72677" THEN ASSIGN c-texto = "C1" .
        WHEN "72681" THEN ASSIGN c-texto = "RO" .
        WHEN "72682" THEN ASSIGN c-texto = "CO" .
        WHEN "72683" THEN ASSIGN c-texto = "WE" .
        WHEN "72684" THEN ASSIGN c-texto = "WF" .
        WHEN "72443" THEN ASSIGN c-texto = "E1" .
        WHEN "72452" THEN ASSIGN c-texto = "E2" .
        WHEN "72132" THEN ASSIGN c-texto = "E3" .
        WHEN "72322" THEN ASSIGN c-texto = "E4" .
        WHEN "72258" THEN ASSIGN c-texto = "E5" .
        WHEN "72359" THEN ASSIGN c-texto = "E6" .
        WHEN "72281" THEN ASSIGN c-texto = "E7" .
        WHEN "51269" THEN ASSIGN c-texto = "E8" .
        WHEN "72410" THEN ASSIGN c-texto = "E9" .
        WHEN "72290" THEN ASSIGN c-texto = "EA" .
        WHEN "72329" THEN ASSIGN c-texto = "EB" .
        WHEN "72263" THEN ASSIGN c-texto = "EC" .
        WHEN "72395" THEN ASSIGN c-texto = "ED" .
        WHEN "44387" THEN ASSIGN c-texto = "EE" .
        WHEN "72444" THEN ASSIGN c-texto = "EF" .
        WHEN "72325" THEN ASSIGN c-texto = "EG" .
        WHEN "72282" THEN ASSIGN c-texto = "EH" .
        WHEN "72358" THEN ASSIGN c-texto = "EI" .
        WHEN "72218" THEN ASSIGN c-texto = "EJ" .
        WHEN "72474" THEN ASSIGN c-texto = "KK" .
        WHEN "72506" THEN ASSIGN c-texto = "KJ" .
        WHEN "72507" THEN ASSIGN c-texto = "B2" .


    END CASE.

    RETURN c-texto.

END FUNCTION .



/*--------------- Cria Parametro ----------------------------------------*/
CREATE tt-param. 
RAW-TRANSFER raw-param TO tt-param.

FIND FIRST tt-param NO-LOCK NO-ERROR .

{include/i-rpvar.i}
FIND FIRST param-global NO-LOCK NO-ERROR .
FIND empresa WHERE empresa.ep-codigo=param-global.empresa-prin NO-LOCK NO-ERROR .
 
ASSIGN 
    c-empresa     =empresa.razao-social
    c-titulo-relat="Log - Confirmacao de Embarque"
    c-sistema     ="Especifico"
    c-programa    =""
    c-versao      ="2.00"
    c-revisao     ="023".

/*{include/i-rpcab.i}*/
/****************************************************************************
**
**  I-RPCAB.I - Form do Cabeáalho Padr∆o e RodapÇ (ex-CD9500.F)
**                              
** {&stream} - indica o nome da stream (opcional)
****************************************************************************/
FORM HEADER 
    FILL("-", 132)          FORMAT "x(132)"     SKIP 
    c-empresa 
    c-titulo-relat  AT  50
    "Folha:"        AT  122 
    PAGE-NUMBER     AT  128  FORMAT ">>>>9"      SKIP 
    FILL("-", 112)           FORMAT "x(110)" 
    TODAY                    FORMAT "99/99/9999"
    "-" 
    STRING(TIME,"HH:MM:SS")                     SKIP(1) 
WITH STREAM-IO WIDTH 132 NO-LABELS NO-BOX PAGE-TOP FRAME f-cabec.

ASSIGN c-rodape="DATASUL - " + c-sistema + " - " + c-programa + " - V:" + c-versao + "." + c-revisao
       c-rodape=FILL("-", 132 - LENGTH(c-rodape)) + c-rodape.

FORM HEADER c-rodape FORMAT "x(132)"
WITH STREAM-IO WIDTH 132 NO-LABELS NO-BOX PAGE-BOTTOM FRAME f-rodape.

/*---------------- Bloco Principal ---------------------------------------*/

RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
RUN pi-inicializar IN h-acomp (INPUT "Impress∆o").
RUN pi-seta-tipo   IN h-acomp (INPUT 6).

IF tt-param.edi EQ 1  THEN DO:    /* Sintel */

    IF param-global.empresa-prin EQ 1 THEN ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\mp\"  .
    ELSE ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\grupo\"  .

END.
ELSE DO:   /* Integrator e Emvia */
    ASSIGN c-diretorio = "q:\EDI\OUT\"  .
END.


FIND b-emitente WHERE b-emitente.cod-emitente EQ tt-param.cliente-ini  NO-LOCK NO-ERROR .

/* Verifica se o Aviso de Embarque pertence a Daimler  */
IF tt-param.conc               EQ NO AND 
   AVAIL b-emitente                  AND 
   ( b-emitente.cod-parceiro-edi EQ 200008 OR  /* Daimler */
     b-emitente.cod-parceiro-edi EQ 200009 )   THEN  DO:

    ASSIGN 
        c-arq-saida      = "DCBR" + STRING( CURRENT-VALUE(msgid) , "9999" )  
        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" 
        v_log_gerou_mov  = FALSE .

END.

/* Verificar em que diretorio sera gravado para as Montadoras */
ELSE DO:

    IF AVAIL b-emitente AND 
        ( b-emitente.cod-parceiro-edi EQ 200005 )  THEN DO :   /* VW */
        ASSIGN 
            c-arq-saida      = "VWB" + STRING( CURRENT-VALUE(msgid) , "9999" )  
            c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" 
            v_log_gerou_mov  = FALSE .
    END.
    ELSE DO : 

        ASSIGN c-montadora = "" .
        IF b-emitente.cod-parceiro EQ 200002 THEN ASSIGN c-montadora = "FORD" .
        IF b-emitente.cod-parceiro EQ 200007 THEN ASSIGN c-montadora = "LEAR" .
        IF b-emitente.cod-parceiro EQ 200011 THEN ASSIGN c-montadora = "FAUR" .


        ASSIGN     /*  Outras Montadoras */
            c-arq-saida      = TRIM(c-montadora) + TRIM(tt-param.nr-nota-ini)  + TRIM(tt-param.serie)  
            c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .
            v_log_gerou_mov  = FALSE .

    END.

    IF tt-param.conc EQ YES  THEN DO :   /* DSH  */
        ASSIGN 
            c-arq-saida      = "VWB" + STRING( CURRENT-VALUE(msgid) , "9999" )  
            c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .
            v_log_gerou_mov  = FALSE .

    END.


END.


FIND estabelec WHERE estabelec.cod-estabel EQ tt-param.cod-estabel NO-LOCK NO-ERROR .

/*
/* Verificar o Link caso o parceiro de EDI seja 200004 ou 200006 GMB */
IF AVAIL b-emitente AND 
    ( b-emitente.cod-parceiro-edi EQ 200004 OR      /* GM */
      b-emitente.cod-parceiro-edi EQ 200006 )  THEN DO:
    RUN pi-verifica-link .
    IF INT(wb) NE  0  THEN   DO :
        RUN pi-finalizar IN h-acomp.
        RUN pi-message("CAIXA POSTAL DA EMBRATEL INDISPONIVEL NO MOMENTO, POR FAVOR, TENTE NOVAMENTE DAQUI A ALGUNS INSTANTES OU LIGUE P/ DEPTO. TI !!!") .
        RETURN ERROR .
    END.
END.
*/

IF tt-param.cliente-ini EQ 0 THEN ASSIGN i-cod-gr-cli = INT (SUBSTR(tt-param.grupo , 1, 1 ) ) .
ELSE ASSIGN i-cod-gr-cli = b-emitente.cod-gr-cli .

EMPTY TEMP-TABLE tt-log-conf  NO-ERROR.

/* Geraá∆o de Dados em EDIFACT ou RND */
IF AVAIL b-emitente THEN DO: 

    IF   b-emitente.cod-parceiro-edi EQ 200002 THEN DO:      /* Ford */
        
        /*
        RUN pi-gera-dados-rnd-ford .  
        */
        
        RUN pi-gera-AEGv02 .          
        

    END.

    IF ( b-emitente.cod-parceiro-edi EQ 200004 OR  
         b-emitente.cod-parceiro-edi EQ 200006  )  THEN DO:  /* GM  */
        
        /*
        RUN pi-gera-dados-fact-gm .   
        */

        RUN pi-gera-AEGv02 .   

    END.
    
    
    IF ( b-emitente.cod-parceiro-edi EQ 200005 OR            /* Volks */
         b-emitente.cod-parceiro-edi EQ 200008 OR            /* Daimler */
         b-emitente.cod-parceiro-edi EQ 200009 )   THEN DO:  /* Daimler */ 
        
        /*
        RUN pi-gera-dados-rnd . 
        */

        RUN pi-gera-AEGv02 .   

    END.

    
    IF   b-emitente.cod-parceiro-edi EQ 200007     THEN DO:  /* Lear */
        /*
        RUN pi-gera-dados-rnd-lear .   
        */

        RUN pi-gera-AEGv02 .  

    END.

    IF   b-emitente.cod-parceiro-edi EQ 200010     THEN DO:  /* PSA */  

        RUN pi-gera-dados-fact-psa .
        
        RUN pi-gera-AEGv02 .  

    END.

    
    IF   b-emitente.cod-parceiro-edi EQ 200011     THEN DO:  /* FAURECIA */  

        RUN pi-gera-AEGv02 .  

    END.


    IF tt-param.conc EQ YES AND tt-param.cliente-ini EQ 0  THEN DO:  /* DSH */ 
        
        /*
        RUN pi-gera-dados-rnd .  
        */

        IF i-cod-gr-cli EQ 2 THEN DO:  /* Apenas o DSH da VW ira usar a vers∆o 05 do AEG */
            RUN pi-gera-AEGv05 .          
        END.
        ELSE DO:
            RUN pi-gera-AEGv02 .          
        END.

    END.
    

END.


FIND FIRST tt-log-conf NO-ERROR .
IF NOT AVAIL tt-log-conf THEN DO:
    RUN pi-message("Para a selecao informada, nao foi gerado nenhum registro no arquivo !!!") .
    OS-DELETE VALUE(c-arq-saida-full).
    RUN pi-finalizar IN h-acomp.

    /* Caso seja NF da Ford de TaubatÇ, dever∆o ser impressas as etiquetas de Embarque, mesmo quando n∆o tiver sido reenviado o aviso */
    IF tt-param.cod-estabel EQ "403" THEN DO:
        RUN esp/es0097a.p ( INPUT tt-param.cod-estabel, INPUT tt-param.serie , INPUT tt-param.nr-nota-ini , INPUT tt-param.nr-nota-fim ) .
    END.

    RETURN ERROR .

END.

{include/i-rpout.i}
RUN PI-Imprime_Log.
{include/i-rpclo.i}


RUN pi-finalizar IN h-acomp.


/* Caso seja NF da Ford de TaubatÇ, dever∆o ser impressas as etiquetas de Embarque */

IF tt-param.cod-estabel EQ "403" THEN DO:
    RUN esp/es0097a.p ( INPUT tt-param.cod-estabel, INPUT tt-param.serie , INPUT tt-param.nr-nota-ini , INPUT tt-param.nr-nota-fim ) .
END.



/*------------- Procedures Internas --------------------------------------*/
 
PROCEDURE pi-gera-dados-rnd .

    /*  CGC DO ESTABELECIMENTO DA PELZER */
    ASSIGN c-cgc = "" .
    DO i-tam = 1 TO LENGTH(estabelec.cgc):
       IF LOOKUP(SUBSTRING(estabelec.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
          ASSIGN c-cgc = c-cgc + SUBSTRING(estabelec.cgc,i-tam,1) .
    END .

    /* CGC DO CLIENTE DA NOTA FISCAL */
    IF AVAIL b-emitente THEN DO : 

        ASSIGN rc-cgc = "59104422005704" .    /* Seta CGC Padr∆o da VW para o parceiro 200.005 */

        IF b-emitente.cod-parceiro-edi EQ 200002 THEN ASSIGN rc-cgc = "03470727000120" .  /*  FORD */ 

        IF b-emitente.cod-parceiro-edi EQ 200004 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200006 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200007 OR  /* Lear    */
           b-emitente.cod-parceiro-edi EQ 200008 OR  /* Daimler */
           b-emitente.cod-parceiro-edi EQ 200009     /* Daimler */    THEN DO :  /* CGC DO CLIENTE */
            FIND emitente WHERE emitente.cod-emitente EQ tt-param.cliente-ini .
            ASSIGN rc-cgc = "".                    
            DO i-tam = 1 TO LENGTH(emitente.cgc):
                IF LOOKUP(SUBSTRING(emitente.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
                ASSIGN rc-cgc = rc-cgc + SUBSTRING(emitente.cgc,i-tam,1) .
            END .

        END . 

    END.
    ELSE ASSIGN rc-cgc = "59104422005704" .    /* CGC VW PARA DSH, CASO N«O EXISTIR O EMITENTE CADASTRADO */

    ASSIGN  
        c-ger-movto = SUBSTR(STRING(TODAY ,"999999"),5,2) + 
                      SUBSTR(STRING(TODAY ,"999999"),3,2) +
                      SUBSTR(STRING(TODAY ,"999999"),1,2)
        c-ger-movto = c-ger-movto + REPLACE(STRING(TIME,"hh:mm:ss"),":","") .

    ASSIGN i-reg-trans = 1.
        
    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2  /* Considerar apenas Notas Impressas */ */
             NO-LOCK :

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela <> ? THEN NEXT .
        
        /*  Caso o tipo de NF seja diferente de 1 e o parceiro n∆o seja a DAIMLER, o registro deve ser desprezado */
        IF nota-fiscal.ind-tip-nota    NE 1      AND 
           b-emitente.cod-parceiro-edi NE 200008 AND 
           b-emitente.cod-parceiro-edi NE 200009 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao EQ nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .

        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal             AND 
           es-nota-fiscal.aviso-emb EQ YES  AND 
           tt-param.reenvia         EQ NO   THEN NEXT .

        ASSIGN v_log_gerou_mov = TRUE .
        
        FIND FIRST fat-duplic 
             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel AND 
                   fat-duplic.serie       = nota-fiscal.serie       AND 
                   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura 
                   NO-LOCK NO-ERROR .
                   
        IF AVAIL(fat-duplic) THEN 
           ASSIGN c-dt-prvenc = SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),5,2) + 
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),3,2) +
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),1,2).
        ELSE c-dt-prvenc = IF nota-fiscal.dt-prvenc = ? THEN  "000000"
                           ELSE SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),5,2) + 
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),3,2) +
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),1,2) .
        
        ASSIGN i-tot-item-nf   = 0
               de-tot-icms     = 0
               de-tot-icms-sub = 0
               c-dt-emissao    = SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),5,2) + 
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),3,2) +
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),1,2)
               c-dt-saida      = IF nota-fiscal.dt-saida NE ? THEN SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),5,2) + 
                                         SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),3,2) +
                                         SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),1,2)  ELSE  
                                         SUBSTR(STRING(TODAY,"999999"),5,2) + 
                                         SUBSTR(STRING(TODAY,"999999"),3,2) +
                                         SUBSTR(STRING(TODAY,"999999"),1,2) .

        ASSIGN 
            de-peso-cubado = 0 
            de-peso-real   = 0 .

        FOR EACH b-it-nota-fisc OF nota-fiscal NO-LOCK :
            ASSIGN 
               i-tot-item-nf   = i-tot-item-nf + 1
               de-tot-icms     = de-tot-icms +  IF ( b-it-nota-fisc.cd-trib-icm EQ 1 ) THEN b-it-nota-fisc.vl-icms-it ELSE 0 
               de-tot-icms-sub = de-tot-icms-sub + b-it-nota-fisc.vl-icmsub-it.
           
            FIND ITEM    WHERE ITEM.it-codigo    EQ b-it-nota-fisc.it-codigo NO-LOCK NO-ERROR .
            FIND es-item WHERE es-item.it-codigo EQ b-it-nota-fisc.it-codigo NO-LOCK NO-ERROR .
            IF AVAIL es-item  THEN  ASSIGN de-peso-cubado = de-peso-cubado + ( b-it-nota-fisc.qt-faturada[1] * es-item.peso-cubado ) .
            IF AVAIL ITEM     THEN  ASSIGN de-peso-real   = de-peso-real   + ( b-it-nota-fisc.qt-faturada[1] * item.peso-bruto     ) .

        END .
    
        ASSIGN c-planta = "013" .
        IF nota-fiscal.cod-estabel  EQ "002"  THEN  ASSIGN c-planta = "011" .
        IF nota-fiscal.cod-emitente EQ 1      THEN  ASSIGN c-planta = "011" .
        IF nota-fiscal.cod-emitente EQ 2      THEN  ASSIGN c-planta = "013" .
        IF emitente.cod-gr-cli      EQ 2      THEN  ASSIGN c-planta = "DSH" .

        ASSIGN c-serie = nota-fiscal.serie .

        IF AVAIL b-emitente AND 
            ( b-emitente.cod-parceiro-edi EQ 200008 OR 
              b-emitente.cod-parceiro-edi EQ 200009 )  AND 
            c-serie EQ "" THEN ASSIGN c-serie = "U" .

        IF l-first EQ YES  THEN DO:
            OUTPUT STREAM ediant TO VALUE(c-arq-saida-full) PAGE-SIZE  0 .

            PUT STREAM ediant UNFORMATTED
                "ITP"                FORMAT  "x(03)"   AT 01 /* Tipo de Registro */
                "004"                FORMAT  "x(03)"         /* Ident.Transacao  */
                "04"                 FORMAT  "x(02)"         /* Vers∆o Transacao */
                "00000"              FORMAT  "x(05)"         /* Controle Movto   */
                c-ger-movto          FORMAT  "x(12)"         /* Geracao Movto    */
                c-cgc                FORMAT  "x(14)"         /* CGC Transmissor  */
                rc-cgc               FORMAT  "x(14)"         /* CGC Receptor     */
                " "                  FORMAT  "x(08)"
                i-cod-gr-cli         FORMAT  "99"
                " "                  FORMAT  "x(06)"
                empresa.razao-social FORMAT  "x(25)"  AT 70
                FILL(" ",34)         FORMAT  "x(34)"
                /* Skip */ .

            ASSIGN l-first = NO .

        END.

        PUT STREAM ediant UNFORMATTED
            "AE1"                                     FORMAT  "x(03)"       AT 01      /* Tipo de Registro */
            INT(SUBSTR(nota-fiscal.nr-nota-fis,2,6))  FORMAT  "999999"                 /* Nr.Nf Origem */
            c-serie                                   FORMAT  "x(04)"                  /* Serie da Nf */
            c-dt-emissao                              FORMAT  "x(06)"                  /* Emissao */
            i-tot-item-nf                             FORMAT  "999"                    /* Qtde.Itens da Nf */
            INT(nota-fiscal.vl-tot-nota * 100)        FORMAT  "99999999999999999"      /* Valor Tot Nf */
            "0"                                       FORMAT  "x(01)"                  /* Casas Decimais */
            SUBSTR(nota-fiscal.nat-operacao,1,3)      FORMAT  "x(03)"                  /* Cod-Fiscal-Opera */
            INT(de-tot-icms * 100)                    FORMAT  "99999999999999999"      /* Valor Tot ICMS */
            c-dt-prvenc                               FORMAT  "x(06)"                  /* Prim.Vencto */
            "02"                                      FORMAT  "x(02)"                  /* Especie NF */
            INT(nota-fiscal.vl-tot-ipi * 100)         FORMAT  "99999999999999999"      /* Valor do Ipi */
            /* Substr(emitente.home-page,1,3)            Format "x(03)"                  /* Cod.Fabrica */ */
            /* ENTRY(2,emitente.home-page,"#")           FORMAT "x(03)" */
            c-planta                                  FORMAT  "x(3)" 
            c-dt-saida                                FORMAT  "x(06)"                  /* Data Prev. Entrega */
            0                                         FORMAT  "9999"                   /* Ident.Periodo */
            " "                                       FORMAT  "x(20)"                  /* Descr-Nop */
            " "                                       FORMAT  "x(10)"                  /* Filler */
            /* Skip */ .
         
        ASSIGN i-reg-trans = i-reg-trans + 1.     
        
        /* Sen∆o for para montadoras */
        IF emitente.cod-gr-cli <> 1 THEN DO : 
           /*** Dados Complementares da NF ***/
           /*
            01	NF2-DADOS-COMPLEMENT-NF.	*UMA OCORRENCIA POR NOTA FISCAL	
                05   NF2-TIPO-REGISTRO	PIC X(03).	"NF2"
                05   NF2-DESP-ACESSORIAS	PIC 9(15)V99.	ZEROS
                05   NF2-VALOR-FRETE	PIC 9(15)V99.	VALOR TOTAL DO FRETE
                05   NF2-VALOR-SEGURO	PIC 9(15)V99.	VALOR TOTAL DO SEGURO
                05   NF2-VALOR-DESCONTO	PIC 9(15)V99.	VALOR TOTAL DO DESCONTO
                05   NF2-VALOR-TOTAL-ICMSS	PIC 9(15)V99.	VALOR TOTAL DO ICMSS
                05   NF2-FILLER	PIC X(40).	ESPAÄOS
            01	NF4-DADOS-COMPLEMENT-FRETE-NF.	*UMA OCORRENCIA POR NOTA FISCAL	
                05  NF4-TIPO-REGISTRO	PIC X(03).	"NF4"
                05  NF4-NUMERO-LOTE	PIC 9(03).	NUMERO SEQUENCIAL DIµRIO DO FORNECEDOR
                05  NF4-DATA-LOTE	PIC X(12).	DDMMAAAAHHMM
                05  NF4-COD-TRANPORTADORA	PIC X(06).	
                05  NF4-TIPO-PEDIDO	PIC X(02).	"CV" OU "CP"
                05  NF4-TIPO-FRETE	PIC X(01).	"F" OU "G"
                05  NF4-TIPO-EQUIPAMENTO	PIC X(02).	OBRIGAT‡RIO PARA TIPO DE FRETE = G
                05  NF4-IDENT-CARGA-EXCEDENTE	PIC X(01).	OBRIGAT‡RIO PARA TIPO DE FRETE = G
                05  NF4-PLACA-CAMINHAO	PIC X(07).	OBRIGAT‡RIO PARA TIPO DE FRETE = G
                05  NF4-IDENT-PARACHOQUE	PIC X(01).	"S" OU "N"
                05  NF4-TIPO-TRANSPORTE	PIC X(01).	
                05  NF4-PESO-REAL	PIC 9(07)V999	
                05  NF4-PESO-CUBADO	PIC 9(07)V999	
           */

           PUT STREAM ediant UNFORMATTED
               "NF2"                              AT 01                         /* Tipo de Registro */
               0                                  FORMAT  "99999999999999999"    /* Despesas Acessoria */
               INT(nota-fiscal.vl-frete * 100)    FORMAT  "99999999999999999"    /* Valor do Frete */
               INT(nota-fiscal.vl-seguro * 100)   FORMAT  "99999999999999999"    /* Valor do Seguro */
               INT(nota-fiscal.vl-desconto * 100) FORMAT  "99999999999999999"    /* Valor do Desconto */ 
               INT(de-tot-icms-sub * 100)         FORMAT  "99999999999999999"    /* Valor do ICMSS */
               " "                                FORMAT  "x(40)"                /* Filler */
               /* Skip */ .
           ASSIGN i-reg-trans = i-reg-trans + 1 .     


           ASSIGN c-data-hora-ger = SUBSTRING( STRING( YEAR (TODAY), "9999" ) , 3 , 2 ) +
                                    STRING( MONTH(TODAY), "99" ) +
                                    STRING( DAY  (TODAY), "99" ) +
                                    REPLACE ( STRING( TIME, "HH:MM:SS" ) , ":" , "" ) . /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */

           PUT STREAM ediant UNFORMATTED
               "NF4"                              AT 01                         /* Tipo de Registro */
               DAY(TODAY)                         FORMAT  "999"                 /* Numero Sequencial do Fornecedor */
               c-data-hora-ger                    FORMAT  "X(12)"               /* Data do Lote */
               nota-fiscal.nome-tr-red            FORMAT  "X(6)"                /* Nome Reduzido da Transportadora */
               "CV"                               FORMAT  "X(2)"                /* "CV" OU "CP" */
               "F"                                FORMAT  "X(1)"                /* "F" OU "G" */
               "  "                               FORMAT  "X(2)"                /* OBRIGAT‡RIO PARA TIPO DE FRETE = G */
               " "                                FORMAT  "X(1)"                /* OBRIGAT‡RIO PARA TIPO DE FRETE = G  */
               "       "                          FORMAT  "X(7)"                /* OBRIGAT‡RIO PARA TIPO DE FRETE = G */
               "N"                                FORMAT  "X(1)"                /* "S" OU "N" */
               " "                                FORMAT  "X(1)"                /* Tipo de Tranporte */
               ( de-peso-real * 1000 )            FORMAT  "9999999999"          /* Peso Real = Peso Bruto do Item */
               ( de-peso-cubado * 1000 )          FORMAT  "9999999999"          /* Peso Cubado do Item */
               /* Skip */ .
           ASSIGN i-reg-trans = i-reg-trans + 1 .     

        END .     
        
        ASSIGN wi = 10 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK BY it-nota-fisc.it-codigo  :

            FIND ITEM WHERE item.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .

            /*  Caso seja a VW, sera reconstruida a codificaá∆o do Item */
            IF  emitente.cod-parceiro-edi EQ 200005 THEN DO : 

                ASSIGN 
                    c-mod = ""
                    c-cod = ""
                    c-cor = "" .

                IF LENGTH(c-it-codigo) GT 11 THEN DO:
                    ASSIGN 
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , IF (LENGTH (c-it-codigo) - 6) GT 0 THEN (LENGTH (c-it-codigo) - 6) ELSE 0  ) 
                        c-cod = c-cod + FILL( " " , 8 - LENGTH( TRIM(c-cod) ) )
                        c-cor = SUBSTRING(c-it-codigo , IF (LENGTH (c-it-codigo) - 2) GT 1 THEN (LENGTH (c-it-codigo) - 2) ELSE 1 , 3 )  .
                END.
                ELSE DO:
                    ASSIGN
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , LENGTH(c-it-codigo ) ) .
                END.

                ASSIGN 
                    c-it-codigo = c-mod + c-cod + c-cor .

            END.

            /*  Caso seja a DAIMLER, sera reconstruida a codificaá∆o do Item */
            IF  emitente.cod-parceiro-edi EQ 200008 OR 
                emitente.cod-parceiro-edi EQ 200009 THEN DO : 

                IF LENGTH(c-it-codigo) EQ 15 THEN  DO :

                    ASSIGN 
                        c-mod = ""
                        c-cod = ""
                        c-cor = "" .

                    ASSIGN c-mod = TRIM(c-it-codigo) .

                    ASSIGN c-it-codigo = SUBSTRING( c-mod , 1 , LENGTH(c-mod) - 4 ) + 
                                         FILL(" " , 6 )  + 
                                         SUBSTRING( c-mod , LENGTH(c-mod) - 3 , 4 ) .


                END.

            END.


            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .
            
            FIND ped-item
                 WHERE ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli AND 
                       ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli   AND 
                       ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped  AND 
                       ped-item.it-codigo    = it-nota-fisc.it-codigo   AND 
                       ped-item.cod-refer    = it-nota-fisc.cod-refer   NO-LOCK NO-ERROR .
            
            /*
            FIND es-detalhe-ped   
                 WHERE es-detalhe-ped.nome-abrev   = nota-fiscal.nome-ab-cli AND 
                       es-detalhe-ped.nr-pedcli    = it-nota-fisc.nr-pedcli  AND 
                       es-detalhe-ped.nr-sequencia = it-nota-fisc.nr-seq-ped AND 
                       es-detalhe-ped.it-codigo    = it-nota-fisc.it-codigo  AND 
                       es-detalhe-ped.cod-refer    = it-nota-fisc.cod-refer  NO-LOCK NO-ERROR .
                       
            IF NOT AVAIL(es-detalhe-ped) THEN 
                FIND  es-detalhe-ped WHERE  es-detalhe-ped.nome-abrev   = nota-fiscal.nome-ab-cli + "-DN" AND 
                                            es-detalhe-ped.nr-pedcli    = it-nota-fisc.nr-pedcli  AND 
                                            es-detalhe-ped.nr-sequencia = it-nota-fisc.nr-seq-ped AND 
                                            es-detalhe-ped.it-codigo    = it-nota-fisc.it-codigo  AND 
                                            es-detalhe-ped.cod-refer    = it-nota-fisc.cod-refer  NO-LOCK  NO-ERROR .
            */                                            
            
            ASSIGN c-ped-lin-vw-ford = "" .
            IF AVAIL ped-item THEN ASSIGN c-ped-lin-vw-ford = REPLACE (ped-item.nr-pedcli , "." , "" ) .

            ASSIGN 
                c-sit-trib = TRIM(STRING(ITEM.codigo-orig)) + TRIM(STRING(it-nota-fisc.cd-trib-icm)) .

            /*** Dados do Item ***/

            ASSIGN wj = wi .
            IF b-emitente.cod-parceiro-edi EQ 200008 OR   /* Daimler MG ou Daimler SBC */
               b-emitente.cod-parceiro-edi EQ 200009 THEN ASSIGN wj = wj / 10 .

            PUT STREAM ediant UNFORMATTED
                "AE2"                               FORMAT  "x(03)"  AT 01 
                wj                                  FORMAT  "999"                 /* Numero do Item na NF */
                c-ped-lin-vw-ford                        FORMAT  "x(12)"               /* Nr.Ped.Vw + Linha Ped.VW */
                c-it-codigo                         FORMAT  "x(30)"               /* Cod.do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                it-nota-fisc.class-fiscal           FORMAT  "0099999999"          /* Classificao Fiscal */
                (IF it-nota-fisc.vl-ipi-it = 0 THEN  0 ELSE INT(it-nota-fisc.aliquota-ipi * 100)) FORMAT "9999"                /* Aliquota de Ipi */
                INT(it-nota-fisc.vl-preuni * 100)   FORMAT  "99999999999999999"   /* Valor Liquido do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                0                                   FORMAT  "999999999"
                " "                                 FORMAT  "x(02)"
                " "                                 FORMAT  "x(01)"
                0                                   FORMAT  "9999"
                INT(it-nota-fisc.vl-desconto * 100) FORMAT  "99999999999"         /* Vl.Desconto do Item */
                /* Skip */ .

            ASSIGN 
                i-reg-trans = i-reg-trans + 1
                wi          = wi + 10 .
            
            /*** Complemento do Item da NF ***/
            PUT STREAM ediant UNFORMATTED
                "AE4"                                   FORMAT "x(03)"   AT 01      /* Tipo de Registro */
                ( IF it-nota-fisc.vl-icms-it = 0 THEN    0 ELSE  INT(it-nota-fisc.aliquota-icm * 100)) FORMAT "9999"               /* Aliquota Icms */
                it-nota-fisc.vl-bicms-it * 100           FORMAT "99999999999999999"  /* Base Calc ICMS */
                INT(it-nota-fisc.vl-icms-it * 100)       FORMAT "99999999999999999"  /* Valor Icms Item */
                INT(it-nota-fisc.vl-ipi-it * 100)        FORMAT "99999999999999999"  /* Valor Ipi Item */
                c-sit-trib                               FORMAT "x(02)"              /* Cod.Situacao Trib */
                " "                                      FORMAT "x(30)"              /* Espacos */
                0                                        FORMAT "999999"            
                " "                                      FORMAT "x(02)"            
                " "                                      FORMAT "x(30)"    
                /* Skip */ .

            ASSIGN i-reg-trans = i-reg-trans + 1.

        END .      
        
        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .
        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .

    END .
    
    ASSIGN i-reg-trans = i-reg-trans + 1.

    IF l-first EQ NO  THEN  DO:

        /** TRAILLER ***/
        PUT STREAM ediant UNFORMATTED
          "FTP"         FORMAT "x(03)"      AT 01
          "00000"       FORMAT "x(05)"
          i-reg-trans   FORMAT "999999999"
          " "           FORMAT "x(111)"
          /* Skip */ .

        OUTPUT STREAM ediant CLOSE .

        /*
        /* Enviar se Lear */
        IF emitente.cod-parceiro EQ 200007  THEN  DO:
            RUN pi-emviaftp-ford-lear .     
        END.
        */

        /* Atualizar a sequencia de mensagens */ 
        NEXT-VALUE(msgid) .

    END.

    RETURN.

END PROCEDURE .



PROCEDURE pi-gera-dados-rnd-ford  .

    /*  CGC DO ESTABELECIMENTO DA PELZER */
    ASSIGN c-cgc = "" .
    DO i-tam = 1 TO LENGTH(estabelec.cgc):
       IF LOOKUP(SUBSTRING(estabelec.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
          ASSIGN c-cgc = c-cgc + SUBSTRING(estabelec.cgc,i-tam,1) .
    END .

    /* CGC DO CLIENTE DA NOTA FISCAL */
    IF AVAIL b-emitente THEN DO : 
        ASSIGN rc-cgc = "59104422005704" .    /* Seta CGC Padr∆o da VW para o parceiro 200.005 */
        IF b-emitente.cod-parceiro-edi EQ 200002 THEN ASSIGN rc-cgc = "03470727000120" .  /*  FORD */ 
    END.
    ELSE ASSIGN rc-cgc = "59104422005704" .    /* CGC VW PARA DSH, CASO N«O EXISTIR O EMITENTE CADASTRADO */

    ASSIGN  
        c-ger-movto = SUBSTR(STRING(TODAY ,"999999"),5,2) + 
                      SUBSTR(STRING(TODAY ,"999999"),3,2) +
                      SUBSTR(STRING(TODAY ,"999999"),1,2)
        c-ger-movto = c-ger-movto + REPLACE(STRING(TIME,"hh:mm:ss"),":","") .

    ASSIGN i-reg-trans = 1.
        
    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK :

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela <> ? THEN NEXT .
        
        IF nota-fiscal.ind-tip-nota <> 1 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .
        
        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal             AND 
           es-nota-fiscal.aviso-emb EQ YES  AND 
           tt-param.reenvia         EQ NO   THEN NEXT .


        FIND es-deljit WHERE  es-deljit.cod-estabel EQ nota-fiscal.cod-estabel
                       AND    es-deljit.serie       EQ nota-fiscal.serie
                       AND    es-deljit.nr-nota-fis EQ nota-fiscal.nr-nota-fis NO-ERROR .

        IF NOT AVAILABLE es-deljit     THEN NEXT . 
        IF es-deljit.l-verificou EQ NO THEN  NEXT .

        ASSIGN v_log_gerou_mov = TRUE .
        
        FIND FIRST fat-duplic 
             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel AND 
                   fat-duplic.serie       = nota-fiscal.serie       AND 
                   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura 
                   NO-LOCK NO-ERROR .
                   
        IF AVAIL(fat-duplic) THEN 
           ASSIGN c-dt-prvenc = SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),5,2) + 
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),3,2) +
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),1,2).
        ELSE c-dt-prvenc = IF nota-fiscal.dt-prvenc = ? THEN  "000000"
                           ELSE SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),5,2) + 
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),3,2) +
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),1,2) .
        
        ASSIGN i-tot-item-nf   = 0
               de-tot-icms     = 0
               de-tot-icms-sub = 0
               c-dt-emissao    = SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),5,2) + 
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),3,2) +
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),1,2)
               c-dt-saida      = c-dt-emissao  .

        FOR EACH b-it-nota-fisc OF nota-fiscal NO-LOCK :
            ASSIGN 
               i-tot-item-nf   = i-tot-item-nf + 1
               de-tot-icms     = de-tot-icms +  IF ( b-it-nota-fisc.cd-trib-icm EQ 1 ) THEN b-it-nota-fisc.vl-icms-it ELSE 0 
               de-tot-icms-sub = de-tot-icms-sub + b-it-nota-fisc.vl-icmsub-it.
        END .
    
        ASSIGN c-planta = es-deljit.cod-planta .

        ASSIGN c-serie = nota-fiscal.serie .

        IF AVAIL b-emitente AND 
            ( b-emitente.cod-parceiro-edi EQ 200008 OR 
              b-emitente.cod-parceiro-edi EQ 200009 )  AND 
            c-serie EQ "" THEN ASSIGN c-serie = "U" .

        IF l-first EQ YES  THEN DO:
            OUTPUT STREAM ediant TO VALUE(c-arq-saida-full) PAGE-SIZE  0 .

            PUT STREAM ediant UNFORMATTED
                "ITP"                FORMAT  "x(03)"   AT 01 /* Tipo de Registro */
                "004"                FORMAT  "x(03)"         /* Ident.Transacao  */
                "06"                 FORMAT  "x(02)"         /* Vers∆o Transacao */
                "00000"              FORMAT  "x(05)"         /* Controle Movto   */
                c-ger-movto          FORMAT  "x(12)"         /* Geracao Movto    */
                c-cgc                FORMAT  "x(14)"         /* CGC Transmissor  */
                rc-cgc               FORMAT  "x(14)"         /* CGC Receptor     */
                " "                  FORMAT  "x(08)"
                i-cod-gr-cli         FORMAT  "99"
                " "                  FORMAT  "x(06)"
                empresa.razao-social FORMAT  "x(25)"  AT 70
                FILL(" ",34)         FORMAT  "x(34)"
                /* Skip */ .

            ASSIGN l-first = NO .

        END.
        
        PUT STREAM ediant UNFORMATTED
            "AE1"                                     FORMAT  "x(03)"       AT 01      /* Tipo de Registro */
            INT(SUBSTR(nota-fiscal.nr-nota-fis,2,6))  FORMAT  "999999"                 /* Nr.Nf Origem */
            c-serie                                   FORMAT  "x(04)"                  /* Serie da Nf */
            c-dt-emissao                              FORMAT  "x(06)"                  /* Emissao */
            i-tot-item-nf                             FORMAT  "999"                    /* Qtde.Itens da Nf */
            INT(nota-fiscal.vl-tot-nota * 100)        FORMAT  "99999999999999999"      /* Valor Tot Nf */
            "0"                                       FORMAT  "x(01)"                  /* Casas Decimais */
            SUBSTR(nota-fiscal.nat-operacao,1,3)      FORMAT  "x(03)"                  /* Cod-Fiscal-Opera */
            INT(de-tot-icms * 100)                    FORMAT  "99999999999999999"      /* Valor Tot ICMS */
            c-dt-prvenc                               FORMAT  "x(06)"                  /* Prim.Vencto */
            "00"                                      FORMAT  "x(02)"                  /* Especie NF */
            INT(nota-fiscal.vl-tot-ipi * 100)         FORMAT  "99999999999999999"      /* Valor do Ipi */
            /* Substr(emitente.home-page,1,3)            Format "x(03)"                  /* Cod.Fabrica */ */
            /* ENTRY(2,emitente.home-page,"#")           FORMAT "x(03)" */
            c-planta                                  FORMAT  "x(3)" 
            c-dt-saida                                FORMAT  "x(06)"                  /* Data Prev. Entrega */
            " "                                       FORMAT  "x(04)"                   /* Ident.Periodo */
            " "                                       FORMAT  "x(20)"                  /* Descr-Nop */
            " "                                       FORMAT  "x(10)"                  /* Filler */
            /* Skip */ .
         
        ASSIGN i-reg-trans = i-reg-trans + 1.     
        
        /* Sen∆o for para montadoras */
        IF emitente.cod-gr-cli <> 1 THEN DO : 
           /*** Dados Complementares da NF ***/
            PUT STREAM ediant UNFORMATTED
                "NF2"                              AT 01                         /* Tipo de Registro */
                0                                  FORMAT  "99999999999999999"    /* Despesas Acessoria */
                INT(nota-fiscal.vl-frete * 100)    FORMAT  "99999999999999999"    /* Valor do Frete */
                INT(nota-fiscal.vl-seguro * 100)   FORMAT  "99999999999999999"    /* Valor do Seguro */
                INT(nota-fiscal.vl-desconto * 100) FORMAT  "99999999999999999"    /* Valor do Desconto */ 
                INT(de-tot-icms-sub * 100)         FORMAT  "99999999999999999"    /* Valor do ICMSS */
                " "                                FORMAT  "x(40)"                /* Filler */
                /* Skip */ .
            ASSIGN i-reg-trans = i-reg-trans + 1 .     
        END .     
        
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK :

            FIND ITEM WHERE item.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .


            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .
            
            FIND ped-item
                 WHERE ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli AND 
                       ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli   AND 
                       ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped  AND 
                       ped-item.it-codigo    = it-nota-fisc.it-codigo   AND 
                       ped-item.cod-refer    = it-nota-fisc.cod-refer   NO-LOCK NO-ERROR .
            
            IF AVAIL ped-item THEN ASSIGN c-ped-lin-vw-ford = REPLACE (ped-item.nr-pedcli , "." , "" ) .
            ELSE ASSIGN c-ped-lin-vw-ford = it-nota-fisc.nr-pedcli .


            /* Rotina para a verificaá∆o do n£mero dos pedidos de CKD */
            IF estabelec.cod-estabel EQ "401"  OR
               estabelec.cod-estabel EQ "402"  THEN DO:

                FIND ped-item OF ped-venda NO-LOCK NO-ERROR .
                FIND es-ped-venda OF ped-venda  NO-LOCK NO-ERROR .

                IF AVAIL es-ped-venda  AND es-ped-venda.cod-operacao EQ "CKD" THEN  DO:
                    FIND FIRST es-progent USE-INDEX ch-item 
                                          WHERE es-progent.ep-codigo   EQ estabelec.ep-codigo 
                                          AND   es-progent.cod-estabel EQ estabelec.cod-estabel
                                          AND   es-progent.it-codigo   EQ it-nota-fisc.it-codigo
                                          AND   es-progent.dt-entrega  LE nota-fiscal.dt-emis 
                                          AND   es-progent.tipo-fornec NE "P" 
                                          NO-LOCK NO-ERROR .
                    IF AVAIL es-progent THEN DO:
                        /* es-progent.nr-pedcli contem a numeracao completa do pedido e a variavel c-ped-lin-vw-ford contem apenas o inicio da numeracao */
                        IF TRIM(es-progent.nr-pedcli) BEGINS c-ped-lin-vw-ford THEN DO:
                            ASSIGN c-ped-lin-vw-ford = TRIM(es-progent.nr-pedcli) .
                        END.
                    END.

                END.

            END.

                 
            ASSIGN 
                c-sit-trib = TRIM(STRING(ITEM.codigo-orig)) + TRIM(STRING(it-nota-fisc.cd-trib-icm)) .

            ASSIGN c-sis-emissor = "P" .
            IF c-planta EQ "050" OR
               c-planta EQ "50"  THEN ASSIGN c-sis-emissor = "E" .

            /*** Dados do Item ***/
            PUT STREAM ediant UNFORMATTED
                "AE2"                               FORMAT  "x(03)"  AT 01 
                it-nota-fisc.nr-seq-fat              FORMAT  "999"                 /* Numero do Item na NF */
                c-ped-lin-vw-ford                   FORMAT  "x(12)"               /* Nr.Ped.Vw + Linha Ped.VW */
                c-it-codigo                         FORMAT  "x(30)"               /* Cod.do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                it-nota-fisc.class-fiscal           FORMAT  "0099999999"          /* Classificao Fiscal */
                (IF it-nota-fisc.vl-ipi-it = 0 THEN  0 ELSE INT(it-nota-fisc.aliquota-ipi * 100)) FORMAT "9999"                /* Aliquota de Ipi */
                INT(it-nota-fisc.vl-preuni * 100)   FORMAT  "999999999"   /* Valor Liquido do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                0                                   FORMAT  "999999999"
                " "                                 FORMAT  "x(02)"
                /*"P"                                 FORMAT  "x(01)" */
                c-sis-emissor                       FORMAT "x(01)" 
                0                                   FORMAT  "9999"
                INT(it-nota-fisc.vl-desconto * 100) FORMAT  "99999999999"         /* Vl.Desconto do Item */
                FILL(" " , 5)                       FORMAT  "x(5)" 
                /* Skip */ .

            ASSIGN 
                i-reg-trans = i-reg-trans + 1 .
            
            /*** Complemento do Item da NF ***/
            PUT STREAM ediant UNFORMATTED
                "AE4"                                   FORMAT "x(03)"   AT 01      /* Tipo de Registro */
                ( IF it-nota-fisc.vl-icms-it = 0 THEN    0 ELSE  INT(it-nota-fisc.aliquota-icm * 100)) FORMAT "9999"               /* Aliquota Icms */
                it-nota-fisc.vl-bicms-it * 100           FORMAT "99999999999999999"  /* Base Calc ICMS */
                INT(it-nota-fisc.vl-icms-it * 100)       FORMAT "99999999999999999"  /* Valor Icms Item */
                INT(it-nota-fisc.vl-ipi-it * 100)        FORMAT "99999999999999999"  /* Valor Ipi Item */
                c-sit-trib                               FORMAT "x(02)"              /* Cod.Situacao Trib */
                " "                                      FORMAT "x(30)"              /* Espacos */
                0                                        FORMAT "999999"            
                " "                                      FORMAT "x(19)"            
                INT(it-nota-fisc.vl-tot-item * 100 )     FORMAT "999999999999"    
                " "                                      FORMAT "x(1)"
                /* Skip */ .

            ASSIGN i-reg-trans = i-reg-trans + 1.

        END .      
        
        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .


        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .

        ASSIGN
            es-deljit.l-atualizado   = YES .

    END .
    
    ASSIGN i-reg-trans = i-reg-trans + 1.

    IF l-first EQ NO  THEN  DO:
        /** TRAILLER ***/
        PUT STREAM ediant UNFORMATTED
          "FTP"         FORMAT "x(03)"      AT 01
          "00000"       FORMAT "x(05)"
          i-reg-trans   FORMAT "999999999"
          " "           FORMAT "x(111)"
          /* Skip */ .

        OUTPUT STREAM ediant CLOSE .

        /*
        /* Enviar se for da Ford */
        IF emitente.cod-parceiro EQ 200002  THEN  DO:
            RUN pi-emviaftp-ford-lear .     
        END.
        */

        /* Atualizar a sequencia de mensagens */ 
        NEXT-VALUE(msgid) .

    END.

    RETURN.

END PROCEDURE .



/*
PROCEDURE pi-gera-dados-rnd-lear .

    /*  CGC DO ESTABELECIMENTO DA PELZER */
    ASSIGN c-cgc = "" .
    DO i-tam = 1 TO LENGTH(estabelec.cgc):
       IF LOOKUP(SUBSTRING(estabelec.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
          ASSIGN c-cgc = c-cgc + SUBSTRING(estabelec.cgc,i-tam,1) .
    END .

    /* CGC DO CLIENTE DA NOTA FISCAL */
    IF AVAIL b-emitente THEN DO : 

        ASSIGN rc-cgc = "59104422005704" .    /* Seta CGC Padr∆o da VW para o parceiro 200.005 */

        IF b-emitente.cod-parceiro-edi EQ 200002 THEN ASSIGN rc-cgc = "03470727000120" .  /*  FORD */ 

        IF b-emitente.cod-parceiro-edi EQ 200004 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200006 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200007 OR  /* Lear    */
           b-emitente.cod-parceiro-edi EQ 200008 OR  /* Daimler */
           b-emitente.cod-parceiro-edi EQ 200009     /* Daimler */    THEN DO :  /* CGC DO CLIENTE */
            FIND emitente WHERE emitente.cod-emitente EQ tt-param.cliente-ini .
            ASSIGN rc-cgc = "".                    
            DO i-tam = 1 TO LENGTH(emitente.cgc):
                IF LOOKUP(SUBSTRING(emitente.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
                ASSIGN rc-cgc = rc-cgc + SUBSTRING(emitente.cgc,i-tam,1) .
            END .

        END . 

    END.
    ELSE ASSIGN rc-cgc = "59104422005704" .    /* CGC VW PARA DSH, CASO N«O EXISTIR O EMITENTE CADASTRADO */

    ASSIGN  
        c-ger-movto = SUBSTR(STRING(TODAY ,"999999"),5,2) + 
                      SUBSTR(STRING(TODAY ,"999999"),3,2) +
                      SUBSTR(STRING(TODAY ,"999999"),1,2)
        c-ger-movto = c-ger-movto + REPLACE(STRING(TIME,"hh:mm:ss"),":","") .

    ASSIGN i-reg-trans = 1.
        
    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */
             NO-LOCK :

        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela <> ? THEN NEXT .
        
        /*  Caso o tipo de NF seja diferente de 1 e o parceiro n∆o seja a LEAR, o registro deve ser desprezado */
        IF nota-fiscal.ind-tip-nota    NE 1      AND 
           b-emitente.cod-parceiro-edi NE 200007 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao EQ nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .

        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal             AND 
           es-nota-fiscal.aviso-emb EQ YES  AND 
           tt-param.reenvia         EQ NO   THEN NEXT .

        ASSIGN v_log_gerou_mov = TRUE .
        
        FIND FIRST fat-duplic 
             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel AND 
                   fat-duplic.serie       = nota-fiscal.serie       AND 
                   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura 
                   NO-LOCK NO-ERROR .
                   
        IF AVAIL(fat-duplic) THEN 
           ASSIGN c-dt-prvenc = SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),5,2) + 
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),3,2) +
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),1,2) .
        ELSE c-dt-prvenc = IF nota-fiscal.dt-prvenc = ? THEN  "000000"
                           ELSE SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),5,2) + 
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),3,2) +
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),1,2) .
        
        ASSIGN i-tot-item-nf   = 0
               de-tot-icms     = 0
               de-tot-icms-sub = 0
               c-dt-emissao    = SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),5,2) + 
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),3,2) +
                                 SUBSTR(STRING(nota-fiscal.dt-emis-nota,"999999"),1,2)
               c-dt-saida      = IF nota-fiscal.dt-saida NE ? THEN SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),5,2) + 
                                         SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),3,2) +
                                         SUBSTR(STRING(nota-fiscal.dt-saida,"999999"),1,2)  ELSE  
                                         SUBSTR(STRING(TODAY,"999999"),5,2) + 
                                         SUBSTR(STRING(TODAY,"999999"),3,2) +
                                         SUBSTR(STRING(TODAY,"999999"),1,2) .

        FOR EACH b-it-nota-fis OF nota-fiscal NO-LOCK :
            ASSIGN 
               i-tot-item-nf   = i-tot-item-nf + 1
               de-tot-icms     = de-tot-icms +  IF ( b-it-nota-fisc.cd-trib-icm EQ 1 ) THEN b-it-nota-fisc.vl-icms-it ELSE 0 
               de-tot-icms-sub = de-tot-icms-sub + b-it-nota-fisc.vl-icmsub-it.
        END .
    
        ASSIGN c-planta = "001" .
        IF emitente.cod-gr-cli     EQ 2      THEN  ASSIGN c-planta = "DSC" .

        ASSIGN c-serie = nota-fiscal.serie .

        IF AVAIL b-emitente AND 
            ( b-emitente.cod-parceiro-edi EQ 200008 OR 
              b-emitente.cod-parceiro-edi EQ 200009 )  AND 
            c-serie EQ "" THEN ASSIGN c-serie = "U" .

        IF l-first EQ YES  THEN DO:
            OUTPUT TO VALUE(c-arq-saida-full) PAGE-SIZE  0 .
            PUT UNFORMATTED
                "ITP"                FORMAT  "x(03)"   AT 01 /* Tipo de Registro */
                "004"                FORMAT  "x(03)"         /* Ident.Transacao  */
                "08"                 FORMAT  "x(02)"         /* Vers∆o Transacao */
                "00000"              FORMAT  "x(05)"         /* Controle Movto   */
                c-ger-movto          FORMAT  "x(12)"         /* Geracao Movto    */
                c-cgc                FORMAT  "x(14)"         /* CGC Transmissor  */
                rc-cgc               FORMAT  "x(14)"         /* CGC Receptor     */
                "25"                 FORMAT  "x(08)"
                i-cod-gr-cli         FORMAT  "99"
                " "                  FORMAT  "x(06)"
                empresa.razao-social FORMAT  "x(25)"  AT 70
                FILL(" ",34)         FORMAT  "x(34)"
                /* Skip */ .

            ASSIGN l-first = NO .

        END.

        
        PUT UNFORMATTED
            "AE1"                                     FORMAT  "x(03)"       AT 01      /* Tipo de Registro */
            INT(SUBSTR(nota-fiscal.nr-nota-fis,2,6))  FORMAT  "999999"                 /* Nr.Nf Origem */
            c-serie                                   FORMAT  "x(04)"                  /* Serie da Nf */
            c-dt-emissao                              FORMAT  "x(06)"                  /* Emissao */
            i-tot-item-nf                             FORMAT  "999"                    /* Qtde.Itens da Nf */
            INT(nota-fiscal.vl-tot-nota * 100 )       FORMAT  "99999999999999999"      /* Valor Tot Nf */
            "0"                                       FORMAT  "x(01)"                  /* Casas Decimais */
            SUBSTR(nota-fiscal.nat-operacao,1,3)      FORMAT  "x(03)"                  /* Cod-Fiscal-Opera */
            INT(de-tot-icms * 100)                    FORMAT  "99999999999999999"      /* Valor Tot ICMS */
            c-dt-prvenc                               FORMAT  "x(06)"                  /* Prim.Vencto */
            "02"                                      FORMAT  "x(02)"                  /* Especie NF */
            INT(nota-fiscal.vl-tot-ipi * 100)         FORMAT  "99999999999999999"      /* Valor do Ipi */
            c-planta                                  FORMAT  "x(3)" 
            c-dt-saida                                FORMAT  "x(06)"                  /* Data Prev. Entrega */
            " "                                       FORMAT  "x(04)"                   /* Ident.Periodo */
            CAPS(fn-free-accent( natur-oper.denom ) ) FORMAT  "x(20)"                  /* Descr-Nop */
            " "                                       FORMAT  "x(10)"                  /* Filler */
            /* Skip */ .
         
        ASSIGN i-reg-trans = i-reg-trans + 1.     
        
        /* Sen∆o for para montadoras */
        IF emitente.cod-gr-cli <> 1 THEN DO : 
           /*** Dados Complementares da NF ***/
           PUT UNFORMATTED 
               "NF2"                              FORMAT  "x(03)"       AT 01    /* Tipo de Registro */
               0                                  FORMAT  "99999999999999999"    /* Despesas Acessoria */
               INT(nota-fiscal.vl-frete * 100)    FORMAT  "99999999999999999"    /* Valor do Frete */
               INT(nota-fiscal.vl-seguro * 100)   FORMAT  "99999999999999999"    /* Valor do Seguro */
               INT(nota-fiscal.vl-desconto * 100) FORMAT  "99999999999999999"    /* Valor do Desconto */ 
               INT(de-tot-icms-sub * 100)         FORMAT  "99999999999999999"    /* Valor do ICMSS */
               " "                                FORMAT  "x(40)"                /* Filler */
               /* Skip */ .
           ASSIGN i-reg-trans = i-reg-trans + 1 .     
        END .     
        
        ASSIGN wi = 10 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK  :

            FIND ITEM WHERE item.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .

            /*  Caso seja a VW, sera reconstruida a codificaá∆o do Item */
            IF  emitente.cod-parceiro-edi EQ 200005 THEN DO : 

                ASSIGN 
                    c-mod = ""
                    c-cod = ""
                    c-cor = "" .

                IF LENGTH(c-it-codigo) GT 11 THEN DO:
                    ASSIGN 
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , IF (LENGTH (c-it-codigo) - 6) GT 0 THEN (LENGTH (c-it-codigo) - 6) ELSE 0  ) 
                        c-cod = c-cod + FILL( " " , 8 - LENGTH( TRIM(c-cod) ) )
                        c-cor = SUBSTRING(c-it-codigo , IF (LENGTH (c-it-codigo) - 2) GT 1 THEN (LENGTH (c-it-codigo) - 2) ELSE 1 , 3 )  .
                END.
                ELSE DO:
                    ASSIGN
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , LENGTH(c-it-codigo ) ) .
                END.

                ASSIGN 
                    c-it-codigo = c-mod + c-cod + c-cor .

            END.

            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .
            
            FIND ped-item
                 WHERE ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli AND 
                       ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli   AND 
                       ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped  AND 
                       ped-item.it-codigo    = it-nota-fisc.it-codigo   AND 
                       ped-item.cod-refer    = it-nota-fisc.cod-refer   NO-LOCK NO-ERROR .
            
            /*
            FIND es-detalhe-ped   
                 WHERE es-detalhe-ped.nome-abrev   = nota-fiscal.nome-ab-cli AND 
                       es-detalhe-ped.nr-pedcli    = it-nota-fisc.nr-pedcli  AND 
                       es-detalhe-ped.nr-sequencia = it-nota-fisc.nr-seq-ped AND 
                       es-detalhe-ped.it-codigo    = it-nota-fisc.it-codigo  AND 
                       es-detalhe-ped.cod-refer    = it-nota-fisc.cod-refer  NO-LOCK NO-ERROR .
                       
            IF NOT AVAIL(es-detalhe-ped) THEN 
                FIND  es-detalhe-ped WHERE  es-detalhe-ped.nome-abrev   = nota-fiscal.nome-ab-cli + "-DN" AND 
                                            es-detalhe-ped.nr-pedcli    = it-nota-fisc.nr-pedcli  AND 
                                            es-detalhe-ped.nr-sequencia = it-nota-fisc.nr-seq-ped AND 
                                            es-detalhe-ped.it-codigo    = it-nota-fisc.it-codigo  AND 
                                            es-detalhe-ped.cod-refer    = it-nota-fisc.cod-refer  NO-LOCK  NO-ERROR .
            */                                            
            
            ASSIGN c-ped-lin-vw-ford = "" .
            IF AVAIL ped-item THEN ASSIGN c-ped-lin-vw-ford = ped-item.nr-pedcli .
                 
            ASSIGN 
                c-sit-trib = TRIM(STRING(ITEM.codigo-orig)) + TRIM(STRING(it-nota-fisc.cd-trib-icm)) .

            /*** Dados do Item ***/
            PUT UNFORMATTED
                "AE2"                               FORMAT  "x(03)"  AT 01 
                wi                                  FORMAT  "999"                 /* Numero do Item na NF */
                c-ped-lin-vw-ford                   FORMAT  "x(12)"               /* Nr.Ped.Vw + Linha Ped.VW */
                c-it-codigo                         FORMAT  "x(30)"               /* Cod.do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                it-nota-fisc.class-fiscal           FORMAT  "0099999999"          /* Classificao Fiscal */
                (IF it-nota-fisc.vl-ipi-it = 0 THEN  0 ELSE INT(it-nota-fisc.aliquota-ipi * 100)) FORMAT "9999"                /* Aliquota de Ipi */
                INT(it-nota-fisc.vl-preuni * 100000)   FORMAT  "999999999999"   /* Valor Liquido do Item */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                INT(it-nota-fisc.qt-faturada[1])    FORMAT  "999999999"           /* Qtde. Faturada */
                CAPS(fn-free-accent(it-nota-fisc.un[1]))  FORMAT  "x(02)"               /* Unidade de Medida */
                " "                                 FORMAT  "x(01)"               /* Tipo de Fornecimento */
                0                                   FORMAT  "9999"                /* Qtde. Percentual desconto */
                INT(it-nota-fisc.vl-desconto * 100) FORMAT  "99999999999"         /* Vl.Desconto do Item */
                FILL(" " , 5)                       FORMAT  "x(5)" 
                /* Skip */ .

            ASSIGN 
                i-reg-trans = i-reg-trans + 1
                wi          = wi + 10 .
            
            /*** Complemento do Item da NF ***/
            PUT UNFORMATTED
                "AE4"                                   FORMAT "x(03)"   AT 01      /* Tipo de Registro */
                ( IF it-nota-fisc.vl-icms-it = 0 THEN    0 ELSE  INT(it-nota-fisc.aliquota-icm * 100)) FORMAT "9999"               /* Aliquota Icms */
                it-nota-fisc.vl-bicms-it * 100           FORMAT "99999999999999999"  /* Base Calc ICMS */
                IF it-nota-fisc.cd-trib-icm EQ 1 THEN INT(it-nota-fisc.vl-icms-it * 100) ELSE 0   FORMAT "99999999999999999"  /* Valor Icms Item */
                IF it-nota-fisc.cd-trib-ipi EQ 1 THEN INT(it-nota-fisc.vl-ipi-it * 100 ) ELSE 0   FORMAT "99999999999999999"  /* Valor Ipi Item */
                c-sit-trib                               FORMAT "x(02)"              /* Cod.Situacao Trib */
                " "                                      FORMAT "x(30)"              /* Numero do Desenho  */
                0                                        FORMAT "999999"             /* Data da Validade do Desenho */
                " "                                      FORMAT "x(13)"              /* Pedido da Revenda */
                " "                                      FORMAT "x(5)"               /* Peso Liquido do Item */
                " "                                      FORMAT "x(1)"               /* Multiplicador de Preco Unitario */
                INT( it-nota-fisc.vl-tot-item * 100 )     FORMAT "999999999999"       /* Preco Total da Mercadoria */ 
                " "                                      FORMAT "x(1)"            
                /* Skip */ .

            ASSIGN i-reg-trans = i-reg-trans + 1.

        END .      
        
        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .
        
        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .
        

    END .
    
    ASSIGN i-reg-trans = i-reg-trans + 1.

    IF l-first EQ NO  THEN  DO:
        /** TRAILLER ***/
        PUT  UNFORMATTED
          "FTP"         FORMAT "x(03)"      AT 01
          "00000"       FORMAT "x(05)"
          i-reg-trans   FORMAT "999999999"
          " "           FORMAT "x(111)"
          /* Skip */ .

        OUTPUT  CLOSE .

        /*
        /* Enviar se Lear */
        IF emitente.cod-parceiro EQ 200007  THEN  DO:
            RUN pi-emviaftp-ford-lear .     
        END.
        */

        /* Atualizar a sequencia de mensagens */ 
        NEXT-VALUE(msgid) .

    END.

    RETURN.

END PROCEDURE .
*/




PROCEDURE pi-gera-dados-fact-gm .

    /*  CGC DO ESTABELECIMENTO DA PELZER */
    ASSIGN c-cgc = "" .
    DO i-tam = 1 TO LENGTH(estabelec.cgc):
       IF LOOKUP(SUBSTRING(estabelec.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
          ASSIGN c-cgc = c-cgc + SUBSTRING(estabelec.cgc,i-tam,1) .
    END .

    /* CGC DO CLIENTE DA NOTA FISCAL */
    IF AVAIL b-emitente THEN DO : 

        ASSIGN rc-cgc = "59104422005704" .    /* Seta CGC Padr∆o da VW para o parceiro 200.005 */

        IF b-emitente.cod-parceiro-edi EQ 200002 THEN ASSIGN rc-cgc = "03470727000120" .  /*  FORD */ 

        IF b-emitente.cod-parceiro-edi EQ 200004 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200006 OR  /* GM      */
           b-emitente.cod-parceiro-edi EQ 200007 OR  /* Lear    */
           b-emitente.cod-parceiro-edi EQ 200008 OR  /* Daimler */
           b-emitente.cod-parceiro-edi EQ 200009     /* Daimler */ THEN DO :  /* CGC DO CLIENTE */
            FIND emitente WHERE emitente.cod-emitente EQ tt-param.cliente-ini .
            ASSIGN rc-cgc = "".                    
            DO i-tam = 1 TO LENGTH(emitente.cgc):
                IF LOOKUP(SUBSTRING(emitente.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
                ASSIGN c-cgc = c-cgc + SUBSTRING(emitente.cgc,i-tam,1) .
            END .

        END . 

    END.
    ELSE ASSIGN rc-cgc = "59104422005704" .    /* CGC VW PARA DSH, CASO N«O EXISTIR O EMITENTE CADASTRADO */

    ASSIGN i-reg-trans = 1 .
        
    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK 
             BREAK BY nota-fiscal.cod-estabel
                   BY nota-fiscal.serie
                   BY nota-fiscal.nr-nota-fis :

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela   NE ? THEN NEXT .
        
        IF nota-fiscal.ind-tip-nota NE 1 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .
        
        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal             AND 
           es-nota-fiscal.aviso-emb EQ YES  AND 
           tt-param.reenvia         EQ NO   THEN NEXT .

        FIND es-deljit WHERE  es-deljit.cod-estabel EQ nota-fiscal.cod-estabel
                       AND    es-deljit.serie       EQ nota-fiscal.serie
                       AND    es-deljit.nr-nota-fis EQ nota-fiscal.nr-nota-fis NO-ERROR .

        IF NOT AVAILABLE es-deljit     THEN NEXT . 
        IF es-deljit.l-verificou EQ NO THEN NEXT .

        IF FIRST-OF (nota-fiscal.cod-estabel) OR 
           FIRST-OF (nota-fiscal.serie)       OR
           FIRST-OF (nota-fiscal.nr-nota-fis) THEN  DO:

            IF b-emitente.cod-parceiro-edi EQ 200004 THEN ASSIGN c-arq-saida = "GMPR" + TRIM(nota-fiscal.nr-nota-fis ) + TRIM(nota-fiscal.serie) .
            ELSE ASSIGN c-arq-saida = "GMPA" + TRIM(nota-fiscal.nr-nota-fis ) + TRIM(nota-fiscal.serie) .

            ASSIGN 
                c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".ADV" . 

            OUTPUT STREAM ediant TO VALUE(c-arq-saida-full) PAGE-SIZE  0 .

        END.

        ASSIGN v_log_gerou_mov = YES .

        FIND estabelec OF nota-fiscal NO-LOCK NO-ERROR .
        FIND emitente  OF estabelec   NO-LOCK NO-ERROR .
        ASSIGN 
            v-comcode-est = ENTRY(2,emitente.home-page,"#") 
            v-duns-number = ENTRY(3,emitente.home-page,"#") .

        /* Peáas e Acessorios */
        ASSIGN v-comcode-cli = "GDB"
               v-literal     = "PEA" .

        IF es-deljit.sis-emissor EQ "88835" THEN     /* PRODUCAO */
            ASSIGN v-comcode-cli = "BFT"
                   v-literal     = "GMDESADV" .

        IF es-deljit.sis-emissor EQ "PEA" THEN       /* PEA */
            ASSIGN v-comcode-est = estabelec.CGC
                   v-comcode-cli = "GDB"
                   v-literal     = "PEA" .

        IF es-deljit.sis-emissor EQ "88122" THEN     /* Materia Prima */
            ASSIGN v-comcode-cli = "MZ7"
                   v-literal     = "GMDESADV" .     

        ASSIGN de-qtde = 0 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK BY it-nota-fisc.it-codigo  :
            ASSIGN de-qtde = de-qtde + it-nota-fisc.qt-faturada[1] .
        END.

        PUT STREAM ediant UNFORMATTED "UNB+UNOA:1+" + v-comcode-est + ":ZZ+" + v-comcode-cli + ":ZZ+" + 
            SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") +
            STRING(DAY(TODAY),"99") + ":" + REPLACE(STRING(TIME,"hh:mm"),":","") + 
            "+" + TRIM(STRING( CURRENT-VALUE ( seq-desadv ) )  ) + "++" + TRIM(v-literal ) + "'" . 

        PUT STREAM ediant UNFORMATTED "UNH+1+DESADV:D:97A:UN'" .
            
        PUT STREAM ediant UNFORMATTED "BGM++" + TRIM(STRING(INT(nota-fiscal.nr-nota-fis))) + ( IF nota-fiscal.serie EQ "" THEN "0" ELSE TRIM(nota-fiscal.serie) ) + "+9'" .
            
        PUT STREAM ediant UNFORMATTED "DTM+137:" + STRING(YEAR(TODAY) ,"9999") + STRING(MONTH(TODAY),"99") +
            STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"hh:mm"),":","") + ":203'" . 

        PUT STREAM ediant UNFORMATTED "DTM+11:" + STRING(YEAR(TODAY) ,"9999") + STRING(MONTH(TODAY),"99") + 
            STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"hh:mm"),":","") + ":203'" .
        /*    
        PUT UNFORMATTED "MEA+AAX+G+KGM:" + TRIM(STRING(nota-fiscal.peso-bru-tot)) + "'" .
        */

        ASSIGN c-peso-brut = IF TRIM(STRING(nota-fiscal.peso-bru-tot, ">>>>>>9" )) EQ "0" THEN "1" ELSE TRIM(STRING(nota-fiscal.peso-bru-tot, ">>>>>>9" )) .

        PUT STREAM ediant UNFORMATTED "MEA+AAX+G+KGM:" + c-peso-brut + "'" .
            
        PUT STREAM ediant UNFORMATTED "MEA+AAX+SQ+C62:" + TRIM(STRING(de-qtde)) + "'" .
            
        PUT STREAM ediant UNFORMATTED "RFF+MB:" + TRIM(STRING(INT(nota-fiscal.nr-nota-fis))) + ( IF nota-fiscal.serie EQ "" THEN "0" ELSE TRIM(nota-fiscal.serie) ) + "'" .

        PUT STREAM ediant UNFORMATTED "NAD+MI+" + TRIM(es-deljit.sis-emissor) + "::92'" .
            
        IF ( b-emitente.cod-parceiro-edi EQ 200006 ) THEN         PUT STREAM ediant UNFORMATTED "NAD+SU+" + TRIM(v-comcode-est) + "::16'" . 
        ELSE         PUT STREAM ediant UNFORMATTED "NAD+SU+" + TRIM(v-duns-number) + "::16'" .
            
        PUT STREAM ediant UNFORMATTED "NAD+ST+" + TRIM(es-deljit.cod-planta) + "::92'" .
            
        PUT STREAM ediant UNFORMATTED "LOC+11+" + TRIM(es-deljit.cod-doca) + "'" .
            
        IF ( b-emitente.cod-parceiro-edi EQ 200006 ) THEN PUT STREAM ediant UNFORMATTED "TDT+25++GS++RYDER::182'" .
        ELSE PUT STREAM ediant UNFORMATTED "TDT+12++J++RODO::182'" .
            
        PUT STREAM ediant UNFORMATTED "EQD+TE+RODOVIARIO'" .

        FOR EACH b-it-nota-fisc OF nota-fiscal NO-LOCK :
            ASSIGN
                de-tot-icms     = de-tot-icms +  IF ( b-it-nota-fisc.cd-trib-icm EQ 1 ) THEN b-it-nota-fisc.vl-icms-it ELSE 0 .

        END .

        ASSIGN 
            wi = 1 
            i-lin = 14 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK BY it-nota-fisc.it-codigo  :

            FIND ITEM WHERE item.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .

            FIND ped-venda WHERE
                 ped-venda.nome-abrev EQ nota-fiscal.nome-ab-cli   AND
                 ped-venda.nr-pedcli  EQ it-nota-fisc.nr-pedcli
                 NO-LOCK NO-ERROR .                         

            FIND es-ped-venda OF ped-venda NO-LOCK NO-ERROR.

            PUT STREAM ediant UNFORMATTED "CPS+"    + TRIM( STRING(wi)  )         + "++4'" .
            PUT STREAM ediant UNFORMATTED "LIN+++"  + TRIM( c-it-codigo )         + ":"    + "IN'" .
            PUT STREAM ediant UNFORMATTED "PIA+1+"  + TRIM( STRING(YEAR(TODAY)))  + ":RY'" .
            PUT STREAM ediant UNFORMATTED "QTY+3:"  + TRIM( STRING (it-nota-fisc.qt-faturada[1] ) ) + ":EA'" .
            PUT STREAM ediant UNFORMATTED "QTY+12:" + TRIM( STRING (it-nota-fisc.qt-faturada[1] ) ) + ":EA'"  .
            PUT STREAM ediant UNFORMATTED "RFF+ON:" + TRIM( ped-venda.nr-pedcli ) + "'" .

            ASSIGN 
                wi    = wi + 1 
                i-lin = i-lin + 6 .

            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .

        END.

        PUT STREAM ediant UNFORMATTED "UNT+" + TRIM (STRING (i-lin) ) + "+1'" .
        PUT STREAM ediant UNFORMATTED "UNZ+1+" + TRIM(STRING( CURRENT-VALUE ( seq-desadv ) )  ) + "'" .

        NEXT-VALUE ( seq-desadv ) .            

        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .

        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .

        ASSIGN  
            es-deljit.l-atualizado   = YES .
    
        OUTPUT STREAM ediant CLOSE .

        /*
        IF LAST-OF (nota-fiscal.cod-estabel) OR
           LAST-OF (nota-fiscal.serie)       OR
           LAST-OF (nota-fiscal.nr-nota-fis) THEN  DO:

            RUN pi-emviaftp-gm  . 

        END.
        */

    END.

    RETURN.

END PROCEDURE .



PROCEDURE pi-gera-dados-fact-psa .

    /*  CGC DO ESTABELECIMENTO DA PELZER */
    ASSIGN c-cgc = "" .
    DO i-tam = 1 TO LENGTH(estabelec.cgc):
       IF LOOKUP(SUBSTRING(estabelec.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
          ASSIGN c-cgc = c-cgc + SUBSTRING(estabelec.cgc,i-tam,1) .
    END .

    /* CGC DO CLIENTE DA NOTA FISCAL */
    ASSIGN rc-cgc = "67405936000505" .    /* Seta CGC Padr∆o da PSA para o parceiro 200.010 */
    IF AVAIL b-emitente THEN DO : 
        FIND emitente WHERE emitente.cod-emitente EQ tt-param.cliente-ini .
        ASSIGN rc-cgc = "".                    
        DO i-tam = 1 TO LENGTH(emitente.cgc):
                IF LOOKUP(SUBSTRING(emitente.cgc,i-tam,1),"0,1,2,3,4,5,6,7,8,9") <> 0 THEN 
                ASSIGN c-cgc = c-cgc + SUBSTRING(emitente.cgc,i-tam,1) .
        END .
    END.

    ASSIGN i-reg-trans = 1 .
        
    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK 
             BREAK BY nota-fiscal.cod-estabel
                   BY nota-fiscal.serie
                   BY nota-fiscal.nr-nota-fis :

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela   NE ? THEN NEXT .
        
        IF nota-fiscal.ind-tip-nota NE 1 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .
        
        /*------- Envio ----------------------------------*/
        /*
        IF AVAIL es-nota-fiscal            AND 
           es-nota-fiscal.aviso-emb EQ YES THEN NEXT .
        */

        FIND es-deljit WHERE  es-deljit.cod-estabel EQ nota-fiscal.cod-estabel
                       AND    es-deljit.serie       EQ nota-fiscal.serie
                       AND    es-deljit.nr-nota-fis EQ nota-fiscal.nr-nota-fis NO-ERROR .

        IF NOT AVAILABLE es-deljit THEN NEXT . 

        FIND FIRST es-it-deljit OF es-deljit NO-LOCK NO-ERROR .
        FIND es-progent WHERE es-progent.nr-chamada   EQ es-it-deljit.nr-chamada USE-INDEX ch-chamada
                        NO-LOCK NO-ERROR .

        IF FIRST-OF (nota-fiscal.cod-estabel) OR 
           FIRST-OF (nota-fiscal.serie)       OR
           FIRST-OF (nota-fiscal.nr-nota-fis) THEN  DO:

            ASSIGN 
                c-arq-saida      = "PSA" + TRIM(nota-fiscal.nr-nota-fis ) + TRIM(nota-fiscal.serie) 
                c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".ADV" . 

            OUTPUT STREAM ediant TO VALUE(c-arq-saida-full) PAGE-SIZE  0 .

        END.

        ASSIGN v_log_gerou_mov = YES .

        FIND estabelec OF nota-fiscal NO-LOCK NO-ERROR .
        FIND emitente  OF estabelec   NO-LOCK NO-ERROR .

        ASSIGN 
            v-comcode-est = ENTRY(2,emitente.home-page,"#") 
            v-duns-number = ENTRY(3,emitente.home-page,"#") .

        ASSIGN 
            v-comcode-est = "901176479"
            v-comcode-cli = "1552100554BR00"
            v-literal     = "00000029876541++++0++0" .

        ASSIGN de-qtde = 0 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK BY it-nota-fisc.it-codigo  :
            ASSIGN de-qtde = de-qtde + it-nota-fisc.qt-faturada[1] .
        END.

        PUT STREAM ediant UNFORMATTED "UNB+UNOA:3+" + v-comcode-est + "+" + v-comcode-cli + "+" + 
            SUBSTRING(STRING(YEAR(TODAY),"9999"),3,2) + STRING(MONTH(TODAY),"99") +
            STRING(DAY(TODAY),"99") + ":" + REPLACE(STRING(TIME,"hh:mm"),":","") + 
            "+" + TRIM(STRING( CURRENT-VALUE ( seq-desadv ) )  ) + "++++0++0'" .
           /* "+" TRIM(v-literal ) + "'" . */ /* Retirei este para colocar o n. seq no lugar.*/
        

        PUT STREAM ediant UNFORMATTED "UNH+" + TRIM(STRING(NEXT-VALUE(msgid)) ) + "+DESADV:D:96A:UN:A01051++1'" .
            
        PUT STREAM ediant UNFORMATTED "BGM+351+" + TRIM(STRING(INT(nota-fiscal.nr-nota-fis))) + ( IF nota-fiscal.serie EQ "" THEN "0" ELSE TRIM(nota-fiscal.serie) ) + "'" .
            
        PUT STREAM ediant UNFORMATTED "DTM+132:" + STRING(YEAR(nota-fiscal.dt-saida) ,"9999") + STRING(MONTH(nota-fiscal.dt-saida),"99") + 
            STRING(DAY(nota-fiscal.dt-saida),"99") + REPLACE(TRIM(es-progent.hr-entrega),":","") + ":203'" .
            
        PUT STREAM ediant UNFORMATTED "DTM+137:" + STRING(YEAR(TODAY) ,"9999") + STRING(MONTH(TODAY),"99") +
            STRING(DAY(TODAY),"99") + REPLACE(STRING(TIME,"hh:mm"),":","") + ":203'" .

        PUT STREAM ediant UNFORMATTED "MEA+AAX+AAD+KGM:" + TRIM(STRING(nota-fiscal.peso-bru-tot)) + "'" .
            
        PUT STREAM ediant UNFORMATTED "RFF+CRN:" + "OE04" + "'" .

        PUT STREAM ediant UNFORMATTED "NAD+CN+006090203633400000::5'" .

        PUT STREAM ediant UNFORMATTED "LOC+11+" + IF AVAIL es-progent THEN es-progent.doca + "'" ELSE "XXXXX"  . 

        PUT STREAM ediant UNFORMATTED "NAD+CZ+006090117647900000::5'" .

        PUT STREAM ediant UNFORMATTED "NAD+SE+006090117647900000::5'" .

        PUT STREAM ediant UNFORMATTED "RFF+ADE:15200W0101'" .
            
        PUT STREAM ediant UNFORMATTED "EQD+TE+" + nota-fiscal.placa + "'" .

        FOR EACH b-it-nota-fisc OF nota-fiscal NO-LOCK :
            ASSIGN
                de-tot-icms     = de-tot-icms +  IF ( b-it-nota-fisc.cd-trib-icm EQ 1 ) THEN b-it-nota-fisc.vl-icms-it ELSE 0 .

        END .

        ASSIGN 
            wi = 1 
            i-lin = 13 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK BY it-nota-fisc.it-codigo  :

            FIND ITEM WHERE item.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .


            FIND FIRST es-it-deljit OF it-nota-fisc NO-LOCK NO-ERROR .
            FIND es-progent WHERE es-progent.nr-chamada   EQ es-it-deljit.nr-chamada USE-INDEX ch-chamada 
                            NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .

            FIND ped-venda WHERE
                 ped-venda.nome-abrev EQ nota-fiscal.nome-ab-cli   AND
                 ped-venda.nr-pedcli  EQ it-nota-fisc.nr-pedcli
                 NO-LOCK NO-ERROR .                         

            FIND es-ped-venda OF ped-venda NO-LOCK NO-ERROR.

            /* Calculo de UM */
            /* DO wj = 1 TO ( es-progent.qt-entrega / es-progent.qtd-uc / es-progent.qtd-um ) : */

                PUT STREAM ediant UNFORMATTED "CPS+"    + TRIM( STRING(wi)  )         + "++1'" .
                PUT STREAM ediant UNFORMATTED "PAC+" + TRIM(STRING(es-progent.qtd-um) ) + "++" + IF AVAIL es-progent THEN es-progent.tipo-embal + ":92'" ELSE "" + ":92'" . 
                PUT STREAM ediant UNFORMATTED "QTY+52:" + TRIM( STRING (es-progent.qtd-uc ) ) + ":PCE'" .

                FOR EACH es-etiq-psa WHERE es-etiq-psa.nr-chamada  EQ es-progent.nr-chamada 
                                     AND   es-etiq-psa.nr-etiqueta EQ es-etiq-psa.nr-etiqueta-um :

                    PUT STREAM ediant UNFORMATTED "PCI+17'" .
                    PUT STREAM ediant UNFORMATTED "RFF+AAT:" + TRIM(STRING(es-etiq-psa.nr-etiqueta-um) )  + "'" .

                    ASSIGN wk = 0 .
                    FOR EACH b-es-etiq-psa WHERE b-es-etiq-psa.nr-chamada     EQ es-etiq-psa.nr-chamada 
                                           AND   b-es-etiq-psa.nr-etiqueta    NE es-etiq-psa.nr-etiqueta-um 
                                           AND   b-es-etiq-psa.nr-etiqueta-um EQ es-etiq-psa.nr-etiqueta-um  NO-LOCK :
                        PUT STREAM ediant UNFORMATTED "GIR+3+"   + TRIM(STRING(b-es-etiq-psa.nr-etiqueta) ) + ":ML++" + TRIM(es-progent.nr-chamada) + ":BU'" .
                        ASSIGN wk = wk + 1 .
                    END.
                    IF wk EQ 0  THEN PUT STREAM ediant UNFORMATTED "GIR+3+"   + TRIM(STRING(es-etiq-psa.nr-etiqueta) ) + ":ML++" + TRIM(es-progent.nr-chamada) + ":BU'" .

                END.

                PUT STREAM ediant UNFORMATTED "LIN+++"   + TRIM( c-it-codigo )         + ":"    + "IN++0'" .
                PUT STREAM ediant UNFORMATTED "QTY+12:"  + TRIM( STRING (it-nota-fisc.qt-faturada[1] ) ) + ":PCE'"  .
                PUT STREAM ediant UNFORMATTED "ALI+"   + "BR'" .
                PUT STREAM ediant UNFORMATTED "RFF+ON:"  + TRIM( ped-venda.nr-pedcli ) + "'" .

                ASSIGN 
                    wi    = wi + 1  
                    i-lin = i-lin + 10 .

            /* END.  */

            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .

        END.

        PUT STREAM ediant UNFORMATTED "UNT+" + TRIM (STRING (i-lin) ) + "+" + TRIM(STRING(CURRENT-VALUE(msgid)) ) + "'" . 
        PUT STREAM ediant UNFORMATTED "UNZ+1+" + TRIM(STRING( CURRENT-VALUE ( seq-desadv ) )  ) + "'" .

        NEXT-VALUE ( seq-desadv ) .            

        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .

        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .

        ASSIGN  
            es-deljit.l-atualizado   = YES .
    
        OUTPUT STREAM ediant CLOSE .

        /*
        IF LAST-OF (nota-fiscal.cod-estabel) OR
           LAST-OF (nota-fiscal.serie)       OR
           LAST-OF (nota-fiscal.nr-nota-fis) THEN  DO:

            RUN pi-emviaftp-psa  . 

        END.
        */

    END.

    RETURN.

END PROCEDURE .



PROCEDURE PI-Imprime_Log :
    VIEW FRAME  f-cabec
    FRAME  f-rodape
    FRAME  f_impressao.
               
    FOR EACH tt-log-conf NO-LOCK 
              BY   tt-log-conf.cod-estabel
              BY   tt-log-conf.serie
              BY   INT(tt-log-conf.nr-nota-fis):

        RUN PI-acompanhar IN h-acomp (INPUT tt-log-conf.nr-nota-fis).
        PUT tt-log-conf.cod-estabel     AT 02
                  tt-log-conf.serie           AT 06 FORMAT  "x(03)"
                  tt-log-conf.nr-nota-fis     FORMAT "x(10)" AT 11 
                  tt-log-conf.dt-emissao      AT  23
                  tt-log-conf.nr-pedcli       AT  35
                  tt-log-conf.nome-abrev      AT  49
                  tt-log-conf.nat-operacao    AT  61
                  tt-log-conf.nr-seq-fat      AT  70 FORMAT ">>9"
                  tt-log-conf.it-codigo       AT  77.
                  
    END .

    RETURN .

END PROCEDURE .





PROCEDURE pi-gera-AEGv02 :


    /*
    IF tt-param.cod-estabel EQ "403"  THEN DO:
        CREATE tt-log-conf.
        ASSIGN 
            tt-log-conf.cod-estabel  = tt-param.cod-estabel
            tt-log-conf.serie        = tt-param.serie
            tt-log-conf.nr-nota-fis  = tt-param.nr-nota-ini
            .

        RETURN .

    END.
    */


    EMPTY TEMP-TABLE t-nf-edi .

    ASSIGN l-erro = NO.

    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK :

        FIND xs-nfe OF nota-fiscal NO-LOCK NO-ERROR .
        IF AVAIL xs-nfe THEN FIND xs-nfe-ret OF xs-nfe NO-LOCK NO-ERROR .

        IF NOT AVAIL xs-nfe OR NOT AVAIL xs-nfe-ret THEN DO:

            FIND FIRST xs-nfe-ret WHERE xs-nfe-ret.serie       EQ nota-fiscal.serie
                                  AND   xs-nfe-ret.nr-nota-fis EQ nota-fiscal.nr-nota-fis
                                  NO-LOCK NO-ERROR .

            IF NOT AVAIL xs-nfe-ret THEN DO:

                RUN pi-message("Nao existe retorno da BOLDCRON para enviar aviso de embarque para a NFE: " + nota-fiscal.nr-nota-fis + " , Favor aguardar ou entrar em contato com TI ou BOLDCRON" ) .
                ASSIGN l-erro = YES.

            END.

        END.

    END.

    IF l-erro EQ YES  THEN  RETURN .

    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK :

        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela <> ? THEN NEXT .
        
        /*  Caso o tipo de NF seja diferente de 1 e o parceiro n∆o seja a Lear ou Ford, o registro deve ser desprezado */
        IF nota-fiscal.ind-tip-nota  NE 1      AND 
           emitente.cod-parceiro-edi NE 200007 AND
           emitente.cod-parceiro-edi NE 200002 THEN NEXT .

        /* Caso n∆o seja uma nota fiscal de sistema (ind-tip-nota eq 1) e n∆o seja das naturezas de operacao 5920/5921/5921T, o registro deve ser desprezado */
        IF nota-fiscal.ind-tip-nota  NE 1       AND
           nota-fiscal.nat-oper      NE "5920"  AND
           nota-fiscal.nat-oper      NE "5921"  AND
           nota-fiscal.nat-oper      NE "5920T" THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao EQ nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .


        FIND xs-nfe OF nota-fiscal NO-LOCK NO-ERROR .
        IF AVAIL xs-nfe THEN FIND xs-nfe-ret OF xs-nfe NO-LOCK NO-ERROR .

        IF NOT AVAIL xs-nfe OR NOT AVAIL xs-nfe-ret THEN DO:

            FIND FIRST xs-nfe-ret WHERE xs-nfe-ret.serie       EQ nota-fiscal.serie
                                  AND   xs-nfe-ret.nr-nota-fis EQ nota-fiscal.nr-nota-fis
                                  NO-LOCK NO-ERROR .
        END.

        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .

        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal                AND 
           es-nota-fiscal.aviso-emb  EQ YES    AND 
           tt-param.reenvia          EQ NO     AND 
           emitente.cod-parceiro-edi NE 200002 AND 
           emitente.cod-parceiro-edi NE 200004 AND 
           emitente.cod-parceiro-edi NE 200006 AND 
           emitente.cod-parceiro-edi NE 200005 THEN NEXT .

        /* N∆o sera mais usada a rotina abaixo, sera considerada a planta do pedido 
        /* Verificar planta, doca e sistema emissor para GM e Ford */
        IF emitente.cod-parceiro-edi EQ 200004  OR        /* GM Produá∆o */
           emitente.cod-parceiro-edi EQ 200006  OR        /* GM P&A      */
           emitente.cod-parceiro-edi EQ 200002  THEN DO:  /* Ford        */

            FIND es-deljit WHERE  es-deljit.cod-estabel EQ nota-fiscal.cod-estabel
                           AND    es-deljit.serie       EQ nota-fiscal.serie
                           AND    es-deljit.nr-nota-fis EQ nota-fiscal.nr-nota-fis NO-ERROR .

            IF NOT AVAILABLE es-deljit     THEN NEXT . 
            IF es-deljit.l-verificou EQ NO THEN NEXT .

        END.
        */



        FIND t-nf-edi OF nota-fiscal NO-ERROR .
        IF NOT AVAIL t-nf-edi THEN DO:
            CREATE t-nf-edi.
            ASSIGN 
                t-nf-edi.cod-estabel      = nota-fiscal.cod-estabel
                t-nf-edi.serie            = nota-fiscal.serie
                t-nf-edi.nr-nota-fis      = nota-fiscal.nr-nota-fis 
                t-nf-edi.cod-parceiro-edi = emitente.cod-parceiro-edi .

            /* Caso o cliente seja DSH sera setado o parceiro edi 200005 VW */
            IF tt-param.conc EQ YES AND emitente.cod-gr-cli EQ 2 THEN ASSIGN t-nf-edi.cod-parceiro-edi = 200005 .
            /* Caso seja DSC sera setado o parceiro 200006 GM P&A */
            IF tt-param.conc EQ YES AND emitente.cod-gr-cli EQ 5 THEN ASSIGN t-nf-edi.cod-parceiro-edi = 200006 .

        END.

    END.


    FOR EACH t-nf-edi USE-INDEX idx-parceiro 
                      BREAK BY t-nf-edi.cod-parceiro-edi :

        FIND nota-fiscal OF t-nf-edi    NO-LOCK NO-ERROR .
        FIND natur-oper  OF nota-fiscal NO-LOCK NO-ERROR .
        FIND estabelec   OF nota-fiscal NO-LOCK NO-ERROR .
        FIND emitente    OF nota-fiscal NO-LOCK NO-ERROR .

        /* Para o parceiro 200002-Ford ou 200005-VW , devera ser gerado varios avisos em um £nico arquivo */
        IF FIRST-OF (t-nf-edi.cod-parceiro-edi) THEN DO:

            CASE t-nf-edi.cod-parceiro-edi :

                WHEN 200002 THEN DO:  /* Ford */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\mp\" .
                    ELSE ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\grupo\" .

                    ASSIGN   
                        c-arq-saida      = "FORD" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AEG" .

                END.

                WHEN 200004 THEN DO:   /* GM PRODUÄ«O */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\grupo\" .

                    ASSIGN   
                        c-arq-saida      = "GMPR" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.

                WHEN 200005 THEN DO:   /* VW */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\" .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\" .

                    ASSIGN   
                        c-arq-saida      = "VWB" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                        
                END.

                WHEN 200006 THEN DO:   /* GM P&A */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\mp\" .
                    ELSE ASSIGN c-diretorio = "\\192.168.120.45\sintel\out\grupo\" .

                    ASSIGN   
                        c-arq-saida      = "GMPA" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.

                WHEN 200007 THEN DO:   /* LEAR */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\" .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\" .


                    ASSIGN   
                        c-arq-saida      = "LEAR" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.


            END CASE.


            OUTPUT STREAM edi TO VALUE (c-arq-saida-full) PAGE-SIZE  0 . 


        END.


        FIND FIRST fat-duplic 
             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel AND 
                   fat-duplic.serie       = nota-fiscal.serie       AND 
                   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura 
                   NO-LOCK NO-ERROR .
                   
        IF AVAIL(fat-duplic) THEN 
           ASSIGN c-dt-prvenc = SUBSTR(STRING(fat-duplic.dt-venciment,"99999999"),5,4) + 
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),3,2) +
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),1,2) .
        ELSE c-dt-prvenc = IF nota-fiscal.dt-prvenc = ? THEN  "00000000"
                           ELSE SUBSTR(STRING(nota-fiscal.dt-prvenc,"99999999"),5,4) + 
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),3,2) +
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),1,2) .

        ASSIGN c-dt-prvenc = REPLACE( c-dt-prvenc, "00000000" , "        " ) .

        ASSIGN 
            i-nr-lin-nf    = 0 
            i-qtde-item    = 0 
            de-vl-bicms-it = 0
            de-tot-icms    = 0 .
        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK :
            ASSIGN 
                i-nr-lin-nf     = i-nr-lin-nf + 1 
                i-qtde-item     = i-qtde-item + it-nota-fisc.qt-faturada[1] 
                de-vl-bicms-it  = de-vl-bicms-it + it-nota-fisc.vl-bicms-it
                de-tot-icms     = de-tot-icms +  IF ( it-nota-fisc.cd-trib-icm EQ 1 ) THEN it-nota-fisc.vl-icms-it ELSE 0 .
        END.

        
        ASSIGN 
            v-comcode-est = "" 
            v-duns-number = "" . 
        FIND b-emitente-estabelec  OF estabelec   NO-LOCK NO-ERROR .
        ASSIGN 
            v-comcode-est = ENTRY(2,b-emitente-estabelec.home-page,"#") 
            v-duns-number = ENTRY(3,b-emitente-estabelec.home-page,"#") NO-ERROR .


        ASSIGN 
            v-comcode-cli = ""
            v-literal     = "" .

        /*
        IF emitente.cod-parceiro EQ 200004  OR        /* GM Produá∆o */
           emitente.cod-parceiro EQ 200006  THEN DO : /* GM P&A      */

            /* Peáas e Acessorios */
            ASSIGN v-comcode-cli = "GDB"
                   v-literal     = "PEA" .

            IF es-deljit.sis-emissor EQ "88835" THEN     /* PRODUCAO */
                ASSIGN v-comcode-cli = "BFT"
                       v-literal     = "GMDESADV" .

            IF es-deljit.sis-emissor EQ "PEA" THEN       /* PEA */
                ASSIGN v-comcode-est = estabelec.CGC
                       v-comcode-cli = "GDB"
                       v-literal     = "PEA" .

            IF es-deljit.sis-emissor EQ "88122" THEN     /* Materia Prima */
                ASSIGN v-comcode-cli = "MZ7"
                       v-literal     = "GMDESADV" .     

        END.
        */

        /* Alterado em 16/01/2009, para gerar o counteudo v-literal = "" */
        ASSIGN v-literal = "" .


        ASSIGN c-data-hora   = STRING( YEAR (TODAY), "9999" ) +
                               STRING( MONTH(TODAY), "99" ) +
                               STRING( DAY  (TODAY), "99" ) +
                               SUBSTRING( REPLACE ( STRING( TIME, "HH:MM:SS" ) , ":" , "" ) , 1 , 4 ) . /* Ano, mes, dia, hora e minuto  da geraá∆o */



        ASSIGN c-data-hora-ger = SUBSTRIN( STRING( YEAR (TODAY), "9999" ) , 3 , 2 ) +
                                 STRING( MONTH(TODAY), "99" ) +
                                 STRING( DAY  (TODAY), "99" ) +
                                 REPLACE ( STRING( TIME, "HH:MM:SS" ) , ":" , "" ) . /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */

        ASSIGN rc-cgc = nota-fiscal.cgc .
        /* Caso a NF seja de alguma filial da GM assumir o Cgc da Matriz */
        IF nota-fiscal.cgc BEGINS "59275792" THEN ASSIGN rc-cgc = "59275792000150" .

        /* Caso a NF seja de alguma filial da Ford assumir o Cgc da Matriz */
        IF nota-fiscal.cgc BEGINS "03470727" THEN ASSIGN rc-cgc = "03470727000120" .

        ASSIGN c-codigo-interno = "   " .
        /* Seta CGC Padr∆o da VW, caso seja DSH */
        IF emitente.cod-gr-cli EQ 2 THEN 
            ASSIGN 
                rc-cgc = "59104422005704" 
                c-codigo-interno = "DSH" .    

        /* Seta CGC Padr∆o da GM, caso seja DSC */
        IF emitente.cod-gr-cli EQ 5 THEN 
            ASSIGN 
                rc-cgc = "59275792000150" 
                c-codigo-interno = "DSC" .


        PUT STREAM edi UNFORMATTED
            "ITP"                FORMAT  "x(03)"     AT 001     /* Identificaá∆o do tipo de Segmento */
            "AEG"                FORMAT  "x(03)"     AT 004     /* Numero Mensagem Comunicaá∆o  */
            "02"                 FORMAT  "99"        AT 007     /* Vers∆o da Mensagem */
            STRING( CURRENT-VALUE(msgid) , "99999" ) AT 009     /* Numero de Controle do Movimento */
            c-data-hora-ger      FORMAT "x(12)"      AT 014     /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */
            estabelec.cgc        FORMAT "x(14)"      AT 026     /* Cgc do Transmissor */
            rc-cgc               FORMAT "x(14)"      AT 040     /* Cgc do Receptor    */
            " "                  FORMAT "x(8)"       AT 054     /* Codigo Interno do Transmissor, Valido para Reanault, Honda e Toyota */
            c-codigo-interno     FORMAT "x(8)"       AT 062     /* Codigo Interno do Receptor */
            " "                  FORMAT "x(25)"      AT 070     /* Nome do Transmissor */
            " "                  FORMAT "x(25)"      AT 095     /* Nome do Receptor    */
            " "                  FORMAT "x(9)"       AT 120     /* Espaáo */
            .

        ASSIGN i-segmentos = 1 .


        ASSIGN c-un-emb = "KG" .
        IF emitente.cod-emitente EQ 1729  THEN DO:
            ASSIGN c-un-emb = "C62" .
        END.

        PUT STREAM edi UNFORMATTED
            "BGM"                FORMAT "x(03)"                   AT 001   /* Identificaá∆o do tipo de Segmento    */
            ( "0" + nota-fiscal.nr-nota-fis)  FORMAT "x(8)"       AT 004   /* Numero de Identificacao do Documento */
            nota-fiscal.serie    FORMAT "x(04)"                   AT 012   /* Serie da NF */
            "9"                  FORMAT "x(3)"                    AT 016   /* Funá∆o da Mensagem 1 = Cancelamento, 9 = Original */
            c-data-hora          FORMAT "x(12)"                   AT 019   /* Ano, mes, dia, hora e minuto da geraá∆o */
            c-data-hora          FORMAT "x(12)"                   AT 031   /* Ano, mes, dia, hora e minuto da geraá∆o */
            "KG"                 FORMAT "x(3)"                    AT 043   /* Unidade de Medida Peso Bruto */
            IF INT(nota-fiscal.peso-bru-tot) LE 0 THEN "000000000001" ELSE 
            STRING(INT(nota-fiscal.peso-bru-tot), "999999999999") AT 046   /* Peso Bruto da NF */
            "KG"                 FORMAT "x(3)"                    AT 058   /* Unidade de Medida Peso Bruto */
            IF INT(nota-fiscal.peso-liq-tot) LE 0 THEN "000000000001" ELSE
            STRING(INT(nota-fiscal.peso-liq-tot), "999999999999") AT 061   /* Peso Liquido da NF */
            "PC"                 FORMAT "x(3)"                    AT 073   /* Unidade de Medida Qtde. Embarcada */
            STRING(i-qtde-item, "999999999999")                   AT 076   /* Total de Unidades Embarcadas */
            "MB"                 FORMAT "x(3)"                    AT 088   /* Tipo de Ref do Transportador */
            ("0" + nota-fiscal.nr-nota-fis + 
             TRIM( nota-fiscal.serie) ) FORMAT "x(30)"            AT 091   /* Numero de Ref do Transportador */
            " "                  FORMAT "x(8)"                    AT 121   /* Espaáo */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .

        PUT STREAM edi UNFORMATTED
            "A01"                FORMAT "x(03)"                      AT 001   /* Identificaá∆o do tipo de Segmento    */
            "0001"               FORMAT "x(04)"                      AT 004   /* Qualificador, Chave de Acesso para NFE  */
            ENTRY( 8 , xs-nfe-ret.conteudo-arq, "|" ) FORMAT "x(50)" AT 008   /* Nr da NFE eletronica Junto a SEFAZ */
            " "                  FORMAT "x(71)"                      AT 058   /* Espaáo */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        PUT STREAM edi UNFORMATTED
            "BG1"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
            c-data-hora               FORMAT "x(12)"        AT 004   /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */
            STRING( estabelec.cod-emitente ) FORMAT "x(20)" AT 016   /* Identificaá∆o do Vendedor */
            STRING( estabelec.cod-emitente ) FORMAT "x(17)" AT 036   /* Codigo Interno do Vendedor */
            STRING( estabelec.cod-emitente ) FORMAT "x(14)" AT 053   /* Codigo do Fornecedor  */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 067   /* Cgc Local de Faturamento  */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 081   /* Cgc Local de Cobranáa     */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 095   /* Cgc Local de Entrega      */
            fn-free-accent(natur-oper.denom) FORMAT "x(15)" AT 109   /* Descriá∆o da Natureza de Operaá∆o */
            " "                       FORMAT "x(5)"         AT 124   /* Espaáo */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        PUT STREAM edi UNFORMATTED
            "FA1"                     FORMAT "x(03)"                   AT 001  /* Identificaá∆o do tipo de Segmento    */
            i-nr-lin-nf               FORMAT "999"                     AT 004   /* Numero de Itens por Nota Fiscal */
            INT(nota-fiscal.vl-tot-nota * 100 ) FORMAT  "999999999999" AT 007  /* Valor Tot Nf */
            3                         FORMAT "9"                       AT 019  /* Numero de casas decimais das quantidades no registro do tipo LIN */
            natur-oper.cod-cfop       FORMAT "x(5)"       AT 020  /* CFOP-Codigo Fiscal de Operaá∆o */
            INT(de-tot-icms * 100)    FORMAT "999999999999"            AT 025  /* Valor Total do ICMS */
            c-dt-prvenc               FORMAT "x(08)"                   AT 037  /* Prim.Vencto */
            2                         FORMAT "99"                      AT 045  /* Especie de NF 1 = NF Simples 2 = NF Fatura 3 = Nf Reajuste 04 = Nf fatura Reajustes */
            INT(nota-fiscal.vl-tot-ipi * 100)   FORMAT "999999999999"  AT 047  /* Valor do Ipi */
            0                                   FORMAT "999999999999"  AT 059  /* Valor das despesas acess¢rias */
            INT(nota-fiscal.vl-frete * 100)     FORMAT "999999999999"  AT 071  /* Valor do Frete */
            INT(nota-fiscal.vl-seguro * 100)    FORMAT "999999999999"  AT 083  /* Valor do Seguro */
            INT(nota-fiscal.vl-desconto * 100)  FORMAT "999999999999"  AT 095  /* Valor do Desconto */ 
            INT(de-vl-bicms-it * 100)           FORMAT "999999999999"  AT 107  /* Valor Base de Calculo do Icms */
            " "                                 FORMAT "x(10)"         AT 119  /* Espaáos */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .

        ASSIGN 
            c-qualif-transp = ""
            c-modo-transp   = "" 
            c-codigo-transp = "" 
            c-fabrica       = "" 
            c-doca          = "" 
            c-sis-emissor   = "" .

        IF emitente.cod-parceiro-edi EQ 200004 OR
           emitente.cod-parceiro-edi EQ 200006 THEN DO:
            
            ASSIGN 
                c-qualif-transp = "12"
                c-modo-transp   = "J"
                c-codigo-transp = "RODO" .

        END.

        /* Lear e GM de Gravatai */
        IF emitente.cod-emitente EQ 3112  OR 
           emitente.cod-emitente EQ 3123  OR 
           emitente.cod-emitente EQ 1729  THEN DO:

            IF emitente.cod-emitente EQ 1729 THEN DO:
                ASSIGN 
                    c-qualif-transp = "25"
                    c-modo-transp   = "GS"
                    c-codigo-transp = "RYBR" .

            END.

        END.

        /*
        IF emitente.cod-parceiro-edi EQ 200004 OR       /* GM Produá∆o */
           emitente.cod-parceiro-edi EQ 200006 THEN DO: /* Ford */

            FIND es-deljit OF nota-fiscal NO-LOCK NO-ERROR .

            ASSIGN c-fabrica = es-deljit.cod-planta .

            IF emitente.cod-parceiro-edi EQ 200002  THEN DO:   /* Ford */
                ASSIGN c-fabrica = SUBSTRING(es-deljit.cod-planta, 2 , 2 ) .
            END.

            IF emitente.cod-parceiro-edi EQ 200004 OR         /* GM Produá∆o */
               emitente.cod-parceiro-edi EQ 200006 THEN DO:   /* GM P&A */
                ASSIGN c-fabrica = fn-localiza-planta-gm(c-fabrica)  .
            END.

            ASSIGN 
                c-doca        = es-deljit.cod-doca 
                c-sis-emissor = es-deljit.sis-emissor .


        END.
        */

        IF emitente.cod-parceiro-edi EQ 200002  THEN DO:  /* Ford */

            FIND FIRST it-nota-fisc OF nota-fiscal NO-LOCK NO-ERROR .
            IF AVAIL it-nota-fisc THEN DO:
                FIND ped-venda OF it-nota-fisc NO-LOCK NO-ERROR .
                IF AVAIL ped-venda THEN DO:
                    FIND es-ped-venda OF ped-venda NO-LOCK NO-ERROR .
                    IF AVAIL es-ped-venda  THEN DO:
                        ASSIGN 
                            c-fabrica = STRING ( INT(es-ped-venda.cod-planta), "99" )
                            c-doca    = es-ped-venda.cod-doca .
                    END.
                END.
            END.

            /* Caso sejam notas fiscais de embalagem de DDA ser∆o enviadas para a fabrica 05 */
            IF nota-fiscal.nat-oper EQ "5920" OR
               nota-fiscal.nat-oper EQ "5921" THEN  DO:

                ASSIGN c-fabrica = "05" .
                IF nota-fiscal.cod-emitente EQ 6299 THEN ASSIGN c-fabrica = "35" .

            END.

            /* Caso sejam notas fiscais de embalagem de QRI ser∆o enviadas para a fabrica 05 */
            IF nota-fiscal.nat-oper EQ "5920T" THEN ASSIGN c-fabrica = "01" .


        END.


        IF t-nf-edi.cod-parceiro-edi EQ 200005 THEN DO:  /* VW */
            ASSIGN c-fabrica = "013" .
            IF nota-fiscal.cod-estabel  EQ "002"  THEN  ASSIGN c-fabrica = "011" .
            IF nota-fiscal.cod-emitente EQ 1      THEN  ASSIGN c-fabrica = "011" .
            IF nota-fiscal.cod-emitente EQ 2      THEN  ASSIGN c-fabrica = "013" .
            IF emitente.cod-gr-cli      EQ 2      THEN  ASSIGN c-fabrica = "DSH" .
            ASSIGN c-doca    = SUBSTRING(c-fabrica, 2 , 2 ) .
        END.

        IF t-nf-edi.cod-parceiro-edi EQ 200011 THEN DO:   /* Faurecia */
            ASSIGN c-doca = "QU830"  .
        END.



        PUT STREAM edi UNFORMATTED
            "DTL"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
            c-sis-emissor             FORMAT "x(12)"        AT 004   /* Codigo do Emissor do Programa  */
            c-fabrica                 FORMAT "x(20)"        AT 016   /* Codigo da Fabrica de Entrega */
            v-duns-number             FORMAT "x(20)"        AT 036   /* Duns Number */
            " "                       FORMAT "x(10)"        AT 056   /* Duns do Local de Embarque */
            v-literal                 FORMAT "x(10)"        AT 066   /* Codigo Responsavel pela Solicitaá∆o */
            c-doca                    FORMAT "x(20)"        AT 076   /* Doca para Descarga */
            c-qualif-transp           FORMAT "x(3)"         AT 096   /* Qualif. do estagio transporte */
            c-modo-transp             FORMAT "x(4)"         AT 099   /* Modo de Transporte */
            c-codigo-transp           FORMAT "x(10)"        AT 103   /* Codigo do Transportador */
            " "                       FORMAT "x(10)"        AT 113   /* Numero da Autorizacao do Transporte */
            v-comcode-cli             FORMAT "x(3)"         AT 123   /* Codigo da Fabrica Transmissora */
            " "                       FORMAT "x(3)"         AT 126   /* Espaáos */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .



        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK :

            FIND natur-oper  OF it-nota-fisc NO-LOCK NO-ERROR .
            FIND ITEM WHERE ITEM.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .


            /*  Caso seja a VW, sera reconstruida a codificaá∆o do Item */
            ASSIGN c-tipo-fornec = " " .
            IF  t-nf-edi.cod-parceiro-edi EQ 200005 THEN DO : 

                ASSIGN c-tipo-fornec = "P" .

                ASSIGN 
                    c-mod = ""
                    c-cod = ""
                    c-cor = "" .

                IF LENGTH(c-it-codigo) GT 11 THEN DO:
                    ASSIGN 
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , IF (LENGTH (c-it-codigo) - 6) GT 0 THEN (LENGTH (c-it-codigo) - 6) ELSE 0  ) 
                        c-cod = c-cod + FILL( " " , 8 - LENGTH( TRIM(c-cod) ) )
                        c-cor = SUBSTRING(c-it-codigo , IF (LENGTH (c-it-codigo) - 2) GT 1 THEN (LENGTH (c-it-codigo) - 2) ELSE 1 , 3 )  .
                END.
                ELSE DO:
                    ASSIGN
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , LENGTH(c-it-codigo ) ) .
                END.

                ASSIGN 
                    c-it-codigo = c-mod + c-cod + c-cor .

            END.

            
            IF t-nf-edi.cod-parceiro-edi EQ 200002  THEN DO:

                IF c-fabrica EQ "5"  THEN ASSIGN c-fabrica = "05" .

                IF c-fabrica EQ "05" THEN ASSIGN c-tipo-fornec = "P" .
                IF c-fabrica EQ "01" THEN ASSIGN c-tipo-fornec = "P" .
                IF c-fabrica EQ "30" THEN ASSIGN c-tipo-fornec = "R" .
                IF c-fabrica EQ "35" THEN ASSIGN c-tipo-fornec = "R" .
                IF c-fabrica EQ "50" THEN ASSIGN c-tipo-fornec = "E" .

                /* Caso seja uma nota fiscal de embalagens de DDA, o tipo de fornecimento sera Z */
                IF nota-fiscal.nat-oper EQ "5920" OR
                   nota-fiscal.nat-oper EQ "5921" THEN ASSIGN c-tipo-fornec = "Z" .

                /* Caso seja uma nota fiscal de embalagens de QRI, o tipo de fornecimento sera Z */
                IF nota-fiscal.nat-oper EQ "5920T" THEN ASSIGN c-tipo-fornec = "Z" .


            END.

            IF t-nf-edi.cod-parceiro-edi EQ 200011 THEN DO:     /* FAURECIA*/
                ASSIGN c-tipo-fornec = "P" .
            END.

            ASSIGN c-sit-trib = TRIM(STRING(ITEM.codigo-orig)) + TRIM(STRING(it-nota-fisc.cd-trib-icm)) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (it-nota-fisc.nr-pedcli , "." , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "," , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "-" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "/" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "'" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , ";" , "" ) .

            /* Condicao especial para estabelecimento 403, para usar apenas os 6 primeiros digitos do Nr Pedido */
            IF it-nota-fisc.cod-estabel EQ "403" THEN DO:
                ASSIGN c-ped-lin-vw-ford = SUBSTRING( it-nota-fisc.nr-pedcli , 1 , 6 ) .
            END.

            PUT STREAM edi UNFORMATTED
                "CPS"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
                STRING( it-nota-fisc.nr-seq-fat, "9999" )       AT 004   /* Numero Sequencial do Item */
                " "                       FORMAT "x(121)"       AT 008   /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            ASSIGN de-qt-entrega = 0 .
            FOR EACH b-it-nota-fisc WHERE b-it-nota-fisc.it-codigo   EQ it-nota-fisc.it-codigo
                                    AND   b-it-nota-fisc.nome-ab-cli EQ it-nota-fisc.nome-ab-cli 
                                    AND   b-it-nota-fisc.dt-emis     GE 01/01/2011
                                    AND   b-it-nota-fisc.dt-cancela  EQ ? 
                                    AND   b-it-nota-fisc.emite-dup   EQ YES
                                    NO-LOCK :

                ASSIGN de-qt-entrega = de-qt-entrega + b-it-nota-fisc.qt-faturada[1] .

            END.


            PUT STREAM edi UNFORMATTED
                "LIN"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
                c-it-codigo               FORMAT "x(30)"        AT 004   /* Codigo do Item */
                INT( de-qt-entrega ) * 1000  
                FORMAT "999999999999"                           AT 034   /* Quantidade Acumulada Embarcada */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) FORMAT "x(3)"         AT 046   /* Unidade de medida qtde acumulada */
                INT( it-nota-fisc.qt-faturada[1] ) * 1000  
                FORMAT "999999999999"                           AT 049   /* Quantidade Embarcada */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) FORMAT "x(3)"         AT 061   /* Unidade de medida qtde acumulada */
                c-ped-lin-vw-ford         FORMAT "x(30)"        AT 064   /* Numero do pedido */
                STRING(YEAR(TODAY))       FORMAT "x(4)"         AT 094   /* Ano/Modelo de registro */
                "BR"                      FORMAT "x(2)"         AT 098   /* Codigo do Pais de Origem */
                c-tipo-fornec             FORMAT "x(1)"         AT 100   /* Codigo do tipo de fornecimento */
                IF INT(it-nota-fisc.peso-liq) LE 0 THEN    "000000000001" ELSE 
                STRING(INT( it-nota-fisc.peso-liq * 1000), "999999999999") AT 101   /* Peso Liquido do Item */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) 
                FORMAT "x(3)"                                   AT 113   /* Unidade de Medida do Item */
                " "                       FORMAT "x(13)"        AT 116   /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            PUT STREAM edi UNFORMATTED
                "FA2"                                FORMAT "x(03)"          AT 001  /* Identificaá∆o do tipo de Segmento    */
                DEC(it-nota-fisc.vl-preuni * 100000) FORMAT  "999999999999"  AT 004  /* Valor Liquido do Item */
                c-sit-trib                           FORMAT "x(02)"          AT 016  /* Cod.Situacao Trib */
                it-nota-fisc.class-fiscal            FORMAT  "0099999999"    AT 018  /* Classificao Fiscal */
                (IF it-nota-fisc.vl-ipi-it  = 0 THEN  0 
                 ELSE INT(it-nota-fisc.aliquota-ipi * 100) ) FORMAT "9999"  AT 028  /* Aliquota de Ipi */
                (IF it-nota-fisc.vl-icms-it = 0 THEN  0 
                 ELSE  INT(it-nota-fisc.aliquota-icm * 100)) FORMAT "9999"  AT 032  /* Aliquota Icms */
                it-nota-fisc.vl-bicms-it * 100       FORMAT "999999999999"  AT 036  /* Base Calc ICMS */
                IF it-nota-fisc.cd-trib-icm EQ 1 THEN 
                   INT(it-nota-fisc.vl-icms-it * 100) 
                ELSE 0 FORMAT "999999999999"                                AT 048  /* Valor Icms Item */
                IF it-nota-fisc.cd-trib-ipi EQ 1 THEN 
                   INT(it-nota-fisc.vl-ipi-it  * 100) 
                ELSE 0 FORMAT "999999999999"                                AT 060  /* Valor Ipi Item */
                5                                    FORMAT "9"             AT 072  /* Multiplicador de preáo unitario  */
                DEC( it-nota-fisc.vl-tot-item * 100 ) FORMAT "999999999999"  AT 073  /* Preco Total da Mercadoria */ 
                IF ( it-nota-fisc.vl-desconto NE 0 AND 
                    it-nota-fisc.vl-bicms-it   NE 0 ) THEN
                    INT(it-nota-fisc.vl-desconto / it-nota-fisc.vl-bicms-it ) * 100                           
                    ELSE 0 FORMAT "9999"                                    AT 085  /* Percentual de desconto */
                INT(it-nota-fisc.vl-desconto * 100) FORMAT "99999999999"    AT 089  /* Vl. Desconto do Item */
                0                                   FORMAT "999999999999"   AT 100  /* Valor Desconto do ICMS item */
                SUBSTRING(natur-oper.char-1 , 45 , 5 ) FORMAT "x(5)"        AT 112  /* CFO por Item */ 
                IF INT(it-nota-fisc.peso-brut) LE 0 THEN "00001" ELSE 
                STRING(INT( it-nota-fisc.peso-brut), "99999")                AT 117   /* Peso Bruto do Item */
                " "                                 FORMAT "x(7)"           AT 122  /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .

            ASSIGN v_log_gerou_mov = TRUE .


        END.


        ASSIGN i-segmentos = i-segmentos + 1 .

        PUT STREAM edi UNFORMATTED
            "FTP"                     FORMAT "x(03)"             AT 001   /* Identificaá∆o do tipo de Segmento    */
            STRING( CURRENT-VALUE(msgid) , "99999" )             AT 004   /* Numero de Controle do Movimento */
            i-segmentos               FORMAT "999999999"         AT 009   /* Quantidade de Segmentos */  
            0                         FORMAT "99999999999999999" AT 018   /* Numero total de Valores */
            " "                       FORMAT "x(1)"              AT 035   /* Categoria da Operacao */
            " "                       FORMAT "x(93)"             AT 036   /* Espaáos */
            .

        NEXT-VALUE(msgid) .


        IF LAST-OF (t-nf-edi.cod-parceiro-edi)  THEN DO:
            OUTPUT STREAM edi CLOSE .
        END.

        /*
        ELSE DO:
            /* Para o parceiro 200002-Ford, e 200005-VW , devera ser gerado varios avisos em um £nico arquivo */
            IF t-nf-edi.cod-parceiro NE 200002 AND  
               t-nf-edi.cod-parceiro NE 200005 THEN DO:
                OUTPUT STREAM edi CLOSE .
            END.
        END.
        */

        FIND es-nota-fis OF nota-fiscal NO-ERROR .
        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .

        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .


        
        FIND es-deljit OF nota-fiscal NO-ERROR .
        IF AVAIL es-deljit THEN DO:
            ASSIGN 
                es-deljit.cod-planta     = c-fabrica
                es-deljit.cod-doca       = c-doca
                es-deljit.sis-emissor    = c-tipo-fornec
                es-deljit.l-atualizado   = YES .

        END.
        

        DELETE t-nf-edi . 

    END.

END.





PROCEDURE pi-gera-AEGv05 :

    EMPTY TEMP-TABLE t-nf-edi .

    FOR EACH nota-fiscal WHERE 
             nota-fiscal.cod-estabel  EQ tt-param.cod-estabel   AND 
             nota-fiscal.serie        EQ tt-param.serie         AND 
             nota-fiscal.nr-nota-fis  GE tt-param.nr-nota-ini   AND 
             nota-fiscal.nr-nota-fis  LE tt-param.nr-nota-fim   AND 
             nota-fiscal.dt-emis-nota GE tt-param.dt-emis-ini   AND 
             nota-fiscal.dt-emis-nota LE tt-param.dt-emis-fim   /* AND
             nota-fiscal.ind-sit-nota GE 2 /* Considerar apenas Notas Impressas */ */
             NO-LOCK :

        RUN PI-acompanhar IN h-acomp (INPUT nota-fiscal.nr-nota-fis).

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH quando for solicitado apenas Montadoras*/
        IF tt-param.conc EQ NO AND nota-fiscal.cod-emitente NE tt-param.cliente-ini THEN NEXT . 
        
        FIND emitente OF nota-fiscal NO-LOCK NO-ERROR .

        /* Desprezar as Notas Fiscais de Clientes DSC e DSH que n∆o estiverem no mesmo grupo de clientes do parametro */
        IF tt-param.conc EQ YES AND emitente.cod-gr-cli NE i-cod-gr-cli  THEN NEXT .

        IF nota-fiscal.dt-cancela <> ? THEN NEXT .
        
        /*  Caso o tipo de NF seja diferente de 1 e o parceiro n∆o seja a LEAR, o registro deve ser desprezado */
        IF nota-fiscal.ind-tip-nota  NE 1      AND 
           emitente.cod-parceiro-edi NE 200007 THEN NEXT .
        
        FIND natur-oper WHERE natur-oper.nat-operacao EQ nota-fiscal.nat-operacao NO-LOCK NO-ERROR .
        /* Se nao for nota fiscal de saida, desprezar registro */
        IF natur-oper.tipo NE 2 THEN NEXT .
        
        FIND es-nota-fiscal OF nota-fiscal NO-ERROR .

        /*------- Verificar Situaá∆o do Envio ------------------------------*/
        IF AVAIL es-nota-fiscal                AND 
           es-nota-fiscal.aviso-emb  EQ YES    AND 
           tt-param.reenvia          EQ NO     AND 
           emitente.cod-parceiro-edi NE 200002 AND 
           emitente.cod-parceiro-edi NE 200004 AND 
           emitente.cod-parceiro-edi NE 200006 AND 
           emitente.cod-parceiro-edi NE 200005 THEN NEXT .


        /* Verificar planta, doca e sistema emissor para GM e Ford */
        IF emitente.cod-parceiro-edi EQ 200004  OR        /* GM Produá∆o */
           emitente.cod-parceiro-edi EQ 200006  OR        /* GM P&A      */
           emitente.cod-parceiro-edi EQ 200002  THEN DO:  /* Ford        */

            FIND es-deljit WHERE  es-deljit.cod-estabel EQ nota-fiscal.cod-estabel
                           AND    es-deljit.serie       EQ nota-fiscal.serie
                           AND    es-deljit.nr-nota-fis EQ nota-fiscal.nr-nota-fis NO-ERROR .

            IF NOT AVAILABLE es-deljit     THEN NEXT . 
            IF es-deljit.l-verificou EQ NO THEN NEXT .

        END.


        FIND t-nf-edi OF nota-fiscal NO-ERROR .
        IF NOT AVAIL t-nf-edi THEN DO:
            CREATE t-nf-edi.
            ASSIGN 
                t-nf-edi.cod-estabel      = nota-fiscal.cod-estabel
                t-nf-edi.serie            = nota-fiscal.serie
                t-nf-edi.nr-nota-fis      = nota-fiscal.nr-nota-fis 
                t-nf-edi.cod-parceiro-edi = emitente.cod-parceiro-edi .

            /* Caso o cliente seja DSH sera setado o parceiro edi 200005 VW */
            IF tt-param.conc EQ YES AND emitente.cod-gr-cli EQ 2 THEN ASSIGN t-nf-edi.cod-parceiro-edi = 200005 .
            /* Caso seja DSC sera setado o parceiro 200006 GM P&A */
            IF tt-param.conc EQ YES AND emitente.cod-gr-cli EQ 5 THEN ASSIGN t-nf-edi.cod-parceiro-edi = 200006 .

        END.

    END.


    FOR EACH t-nf-edi USE-INDEX idx-parceiro 
                      BREAK BY t-nf-edi.cod-parceiro-edi :

        FIND nota-fiscal OF t-nf-edi    NO-LOCK NO-ERROR .
        FIND natur-oper  OF nota-fiscal NO-LOCK NO-ERROR .
        FIND estabelec   OF nota-fiscal NO-LOCK NO-ERROR .
        FIND emitente    OF nota-fiscal NO-LOCK NO-ERROR .

        /* Para o parceiro 200002-Ford ou 200005-VW , devera ser gerado varios avisos em um £nico arquivo */
        IF FIRST-OF (t-nf-edi.cod-parceiro-edi) THEN DO:

            CASE t-nf-edi.cod-parceiro-edi :

                WHEN 200002 THEN DO:  /* Ford */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\"  .

                    ASSIGN   
                        c-arq-saida      = "FORD" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.

                WHEN 200004 THEN DO:   /* GM PRODUÄ«O */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\"  .

                    ASSIGN   
                        c-arq-saida      = "GMPR" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.

                WHEN 200005 THEN DO:   /* VW */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\"  .

                    ASSIGN   
                        c-arq-saida      = "VWB" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                        
                END.

                WHEN 200006 THEN DO:   /* GM P&A */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\"  .

                    ASSIGN   
                        c-arq-saida      = "GMPA" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.

                WHEN 200007 THEN DO:   /* LEAR */

                    IF param-global.empresa-prin EQ 1  THEN ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\mp\"  .
                    ELSE ASSIGN c-diretorio      = "\\192.168.120.45\sintel\out\grupo\"  .

                    ASSIGN   
                        c-arq-saida      = "LEAR" + TRIM(nota-fiscal.nr-nota-fis)  + TRIM(nota-fiscal.serie)  
                        c-arq-saida-full = TRIM(c-diretorio) + TRIM(c-arq-saida) + ".AVB" .

                END.


            END CASE.


            OUTPUT STREAM edi TO VALUE (c-arq-saida-full) PAGE-SIZE  0 . 


        END.


        FIND FIRST fat-duplic 
             WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel AND 
                   fat-duplic.serie       = nota-fiscal.serie       AND 
                   fat-duplic.nr-fatura   = nota-fiscal.nr-fatura 
                   NO-LOCK NO-ERROR .
                   
        IF AVAIL(fat-duplic) THEN 
           ASSIGN c-dt-prvenc = SUBSTR(STRING(fat-duplic.dt-venciment,"99999999"),5,4) + 
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),3,2) +
                                SUBSTR(STRING(fat-duplic.dt-venciment,"999999"),1,2) .
        ELSE c-dt-prvenc = IF nota-fiscal.dt-prvenc = ? THEN  "00000000"
                           ELSE SUBSTR(STRING(nota-fiscal.dt-prvenc,"99999999"),5,4) + 
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),3,2) +
                                SUBSTR(STRING(nota-fiscal.dt-prvenc,"999999"),1,2) .

        ASSIGN c-dt-prvenc = REPLACE( c-dt-prvenc, "00000000" , "        " ) .

        ASSIGN 
            i-nr-lin-nf    = 0 
            i-qtde-item    = 0 
            de-vl-bicms-it = 0
            de-tot-icms    = 0 
            de-vl-pis      = 0
            de-vl-cofins   = 0 
            de-tot-bicmssubs = 0 
            de-tot-icmssubs  = 0 .

        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK :

            ASSIGN 
                i-nr-lin-nf     = i-nr-lin-nf + 1 
                i-qtde-item     = i-qtde-item + it-nota-fisc.qt-faturada[1] 
                de-vl-bicms-it  = de-vl-bicms-it + it-nota-fisc.vl-bicms-it
                de-tot-icms     = de-tot-icms +  IF ( it-nota-fisc.cd-trib-icm EQ 1 ) THEN it-nota-fisc.vl-icms-it ELSE 0 .

            ASSIGN 
                de-vl-pis        = de-vl-pis    + ROUND( it-nota-fisc.vl-merc-liq * ( DEC( SUBSTRING(it-nota-fisc.char-2, 76 , 5 ) ) / 100 ) , 2 ) 
                de-vl-cofins     = de-vl-cofins + ROUND( it-nota-fisc.vl-merc-liq * ( DEC( SUBSTRING(it-nota-fisc.char-2, 81 , 5 ) ) / 100 ) , 2 ) .

            ASSIGN
                de-tot-icmssubs  = de-tot-icmssubs  + it-nota-fisc.vl-icmsub-it
                de-tot-bicmssubs = de-tot-bicmssubs + it-nota-fisc.vl-bsubs-it  .

        END.

        
        ASSIGN 
            v-comcode-est = "" 
            v-duns-number = "" . 
        FIND b-emitente-estabelec  OF estabelec   NO-LOCK NO-ERROR .
        ASSIGN 
            v-comcode-est = ENTRY(2,b-emitente-estabelec.home-page,"#") 
            v-duns-number = ENTRY(3,b-emitente-estabelec.home-page,"#") NO-ERROR .


        ASSIGN 
            v-comcode-cli = ""
            v-literal     = "" .

        IF emitente.cod-parceiro EQ 200004  OR        /* GM Produá∆o */
           emitente.cod-parceiro EQ 200006  THEN DO : /* GM P&A      */

            /* Peáas e Acessorios */
            ASSIGN v-comcode-cli = "GDB"
                   v-literal     = "PEA" .

            IF es-deljit.sis-emissor EQ "88835" THEN     /* PRODUCAO */
                ASSIGN v-comcode-cli = "BFT"
                       v-literal     = "GMDESADV" .

            IF es-deljit.sis-emissor EQ "PEA" THEN       /* PEA */
                ASSIGN v-comcode-est = estabelec.CGC
                       v-comcode-cli = "GDB"
                       v-literal     = "PEA" .

            IF es-deljit.sis-emissor EQ "88122" THEN     /* Materia Prima */
                ASSIGN v-comcode-cli = "MZ7"
                       v-literal     = "GMDESADV" .     

        END.


        /* Alterado em 16/01/2009, para gerar o counteudo v-literal = "" */
        ASSIGN v-literal = "" .


        ASSIGN c-data-hora   = STRING( YEAR (TODAY), "9999" ) +
                               STRING( MONTH(TODAY), "99" ) +
                               STRING( DAY  (TODAY), "99" ) +
                               SUBSTRING( REPLACE ( STRING( TIME, "HH:MM:SS" ) , ":" , "" ) , 1 , 4 ) . /* Ano, mes, dia, hora e minuto  da geraá∆o */



        ASSIGN c-data-hora-ger = SUBSTRIN( STRING( YEAR (TODAY), "9999" ) , 3 , 2 ) +
                                 STRING( MONTH(TODAY), "99" ) +
                                 STRING( DAY  (TODAY), "99" ) +
                                 REPLACE ( STRING( TIME, "HH:MM:SS" ) , ":" , "" ) . /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */

        ASSIGN rc-cgc = nota-fiscal.cgc .
        /* Caso a NF seja de alguma filial da GM assumir o Cgc da Matriz */
        IF nota-fiscal.cgc BEGINS "59275792" THEN ASSIGN rc-cgc = "59275792000150" .

        /* Caso a NF seja de alguma filial da Ford assumir o Cgc da Matriz */
        IF nota-fiscal.cgc BEGINS "03470727" THEN ASSIGN rc-cgc = "03470727000120" .

        ASSIGN c-codigo-interno = "   " .
        /* Seta CGC Padr∆o da VW, caso seja DSH */
        IF emitente.cod-gr-cli EQ 2 THEN 
            ASSIGN 
                rc-cgc = "59104422005704" 
                c-codigo-interno = "DSH" .    

        /* Seta CGC Padr∆o da GM, caso seja DSC */
        IF emitente.cod-gr-cli EQ 5 THEN 
            ASSIGN 
                rc-cgc = "59275792000150" 
                c-codigo-interno = "DSC" .


        PUT STREAM edi UNFORMATTED
            "ITP"                FORMAT  "x(03)"     AT 001     /* Identificaá∆o do tipo de Segmento */
            "AEG"                FORMAT  "x(03)"     AT 004     /* Numero Mensagem Comunicaá∆o  */
            "05"                 FORMAT  "99"        AT 007     /* Vers∆o da Mensagem */
            STRING( CURRENT-VALUE(msgid) , "99999" ) AT 009     /* Numero de Controle do Movimento */
            c-data-hora-ger      FORMAT "x(12)"      AT 014     /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */
            estabelec.cgc        FORMAT "x(14)"      AT 026     /* Cgc do Transmissor */
            rc-cgc               FORMAT "x(14)"      AT 040     /* Cgc do Receptor    */
            " "                  FORMAT "x(8)"       AT 054     /* Codigo Interno do Transmissor, Valido para Reanault, Honda e Toyota */
            c-codigo-interno     FORMAT "x(8)"       AT 062     /* Codigo Interno do Receptor */
            " "                  FORMAT "x(25)"      AT 070     /* Nome do Transmissor */
            " "                  FORMAT "x(25)"      AT 095     /* Nome do Receptor    */
            " "                  FORMAT "x(9)"       AT 120     /* Espaáo */
            .

        ASSIGN i-segmentos = 1 .

        ASSIGN c-un-emb = "KG" .
        IF emitente.cod-emitente EQ 1729  THEN DO:
            ASSIGN c-un-emb = "C62" .
        END.

        PUT STREAM edi UNFORMATTED
            "BGM"                FORMAT "x(03)"                   AT 001   /* Identificaá∆o do tipo de Segmento    */
            ( "0" + nota-fiscal.nr-nota-fis)  FORMAT "x(8)"       AT 004   /* Numero de Identificacao do Documento */
            nota-fiscal.serie    FORMAT "x(04)"                   AT 012   /* Serie da NF */
            "9"                  FORMAT "x(3)"                    AT 016   /* Funá∆o da Mensagem 1 = Cancelamento, 9 = Original */
            c-data-hora          FORMAT "x(12)"                   AT 019   /* Ano, mes, dia, hora e minuto da geraá∆o */
            c-data-hora          FORMAT "x(12)"                   AT 031   /* Ano, mes, dia, hora e minuto da geraá∆o */
            "KG"                 FORMAT "x(3)"                    AT 043   /* Unidade de Medida Peso Bruto */
            IF INT(nota-fiscal.peso-bru-tot) LE 0 THEN "000000000001" ELSE 
            STRING(INT(nota-fiscal.peso-bru-tot), "999999999999") AT 046   /* Peso Bruto da NF */
            "KG"                 FORMAT "x(3)"                    AT 058   /* Unidade de Medida Peso Bruto */
            IF INT(nota-fiscal.peso-liq-tot) LE 0 THEN "000000000001" ELSE
            STRING(INT(nota-fiscal.peso-liq-tot), "999999999999") AT 061   /* Peso Liquido da NF */
            "PC"                 FORMAT "x(3)"                    AT 073   /* Unidade de Medida Qtde. Embarcada */
            STRING(i-qtde-item, "999999999999")                   AT 076   /* Total de Unidades Embarcadas */
            "MB"                 FORMAT "x(3)"                    AT 088   /* Tipo de Ref do Transportador */
            ("0" + nota-fiscal.nr-nota-fis + 
             TRIM( nota-fiscal.serie) ) FORMAT "x(30)"            AT 091   /* Numero de Ref do Transportador */
            " "                  FORMAT "x(8)"                    AT 121   /* Espaáo */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        PUT STREAM edi UNFORMATTED
            "BG1"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
            c-data-hora               FORMAT "x(12)"        AT 004   /* Ano, mes, dia, hora, minuto e segundo da geraá∆o */
            STRING( estabelec.cod-emitente ) FORMAT "x(20)" AT 016   /* Identificaá∆o do Vendedor */
            STRING( estabelec.cod-emitente ) FORMAT "x(17)" AT 036   /* Codigo Interno do Vendedor */
            STRING( estabelec.cod-emitente ) FORMAT "x(14)" AT 053   /* Codigo do Fornecedor  */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 067   /* Cgc Local de Faturamento  */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 081   /* Cgc Local de Cobranáa     */
            nota-fiscal.cgc           FORMAT "x(14)"        AT 095   /* Cgc Local de Entrega      */
            fn-free-accent(natur-oper.denom) FORMAT "x(15)" AT 109   /* Descriá∆o da Natureza de Operaá∆o */
            " "                       FORMAT "x(5)"         AT 124   /* Espaáo */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        PUT STREAM edi UNFORMATTED
            "FA1"                     FORMAT "x(03)"                   AT 001  /* Identificaá∆o do tipo de Segmento    */
            i-nr-lin-nf               FORMAT "999"                     AT 004   /* Numero de Itens por Nota Fiscal */
            INT(nota-fiscal.vl-tot-nota * 100 ) FORMAT  "999999999999" AT 007  /* Valor Tot Nf */
            3                         FORMAT "9"                       AT 019  /* Numero de casas decimais das quantidades no registro do tipo LIN */
            SUBSTRING(natur-oper.char-1 , 45 , 5 ) FORMAT "x(5)"       AT 020  /* CFOP-Codigo Fiscal de Operaá∆o */
            INT(de-tot-icms * 100)    FORMAT "999999999999"            AT 025  /* Valor Total do ICMS */
            c-dt-prvenc               FORMAT "x(08)"                   AT 037  /* Prim.Vencto */
            2                         FORMAT "99"                      AT 045  /* Especie de NF 1 = NF Simples 2 = NF Fatura 3 = Nf Reajuste 04 = Nf fatura Reajustes */
            INT(nota-fiscal.vl-tot-ipi * 100)   FORMAT "999999999999"  AT 047  /* Valor do Ipi */
            0                                   FORMAT "999999999999"  AT 059  /* Valor das despesas acess¢rias */
            INT(nota-fiscal.vl-frete * 100)     FORMAT "999999999999"  AT 071  /* Valor do Frete */
            INT(nota-fiscal.vl-seguro * 100)    FORMAT "999999999999"  AT 083  /* Valor do Seguro */
            INT(nota-fiscal.vl-desconto * 100)  FORMAT "999999999999"  AT 095  /* Valor do Desconto */ 
            INT(de-vl-bicms-it * 100)           FORMAT "999999999999"  AT 107  /* Valor Base de Calculo do Icms */
            " "                                 FORMAT "x(10)"         AT 119  /* Espaáos */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        PUT STREAM edi UNFORMATTED
            "FT1"                         FORMAT "x(03)"              AT 001  /* Identificaá∆o do tipo de Segmento    */
            INT( de-vl-pis     * 100 )    FORMAT "99999999999999999"  AT 004  /* Valor do Pis */
            INT( de-vl-cofins  * 100 )    FORMAT "99999999999999999"  AT 021  /* Valor do Cofins */                          
            " "                           FORMAT "x(91)"              AT 038  /* Espaáos */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        ASSIGN 
            c-qualif-transp = ""
            c-modo-transp   = "" 
            c-codigo-transp = "" 
            c-fabrica       = "" 
            c-doca          = "" 
            c-sis-emissor   = "" .

        IF emitente.cod-parceiro-edi EQ 200004 OR
           emitente.cod-parceiro-edi EQ 200006 THEN DO:
            
            ASSIGN 
                c-qualif-transp = "12"
                c-modo-transp   = "J"
                c-codigo-transp = "RODO" .

        END.

        /* Lear e GM de Gravatai */
        IF emitente.cod-emitente EQ 3112  OR 
           emitente.cod-emitente EQ 3123  OR 
           emitente.cod-emitente EQ 1729  THEN DO:

            IF emitente.cod-emitente EQ 1729 THEN DO:
                ASSIGN 
                    c-qualif-transp = "25"
                    c-modo-transp   = "GS"
                    c-codigo-transp = "RYBR" .

            END.

        END.

        IF emitente.cod-parceiro-edi EQ 200004 OR       /* GM Produá∆o */
           emitente.cod-parceiro-edi EQ 200006 OR       /* GM P&A */
           emitente.cod-parceiro-edi EQ 200002 THEN DO: /* Ford */

            FIND es-deljit OF nota-fiscal NO-LOCK NO-ERROR .

            ASSIGN c-fabrica = es-deljit.cod-planta .

            IF emitente.cod-parceiro-edi EQ 200002  THEN DO:   /* Ford */
                ASSIGN c-fabrica = SUBSTRING(es-deljit.cod-planta, 2 , 2 ) .
            END.

            IF emitente.cod-parceiro-edi EQ 200004 OR         /* GM Produá∆o */
               emitente.cod-parceiro-edi EQ 200006 THEN DO:   /* GM P&A */
                ASSIGN c-fabrica = fn-localiza-planta-gm(c-fabrica)  .
            END.

            ASSIGN 
                c-doca        = es-deljit.cod-doca 
                c-sis-emissor = es-deljit.sis-emissor .


        END.


        IF t-nf-edi.cod-parceiro-edi EQ 200005 THEN DO:  /* VW */
            ASSIGN c-fabrica = "013" .
            IF nota-fiscal.cod-estabel  EQ "002"  THEN  ASSIGN c-fabrica = "011" .
            IF nota-fiscal.cod-emitente EQ 1      THEN  ASSIGN c-fabrica = "011" .
            IF nota-fiscal.cod-emitente EQ 2      THEN  ASSIGN c-fabrica = "013" .
            IF emitente.cod-gr-cli      EQ 2      THEN  ASSIGN c-fabrica = "DSH" .
            ASSIGN c-doca    = SUBSTRING(c-fabrica, 2 , 2 ) .
        END.


        PUT STREAM edi UNFORMATTED
            "DTL"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
            c-sis-emissor             FORMAT "x(12)"        AT 004   /* Codigo do Emissor do Programa  */
            c-fabrica                 FORMAT "x(20)"        AT 016   /* Codigo da Fabrica de Entrega */
            v-duns-number             FORMAT "x(20)"        AT 036   /* Duns Number */
            " "                       FORMAT "x(10)"        AT 056   /* Duns do Local de Embarque */
            v-literal                 FORMAT "x(10)"        AT 066   /* Codigo Responsavel pela Solicitaá∆o */
            c-doca                    FORMAT "x(20)"        AT 076   /* Doca para Descarga */
            c-qualif-transp           FORMAT "x(3)"         AT 096   /* Qualif. do estagio transporte */
            c-modo-transp             FORMAT "x(4)"         AT 099   /* Modo de Transporte */
            c-codigo-transp           FORMAT "x(10)"        AT 103   /* Codigo do Transportador */
            " "                       FORMAT "x(10)"        AT 113   /* Numero da Autorizacao do Transporte */
            v-comcode-cli             FORMAT "x(3)"         AT 123   /* Codigo da Fabrica Transmissora */
            " "                       FORMAT "x(3)"         AT 126   /* Espaáos */
            .

        ASSIGN i-segmentos = i-segmentos + 1 .


        FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK :


            FIND natur-oper  OF it-nota-fisc NO-LOCK NO-ERROR .
            FIND ITEM WHERE ITEM.it-codigo EQ it-nota-fisc.it-codigo NO-LOCK NO-ERROR .

            FIND item-cli WHERE item-cli.it-codigo  EQ it-nota-fisc.it-codigo
                          AND   item-cli.nome-abrev EQ nota-fiscal.nome-ab-cli
                          NO-LOCK NO-ERROR .

            IF AVAIL item-cli THEN ASSIGN c-it-codigo = item-cli.item-do-cli .
            ELSE ASSIGN c-it-codigo =  ITEM.it-codigo .


            /*  Caso seja a VW, sera reconstruida a codificaá∆o do Item */
            ASSIGN c-tipo-fornec = " " .
            IF  t-nf-edi.cod-parceiro-edi EQ 200005 THEN DO : 

                ASSIGN c-tipo-fornec = "P" .

                ASSIGN 
                    c-mod = ""
                    c-cod = ""
                    c-cor = "" .

                IF LENGTH(c-it-codigo) GT 11 THEN DO:
                    ASSIGN 
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , IF (LENGTH (c-it-codigo) - 6) GT 0 THEN (LENGTH (c-it-codigo) - 6) ELSE 0  ) 
                        c-cod = c-cod + FILL( " " , 8 - LENGTH( TRIM(c-cod) ) )
                        c-cor = SUBSTRING(c-it-codigo , IF (LENGTH (c-it-codigo) - 2) GT 1 THEN (LENGTH (c-it-codigo) - 2) ELSE 1 , 3 )  .
                END.
                ELSE DO:
                    ASSIGN
                        c-mod = SUBSTRING(c-it-codigo , 1 , 3)  + "   " 
                        c-cod = SUBSTRING(c-it-codigo , 4 , LENGTH(c-it-codigo ) ) .
                END.

                ASSIGN 
                    c-it-codigo = c-mod + c-cod + c-cor .

            END.

            IF t-nf-edi.cod-parceiro-edi EQ 200002  THEN DO:
                IF c-fabrica EQ "05" THEN ASSIGN c-tipo-fornec = "P" .
                IF c-fabrica EQ "30" THEN ASSIGN c-tipo-fornec = "R" .
                IF c-fabrica EQ "35" THEN ASSIGN c-tipo-fornec = "R" .
                IF c-fabrica EQ "50" THEN ASSIGN c-tipo-fornec = "E" .
            END.


            IF tt-param.conc             EQ YES AND 
               tt-param.cliente-ini      EQ 0   AND 
               t-nf-edi.cod-parceiro-edi EQ 200005 THEN DO:  /* DSH */
                ASSIGN c-tipo-fornec = "D" .
            END.

            ASSIGN c-sit-trib = TRIM(STRING(ITEM.codigo-orig)) + TRIM(STRING(it-nota-fisc.cd-trib-icm)) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (it-nota-fisc.nr-pedcli , "." , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "," , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "-" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "/" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , "'" , "" ) .
            ASSIGN c-ped-lin-vw-ford = REPLACE (c-ped-lin-vw-ford , ";" , "" ) .


            PUT STREAM edi UNFORMATTED
                "CPS"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
                STRING( it-nota-fisc.nr-seq-fat, "9999" )       AT 004   /* Numero Sequencial do Item */
                " "                       FORMAT "x(121)"       AT 008   /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .

            ASSIGN de-qt-entrega = 0 .
            FOR EACH b-it-nota-fisc WHERE b-it-nota-fisc.it-codigo   EQ it-nota-fisc.it-codigo
                                    AND   b-it-nota-fisc.nome-ab-cli EQ it-nota-fisc.nome-ab-cli 
                                    AND   b-it-nota-fisc.dt-emis     GE 01/01/2011
                                    AND   b-it-nota-fisc.dt-cancela  EQ ? 
                                    AND   b-it-nota-fisc.emite-dup   EQ YES
                                    NO-LOCK :

                ASSIGN de-qt-entrega = de-qt-entrega + b-it-nota-fisc.qt-faturada[1] .

            END.


            PUT STREAM edi UNFORMATTED
                "LIN"                     FORMAT "x(03)"        AT 001   /* Identificaá∆o do tipo de Segmento    */
                c-it-codigo               FORMAT "x(30)"        AT 004   /* Codigo do Item */
                INT( de-qt-entrega ) * 1000  
                FORMAT "999999999999"                           AT 034   /* Quantidade Acumulada Embarcada */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) FORMAT "x(3)"         AT 046   /* Unidade de medida qtde acumulada */
                INT( it-nota-fisc.qt-faturada[1] ) * 1000  
                FORMAT "999999999999"                           AT 049   /* Quantidade Embarcada */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) FORMAT "x(3)"         AT 061   /* Unidade de medida qtde acumulada */
                c-ped-lin-vw-ford         FORMAT "x(30)"        AT 064   /* Numero do pedido */
                STRING(YEAR(TODAY))       FORMAT "x(4)"         AT 094   /* Ano/Modelo de registro */
                "BR"                      FORMAT "x(2)"         AT 098   /* Codigo do Pais de Origem */
                c-tipo-fornec             FORMAT "x(1)"         AT 100   /* Codigo do tipo de fornecimento */
                IF INT(it-nota-fisc.peso-liq) LE 0 THEN    "000000000001" ELSE 
                STRING(INT( it-nota-fisc.peso-liq * 1000), "999999999999") AT 101   /* Peso Liquido do Item */
                CAPS(fn-free-accent(it-nota-fisc.un[1])) 
                FORMAT "x(3)"                                   AT 113   /* Unidade de Medida do Item */
                " "                       FORMAT "x(13)"        AT 116   /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            PUT STREAM edi UNFORMATTED
                "FA2"                                FORMAT "x(03)"          AT 001  /* Identificaá∆o do tipo de Segmento    */
                INT(it-nota-fisc.vl-preuni * 100000) FORMAT  "999999999999"  AT 004  /* Valor Liquido do Item */
                c-sit-trib                           FORMAT "x(02)"          AT 016  /* Cod.Situacao Trib */
                it-nota-fisc.class-fiscal            FORMAT  "0099999999"    AT 018  /* Classificao Fiscal */
                ( IF it-nota-fisc.cd-trib-ipi NE 3 THEN ( it-nota-fisc.aliquota-ipi * 100 )  ELSE 0 ) FORMAT "9999"  AT 028  /* Aliquota de Ipi */
                (IF it-nota-fisc.vl-icms-it EQ 0 THEN  0 
                 ELSE  INT(it-nota-fisc.aliquota-icm * 100)) FORMAT "9999"  AT 032  /* Aliquota Icms */
                it-nota-fisc.vl-bicms-it * 100       FORMAT "999999999999"  AT 036  /* Base Calc ICMS */
                IF it-nota-fisc.cd-trib-icm EQ 1 THEN 
                   INT(it-nota-fisc.vl-icms-it * 100) 
                ELSE 0 FORMAT "999999999999"                                AT 048  /* Valor Icms Item */
                IF it-nota-fisc.cd-trib-ipi EQ 1 THEN 
                   INT(it-nota-fisc.vl-ipi-it  * 100) 
                ELSE 0 FORMAT "999999999999"                                AT 060  /* Valor Ipi Item */
                5                                    FORMAT "9"             AT 072  /* Multiplicador de preáo unitario  */
                INT( it-nota-fisc.vl-tot-item * 100 ) FORMAT "999999999999"  AT 073  /* Preco Total da Mercadoria */ 
                IF ( it-nota-fisc.vl-desconto NE 0 AND 
                    it-nota-fisc.vl-bicms-it   NE 0 ) THEN
                    INT(it-nota-fisc.vl-desconto / it-nota-fisc.vl-bicms-it ) * 100                           
                    ELSE 0 FORMAT "9999"                                    AT 085  /* Percentual de desconto */
                INT(it-nota-fisc.vl-desconto * 100) FORMAT "99999999999"    AT 089  /* Vl. Desconto do Item */
                0                                   FORMAT "999999999999"   AT 100  /* Valor Desconto do ICMS item */
                SUBSTRING(natur-oper.char-1 , 45 , 5 ) FORMAT "x(5)"        AT 112  /* CFO por Item */ 
                IF INT(it-nota-fisc.peso-brut) LE 0 THEN "00001" ELSE 
                STRING(INT( it-nota-fisc.peso-brut), "99999")                AT 117   /* Peso Bruto do Item */
                " "                                 FORMAT "x(7)"           AT 122  /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            PUT STREAM edi UNFORMATTED
                "FA3"                                       FORMAT "x(03)"             AT 001   /* Identificaá∆o do tipo de Segmento    */
                c-it-codigo                                 FORMAT "x(30)"             AT 004   /* Codigo do Item */
                INT( it-nota-fisc.qt-faturada[1] ) * 1000   FORMAT "999999999"         AT 034   /* Qtde Faturada */
                "UN"                                        FORMAT "x(2)"              AT 043   /* Unidade de medida qtde acumulada */                                                    
                " "                                         FORMAT "x(30)"             AT 045   /* Numero do Desenho */
                " "                                         FORMAT "x(8)"              AT 075   /* Data de Validade do Desenho */
                " "                                         FORMAT "x(4)"              AT 083   /* Alteracao tecnica do Item */
                c-ped-lin-vw-ford                           FORMAT "x(13)"             AT 087   /* Numero do pedido */
                " "                                         FORMAT "x(17)"             AT 100   /* Numero do Chassi */
                " "                                         FORMAT "x(4)"              AT 117   /* Identificador do Modulo */
                " "                                         FORMAT "x(1)"              AT 121   /* Identificador da Chamada */
                " "                                         FORMAT "x(7)"              AT 122   /* Identificador da Chamada */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .



            PUT STREAM edi UNFORMATTED
                "FA5"                                       FORMAT "x(03)"             AT 001  /* Identificaá∆o do tipo de Segmento    */
                INT ( it-nota-fisc.qt-faturada[1] * 1000 )  FORMAT "999999999"         AT 004
                SUBSTRING(c-sit-trib , 1 , 1 )              FORMAT "x(1)"              AT 013
                INT ( it-nota-fisc.vl-bsubs-it  * 100 )     FORMAT "99999999999999999" AT 014   
                INT ( it-nota-fisc.vl-icmsub-it * 100 )     FORMAT "99999999999999999" AT 031   
                INT ( ROUND( it-nota-fisc.vl-merc-liq * ( DEC( SUBSTRING(it-nota-fisc.char-2, 76 , 5 ) ) / 100 ) , 2 ) * 100  )    FORMAT "99999999999999999" AT 048
                INT ( ROUND( it-nota-fisc.vl-merc-liq * ( DEC( SUBSTRING(it-nota-fisc.char-2, 81 , 5 ) ) / 100 ) , 2 ) * 100  )    FORMAT "99999999999999999" AT 065
                " "                                         FORMAT "x(47)"             AT 082  /* Espaáos */
                .

            ASSIGN i-segmentos = i-segmentos + 1 .


            CREATE tt-log-conf.
            ASSIGN 
                tt-log-conf.cod-estabel  = nota-fiscal.cod-estabel
                tt-log-conf.serie        = nota-fiscal.serie
                tt-log-conf.nr-nota-fis  = nota-fiscal.nr-nota-fis
                tt-log-conf.nr-seq-fat   = it-nota-fisc.nr-seq-fat
                tt-log-conf.it-codigo    = it-nota-fisc.it-codigo
                tt-log-conf.dt-emissao   = nota-fiscal.dt-emis-nota
                tt-log-conf.nr-pedcli    = it-nota-fisc.nr-pedcli
                tt-log-conf.nome-abrev   = nota-fiscal.nome-ab-cli
                tt-log-conf.nat-operacao = nota-fiscal.nat-operacao
                tt-log-conf.valor-icms   = de-tot-icms
                tt-log-conf.valor-ipi    = nota-fiscal.vl-tot-ipi
                tt-log-conf.Valor-tot    = nota-fiscal.vl-tot-nota .

            ASSIGN v_log_gerou_mov = TRUE .


        END.


        ASSIGN i-segmentos = i-segmentos + 1 .

        PUT STREAM edi UNFORMATTED
            "FTP"                     FORMAT "x(03)"             AT 001   /* Identificaá∆o do tipo de Segmento    */
            STRING( CURRENT-VALUE(msgid) , "99999" )             AT 004   /* Numero de Controle do Movimento */
            i-segmentos               FORMAT "999999999"         AT 009   /* Quantidade de Segmentos */  
            0                         FORMAT "99999999999999999" AT 018   /* Numero total de Valores */
            " "                       FORMAT "x(1)"              AT 035   /* Categoria da Operacao */
            " "                       FORMAT "x(93)"             AT 036   /* Espaáos */
            .

        NEXT-VALUE(msgid) .


        IF LAST-OF (t-nf-edi.cod-parceiro-edi)  THEN DO:
            OUTPUT STREAM edi CLOSE .
        END.

        /*
        ELSE DO:
            /* Para o parceiro 200002-Ford, e 200005-VW , devera ser gerado varios avisos em um £nico arquivo */
            IF t-nf-edi.cod-parceiro NE 200002 AND  
               t-nf-edi.cod-parceiro NE 200005 THEN DO:
                OUTPUT STREAM edi CLOSE .
            END.
        END.
        */

        FIND es-nota-fis OF nota-fiscal NO-ERROR .
        IF NOT AVAIL(es-nota-fiscal) THEN DO :
           CREATE es-nota-fiscal.
           ASSIGN 
               es-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
               es-nota-fiscal.serie       = nota-fiscal.serie
               es-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
               es-nota-fiscal.ep-codigo   = param-global.empresa-prin .
        END .

        ASSIGN  
            es-nota-fiscal.dt-envio  = TODAY 
            es-nota-fiscal.hr-envio  = STRING(TIME,"HH:MM:SS") 
            es-nota-fiscal.cod-usuar = v_cod_usuar_corren 
            es-nota-fiscal.aviso-emb = YES .


        FIND es-deljit OF nota-fiscal NO-ERROR .
        IF AVAIL es-deljit THEN ASSIGN es-deljit.l-atualizado   = YES .

        DELETE t-nf-edi . 

    END.

END.


/*------------- Fim Programa ---------------------------------------------*/




