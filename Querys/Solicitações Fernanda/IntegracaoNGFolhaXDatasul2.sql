WITH LancamentoContabilFolha_cte AS (
 SELECT DISTINCT 
       NG_Contabil.dbo.ctb_movimentocontabil.codigo,
       CASE NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil
            WHEN 1 THEN 'Folha de Pagamento / '+NG_Dominio.dbo.dom_folhatipo.descricaofolhatipo
            WHEN 2 THEN 'Provisão de Férias'
            WHEN 3 THEN 'Provisão de 13º Salário'
       END AS descricaolancamentocontabil,
       NG_Contabil.dbo.ctb_movimentocontabil.datamovimento,
       CASE NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil
         WHEN 2 THEN 'Item de Contabilização'
            WHEN 3 THEN 'Funcionário'
            WHEN 4 THEN 'Departamento'
            WHEN 5 THEN 'Centro de Custo'
            WHEN 6 THEN 'Centro de Resultado'
            WHEN 7 THEN 'Unidade Administrativa'
       END AS agrupamento,
       CASE NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil
            WHEN 3 THEN NG_Folha.dbo.flh_registro.codigoregistro+' - '+pr.nomepessoa
            WHEN 4 THEN NG_RH.dbo.rh_departamento.codigodepartamento+' - '+NG_RH.dbo.rh_departamento.descricaodepartamento
            WHEN 5 THEN NG.dbo.bpm_centrocusto.codigocentrocusto+' - '+NG.dbo.bpm_centrocusto.descricaocentrocusto
            WHEN 6 THEN NG.dbo.bpm_centroresultado.codigo+' - '+ISNULL(NG.dbo.bpm_centroresultado.descricao,'Centro de Resultado')
            WHEN 7 THEN NG.dbo.bpm_unidadeadministrativa.codigounidadeadministrativa+' - '+NG.dbo.bpm_unidadeadministrativa.descricaounidadeadministrativa
       END AS descricaoagrupamentocontabil,
       NG.dbo.bpm_centrocusto.codigoestruturado,
       NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao,
       CASE WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 1     THEN NG_Folha.dbo.flh_verba.codigoverba+' - '+NG_Folha.dbo.flh_verba.descricaoverba
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 2     THEN NG_Folha.dbo.flh_base.codigobase+' - '+NG_Folha.dbo.flh_base.descricaobase
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 5     THEN '9999 - Líquido de Rescisão'
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao IN(3,4) THEN NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.codigoitemcontabilizacaofolhapagamento+' - '+NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.descricaoitemcontabilizacaofolhapagamento
       END AS descricaoitemcontabilizacao,
       NG_Contabil.dbo.ctb_movimentocontabil.valor AS valormovimento,
       NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil,
       NG_Contabil.dbo.ctb_movimentocontabilitens.valor AS valoritem,
       CASE WHEN NG_Contabil.dbo.ctb_movimentocontabilitens.naturezaitem = 'C'
            THEN NG_Contabil.dbo.ctb_contacontabil.codcompletoconta
       END contacredito,
       CASE WHEN NG_Contabil.dbo.ctb_movimentocontabilitens.naturezaitem = 'D'
            THEN NG_Contabil.dbo.ctb_contacontabil.codcompletoconta
       END contadebito,
       NG_Contabil.dbo.ctb_movimentocontabilitens.descricaohistorico,
       NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabilitens
FROM NG_Contabil.dbo.ctb_movimentocontabil
     INNER JOIN NG_Contabil.dbo.ctb_movimentocontabilitens
                ON NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil = NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabil
     INNER JOIN NG_Contabil.dbo.ctb_contacontabil
                ON NG_Contabil.dbo.ctb_movimentocontabilitens.idcontacontabil = NG_Contabil.dbo.ctb_contacontabil.idcontacontabil
     INNER JOIN NG_Folha.dbo.flh_movimentocontabildetalhe
                ON NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil = NG_Folha.dbo.flh_movimentocontabildetalhe.idmovimentocontabil AND
                   NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabilitens = NG_Folha.dbo.flh_movimentocontabildetalhe.idmovimentocontabilitens
     LEFT  JOIN NG_Dominio.dbo.dom_folhatipo
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil = 1 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idtipofolha = NG_Dominio.dbo.dom_folhatipo.idtipofolha
     LEFT  JOIN NG_Folha.dbo.flh_verba
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 1 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Folha.dbo.flh_verba.idverba
     LEFT  JOIN NG_Folha.dbo.flh_base
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 2 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Folha.dbo.flh_base.idbase
     LEFT  JOIN NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao IN(3,4) AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.iditemcontabilizacaofolhapagamento
     LEFT  JOIN NG_Folha.dbo.flh_registro
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 3 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idregistro = NG_Folha.dbo.flh_registro.idregistro
     LEFT  JOIN NG.dbo.bpm_pessoa pr
                ON NG_Folha.dbo.flh_registro.idpessoaregistro = pr.idpessoa
     LEFT  JOIN NG_RH.dbo.rh_departamento
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 4 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iddepartamento = NG_RH.dbo.rh_departamento.iddepartamento
     LEFT  JOIN NG.dbo.bpm_centrocusto
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 5 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idcentrocusto = NG.dbo.bpm_centrocusto.idcentrocusto
     LEFT  JOIN NG.dbo.bpm_centroresultado
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 6 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idcentroresultado = NG.dbo.bpm_centroresultado.idcentroresultado
     LEFT  JOIN NG.dbo.bpm_unidadeadministrativa
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 7 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idunidadeadministrativa = NG.dbo.bpm_unidadeadministrativa.idunidadeadministrativa
WHERE NG_Contabil.dbo.ctb_movimentocontabil.idowner = 12395 AND
      NG_Contabil.dbo.ctb_movimentocontabil.idconfiguracaoperiodo = 676 AND
      NG_Contabil.dbo.ctb_movimentocontabil.datamovimento BETWEEN '01/12/2013' AND '31/12/2013' AND
      NG_Contabil.dbo.ctb_movimentocontabil.tipolancamentointegracao = 'A' AND
      NG_Contabil.dbo.ctb_movimentocontabil.idcenario = -250 AND
      NG_Contabil.dbo.ctb_movimentocontabilitens.idpessoaempresa IN(12395) AND
    ( NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil = 1 AND
      NG_Folha.dbo.flh_movimentocontabildetalhe.idtipofolha >= 1    ) AND
      NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil <> 1
),
LancamentoUnicoContabilFolha_cte AS (
SELECT NG_Contabil.dbo.ctb_movimentocontabil.codigo,
       CASE NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil
            WHEN 1 THEN 'Folha de Pagamento / '+NG_Dominio.dbo.dom_folhatipo.descricaofolhatipo
            WHEN 2 THEN 'Provisão de Férias'
            WHEN 3 THEN 'Provisão de 13º Salário'
       END AS descricaolancamentocontabil,
       NG_Contabil.dbo.ctb_movimentocontabil.datamovimento,
       'Único' AS agrupamento,
       CAST(NULL AS varchar) AS descricaoagrupamentocontabil,
       cast(null as varchar) as codigoestruturado,
       NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao,
       CASE WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 1     THEN NG_Folha.dbo.flh_verba.codigoverba+' - '+NG_Folha.dbo.flh_verba.descricaoverba
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 2     THEN NG_Folha.dbo.flh_base.codigobase+' - '+NG_Folha.dbo.flh_base.descricaobase
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 5     THEN '9999 - Líquido de Rescisão'
            WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao IN(3,4) THEN NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.codigoitemcontabilizacaofolhapagamento+' - '+NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.descricaoitemcontabilizacaofolhapagamento
       END AS descricaoitemcontabilizacao,
       NG_Contabil.dbo.ctb_movimentocontabil.valor AS valormovimento,
       NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil,
       SUM(NG_Folha.dbo.flh_movimentocontabildetalhe.valor) AS valoritem,
       CASE WHEN NG_Contabil.dbo.ctb_movimentocontabilitens.naturezaitem = 'C'
            THEN NG_Contabil.dbo.ctb_contacontabil.codcompletoconta
       END contacredito,
       CASE WHEN NG_Contabil.dbo.ctb_movimentocontabilitens.naturezaitem = 'D'
            THEN NG_Contabil.dbo.ctb_contacontabil.codcompletoconta
       END contadebito,
       NG_Contabil.dbo.ctb_movimentocontabilitens.descricaohistorico,
       NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabilitens
FROM NG_Contabil.dbo.ctb_movimentocontabil
     INNER JOIN NG_Contabil.dbo.ctb_movimentocontabilitens
                ON NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil = NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabil
     INNER JOIN NG_Contabil.dbo.ctb_contacontabil
                ON NG_Contabil.dbo.ctb_movimentocontabilitens.idcontacontabil = NG_Contabil.dbo.ctb_contacontabil.idcontacontabil
     INNER JOIN NG_Folha.dbo.flh_movimentocontabildetalhe                ON NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil = NG_Folha.dbo.flh_movimentocontabildetalhe.idmovimentocontabil AND
                   NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabilitens = NG_Folha.dbo.flh_movimentocontabildetalhe.idmovimentocontabilitens
     LEFT  JOIN NG_Dominio.dbo.dom_folhatipo
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil = 1 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.idtipofolha = NG_Dominio.dbo.dom_folhatipo.idtipofolha
     LEFT  JOIN NG_Folha.dbo.flh_verba
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 1 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Folha.dbo.flh_verba.idverba
     LEFT  JOIN NG_Folha.dbo.flh_base
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 2 AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Folha.dbo.flh_base.idbase
     LEFT  JOIN NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento
                ON NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao IN(3,4) AND
                   NG_Folha.dbo.flh_movimentocontabildetalhe.iditemcontabilizacao = NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.iditemcontabilizacaofolhapagamento
WHERE NG_Contabil.dbo.ctb_movimentocontabil.idowner = 12395 AND
      NG_Contabil.dbo.ctb_movimentocontabil.idconfiguracaoperiodo = 676 AND
      NG_Contabil.dbo.ctb_movimentocontabil.datamovimento BETWEEN '01/12/2013' AND '31/12/2013' AND
      NG_Contabil.dbo.ctb_movimentocontabil.tipolancamentointegracao = 'A' AND
      NG_Contabil.dbo.ctb_movimentocontabil.idcenario = -250 AND
      NG_Contabil.dbo.ctb_movimentocontabilitens.idpessoaempresa IN(12395) AND
    ( NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil = 1 AND
      NG_Folha.dbo.flh_movimentocontabildetalhe.idtipofolha >= 1    ) AND
      NG_Folha.dbo.flh_movimentocontabildetalhe.idagrupamentocontabil = 1
GROUP BY NG_Contabil.dbo.ctb_movimentocontabil.codigo,
         NG_Contabil.dbo.ctb_movimentocontabil.datamovimento,
         NG_Folha.dbo.flh_movimentocontabildetalhe.idlancamentocontabil,
         NG_Dominio.dbo.dom_folhatipo.descricaofolhatipo,
         NG_Contabil.dbo.ctb_movimentocontabil.valor,
         NG_Contabil.dbo.ctb_movimentocontabil.idmovimentocontabil,
         NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao,
         CASE WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 1     THEN NG_Folha.dbo.flh_verba.codigoverba+' - '+NG_Folha.dbo.flh_verba.descricaoverba
              WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 2     THEN NG_Folha.dbo.flh_base.codigobase+' - '+NG_Folha.dbo.flh_base.descricaobase
              WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao = 5     THEN '9999 - Líquido de Rescisão'
              WHEN NG_Folha.dbo.flh_movimentocontabildetalhe.idtipoitemcontabilizacao IN(3,4) THEN NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.codigoitemcontabilizacaofolhapagamento+' - '+NG_Dominio.dbo.dom_itemcontabilizacaofolhapagamento.descricaoitemcontabilizacaofolhapagamento
         END,         NG_Contabil.dbo.ctb_contacontabil.codcompletoconta,
         NG_Contabil.dbo.ctb_movimentocontabilitens.naturezaitem,
         NG_Contabil.dbo.ctb_movimentocontabilitens.descricaohistorico,
         NG_Contabil.dbo.ctb_movimentocontabilitens.idmovimentocontabilitens
)SELECT 'FGL' as Modulo,'100' as Empresa,'1' Num_lote,'LANCAMENTO FOLHA' Desc_lote,CONVERT(varchar(10), datamovimento, 103) as [Data Lote],
	 '1' Num_lanc,CONVERT(varchar(10), datamovimento, 103) as [Data Lanc],
	 right('00000' + rtrim(ROW_NUMBER ( ) OVER(ORDER BY datamovimento  DESC)),5) as [Seq],
	 case when contacredito IS NULL then 'DB' else 'CR' end as Natureza,
	 'GERAL' AS [Plano Contas],
	 case when contacredito IS NULL 
		then 
			CASE WHEN REPLACE(contadebito,'.','')='3101020005' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3101020022' THEN '3201030044'
				 WHEN REPLACE(contadebito,'.','')='3102010002' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3102010014' THEN '3201030044'
				 WHEN REPLACE(contadebito,'.','')='3201010008' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3201010023' THEN '3201030044'
				 WHEN REPLACE(contadebito,'.','')='1201040001' THEN '1108010008'
				 WHEN REPLACE(contadebito,'.','')='2103050001' THEN '2103020007'
				 WHEN REPLACE(contadebito,'.','')='2103050002' THEN '2103020008'
				 WHEN REPLACE(contadebito,'.','')='2103050003' THEN '2103020009'
				 WHEN REPLACE(contadebito,'.','')='2102010404' THEN '2102010001'
				 ELSE REPLACE(contadebito,'.','') END
		else 
			 CASE WHEN REPLACE(contacredito,'.','')='3101020005' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3101020022' THEN '3201030044'
				 WHEN REPLACE(contacredito,'.','')='3102010002' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3102010014' THEN '3201030044'
				 WHEN REPLACE(contacredito,'.','')='3201010008' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3201010023' THEN '3201030044'
				 WHEN REPLACE(contacredito,'.','')='1201040001' THEN '1108010008'
				 WHEN REPLACE(contacredito,'.','')='2103050001' THEN '2103020007'
				 WHEN REPLACE(contacredito,'.','')='2103050002' THEN '2103020008'
				 WHEN REPLACE(contacredito,'.','')='2103050003' THEN '2103020009'
				 WHEN REPLACE(contacredito,'.','')='2102010404' THEN '2102010001'
				 ELSE REPLACE(contacredito,'.','') END
		end as [Conta Contab],
	 'ADLER' as [Plano CC],'101' as Estab,'ADL' as [Unid Neg],replace(codigoestruturado,'.','') as [Centro Custo],
	 'Real' as Moeda,REPLACE(valoritem,'.',',')as [Valor Lanc],
	 descricaohistorico + ' LANC REF NG N°:'+codigo AS [Histotico]
	 FROM LancamentoContabilFolha_cte 
	UNION
SELECT 'FGL' as Modulo,'100' as Empresa,'1' Num_lote,'LANCAMENTO FOLHA' Desc_lote,CONVERT(varchar(10), datamovimento, 103) as [Data Lote], 
	 '1' Num_lanc,CONVERT(varchar(10), datamovimento, 103) as [Data Lanc],
	 right('00000' + rtrim(ROW_NUMBER ( ) OVER(ORDER BY datamovimento  DESC)),5) as [Seq] ,
	 case when contacredito IS NULL then 'DB' else 'CR' end as Natureza,
	 'GERAL' AS [Plano Contas],
	 case when contacredito IS NULL 
		then 
			CASE WHEN REPLACE(contadebito,'.','')='3101020005' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3101020022' THEN '3201030044'
				 WHEN REPLACE(contadebito,'.','')='3102010002' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3102010014' THEN '3201030044'
				 WHEN REPLACE(contadebito,'.','')='3201010008' THEN '3201030014'
				 WHEN REPLACE(contadebito,'.','')='3201010023' THEN '3201030044'
				 ELSE REPLACE(contadebito,'.','') END
		else 
			 CASE WHEN REPLACE(contacredito,'.','')='3101020005' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3101020022' THEN '3201030044'
				 WHEN REPLACE(contacredito,'.','')='3102010002' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3102010014' THEN '3201030044'
				 WHEN REPLACE(contacredito,'.','')='3201010008' THEN '3201030014'
				 WHEN REPLACE(contacredito,'.','')='3201010023' THEN '3201030044'
				 ELSE REPLACE(contacredito,'.','') END
		end as [Conta Contab],
	 'ADLER' as [Plano CC],'101' as Estab,'ADL' as [Unid Neg],replace(codigoestruturado,'.','') as [Centro Custo],
	 'Real' as Moeda,REPLACE(valoritem,'.',',')as [Valor Lanc],
	 descricaohistorico + ' LANC REF NG N°:'+codigo AS [Histotico]
	 FROM LancamentoUnicoContabilFolha_cte