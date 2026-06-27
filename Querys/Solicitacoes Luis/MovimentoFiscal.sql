select * from 

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
  where numerodocumentoinicial in ('000032822','000032821','000010615','000180459','000180460','000227','000000000180460')) as mov
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