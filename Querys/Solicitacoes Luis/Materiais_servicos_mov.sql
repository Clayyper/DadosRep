select * from 
(SELECT [idmovimento]     
      ,[tipomovimento]
      ,[numeromovimento]
      ,[numerodocumentoinicial]
      ,[dataemissao]
  FROM [NG_ADM].[dbo].[adm_movimento]
  where dataemissao between '20130201' and '20130228') as mov
  inner join
	(SELECT [idmovimento]
		  ,[idcf]		  
	  FROM [NG_ADM].[dbo].[adm_documentofiscal]) as docfis 
  on docfis.idmovimento=mov.idmovimento
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
	  (select a.idmovimento,b.codigoitem,b.descricaoitem,cfitem.idcf,cfitem.CFOP 
	from 
		(SELECT [idmovimento]
			  ,[iditem]
			  ,[idcfop]
		 FROM [NG_ADM].[dbo].[adm_documentofiscalmercadoriaservico]) as a
	 inner join
		(select iditem,codigoitem,descricaoitem from NG_Estoque..est_item)as b 
	 on a.iditem=b.iditem
	 inner join
		 (select b.idcf,str(a.codigotipooperacaocf,1)+'.'+str(b.codigocf,3)as CFOP from
					(SELECT [idtipooperacaocf]
						  ,[codigotipooperacaocf]
					FROM [NG_Dominio].[dbo].[dom_tipooperacaocf]) as a
				inner join
					(SELECT [idcf],[idtipooperacaocf],[codigocf]      
					  FROM [NG_Dominio].[dbo].[dom_cf])as b 
				on a.idtipooperacaocf=b.idtipooperacaocf)as cfitem
	 on cfitem.idcf=a.idcfop) as itemcfop
 on itemcfop.idmovimento=mov.idmovimento and itemcfop.idcf<>cf.idcf
 