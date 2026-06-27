select mov.numeromovimento as [N° Movimento],mov.numerodocumentoinicial as [N° Documento],
case when mov.tipomovimento='E' then 'Entrada'else 'Saida' end as [Tipo Movimento],p1.nomepessoa as [Filial],
p2.nomepessoa as [Cliente/Fornecedor],CAST(day(mov.dataemissao) as varchar(2))+'/'+CAST(month(mov.dataemissao) as varchar(2))+'/'+CAST(year(mov.dataemissao) as varchar(6)) as [Data Emissão],
mov.valormovimento as [Valor],tipopag.descricaotipocondicaopagamento as [Condição Pagamento],cf.CFOP as [CFOP Cabeçalho],cfpar.subcodigo as[SubCod Cabeçalho],cfpar.descricaosubcodigo as [Descrição SubCod Cab],
cfit.CFOP as [CFOP Itens Fiscais],cfsubcod.subcodigo as [Codigo SubCOdigo Contab],cfsubcod.descricaocontabilizacaosubcodigo as [Descrição Cod SubCod Contab]
from 
(SELECT [idmovimento]     
      ,[idpessoaempresa]--FILIAL     
      ,[idpessoaclientefornecedor]--CLIENTE/FORNECEDOR
      ,[tipomovimento]
      ,[numeromovimento]
      ,[numerodocumentoinicial]
      ,[dataemissao]
      ,[valormovimento]  
      ,idcondicaopagamento        
  FROM [NG_ADM].[dbo].[adm_movimento]
  where dataemissao between '20130201' and '20130228') as mov
  inner join 
  (SELECT [idmovimento] ,[idtipocondicaopagamento]      
	FROM [NG_ADM].[dbo].[adm_dadosfiscal]) as dfis 
  on dfis.idmovimento=mov.idmovimento
  inner join
	(SELECT [idmovimento]
		  ,[idcf]
		  ,[idcfparametro]
	  FROM [NG_ADM].[dbo].[adm_documentofiscal]) as docfis 
  on docfis.idmovimento=mov.idmovimento
  inner join
	(SELECT [idmovimento],[idcfop],[idcfcontabilizacaosubcodigo]
			FROM [NG_ADM].[dbo].[adm_documentofiscalitens])as docfisit 
  on docfisit.idmovimento=mov.idmovimento
  inner join
	(select idpessoa,nomepessoa from ng..bpm_pessoa) as p1 
  on p1.idpessoa=mov.idpessoaempresa
  inner join
	(select idpessoa,nomepessoa from ng..bpm_pessoa) as p2 
  on p2.idpessoa=mov.idpessoaclientefornecedor
  inner join
	(select b.idcf,str(a.codigotipooperacaocf,1)+'.'+str(b.codigocf,3)as CFOP from
			(SELECT [idtipooperacaocf]
				  ,[codigotipooperacaocf]
			FROM [NG_Dominio].[dbo].[dom_tipooperacaocf]) as a
		inner join
			(SELECT [idcf],[idtipooperacaocf],[codigocf]      
			  FROM [NG_Dominio].[dbo].[dom_cf])as b 
		on a.idtipooperacaocf=b.idtipooperacaocf)as cf 
  on cf.idcf=docfis.idcf
  inner join
  (SELECT [idcfparametro],[subcodigo],[descricaosubcodigo]      
  FROM [NG_ADM].[dbo].[adm_cfparametro])as cfpar on cfpar.idcfparametro=docfis.idcfparametro
  inner join
  (select b.idcf,str(a.codigotipooperacaocf,1)+'.'+str(b.codigocf,3)as CFOP from
			(SELECT [idtipooperacaocf]
				  ,[codigotipooperacaocf]
			FROM [NG_Dominio].[dbo].[dom_tipooperacaocf]) as a
		inner join
			(SELECT [idcf],[idtipooperacaocf],[codigocf]      
			  FROM [NG_Dominio].[dbo].[dom_cf])as b 
		on a.idtipooperacaocf=b.idtipooperacaocf)as cfit 
  on cfit.idcf=docfisit.idcfop
  left join
  (SELECT [idcfcontabilizacaosubcodigo],[descricaocontabilizacaosubcodigo],[subcodigo]      
  FROM [NG_ADM].[dbo].[adm_cfcontabilizacaosubcodigo]) as cfsubcod 
  on cfsubcod.idcfcontabilizacaosubcodigo=docfisit.idcfcontabilizacaosubcodigo
  inner join
  (SELECT [idtipocondicaopagamento],[descricaotipocondicaopagamento]     
  FROM [NG_Dominio].[dbo].[dom_tipocondicaopagamento]) as tipopag
  on tipopag.idtipocondicaopagamento=dfis.idtipocondicaopagamento