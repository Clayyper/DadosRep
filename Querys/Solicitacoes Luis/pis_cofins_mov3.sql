select result.[N° Movimento],result.[Tipo Movimento],result.[N° Documento],result.[Data Emissão],result.[CFOP Materiais-Serviços],result.[Cod Item],result.[Descrição Item]
from
	(select final.[N° Movimento],final.[Tipo Movimento],final.[N° Documento],final.[Data Emissão],final.[CFOP Materiais-Serviços],final.[Cod Item],final.[Descrição Item],SUM(final.pis) as [PIS],SUM(final.cofins) as [COFINS] 
	from 
		(select mov.numeromovimento as[N° Movimento],case when mov.tipomovimento='E' then 'Entrada'else 'Saida' end as [Tipo Movimento],
		mov.numerodocumentoinicial as [N° Documento],CAST(day(mov.dataemissao) as varchar(2))+'/'+CAST(month(mov.dataemissao) as varchar(2))+'/'+CAST(year(mov.dataemissao) as varchar(6)) as [Data Emissão],
		cf.CFOP as [CFOP Cabecalho],itemcfop.CFOP as [CFOP Materiais-Serviços],itemcfop.codigoitem as [Cod Item],itemcfop.descricaoitem as [Descrição Item]
		,case when sittrib.idtributo=82 then 1 end as [pis],case when sittrib.idtributo=83 then 1 end as [cofins]
		from 
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
				on a.idtipooperacaocf=b.idtipooperacaocf
		where str(a.codigotipooperacaocf,1)+'.'+str(b.codigocf,3) 
		in ('1.101','2.101','1.124','1.407','1.102','2.102','2.407'))as cf 
		  on cf.idcf=docfis.idcf
		  inner join
			  (select a.idmovimento,b.codigoitem,b.descricaoitem,cfitem.idcf,cfitem.CFOP,a.iddocumentofiscalmercadoriaservico 
			from 
				(SELECT [idmovimento]
					  ,[iditem]
					  ,[idcfop]
					  ,[iddocumentofiscalmercadoriaservico]
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
		 on itemcfop.idmovimento=mov.idmovimento 
		 inner join
			 (SELECT [iddocumentofiscalmercadoriaservico]
				  ,[idsituacaotributariaportributo]    
			  FROM [NG_ADM].[dbo].[adm_impostosmercadoriaservico]) as impmer
		 on impmer.iddocumentofiscalmercadoriaservico=itemcfop.iddocumentofiscalmercadoriaservico 
		 inner join
			 (SELECT [idsituacaotributariaportributo]
				  ,[idtributo]      
			  FROM [NG_Dominio].[dbo].[dom_situacaotributariaportributo]
			  )as sittrib
		on sittrib.idsituacaotributariaportributo=impmer.idsituacaotributariaportributo)as final
	group by final.[N° Movimento],final.[Tipo Movimento],final.[N° Documento],final.[Data Emissão],final.[CFOP Materiais-Serviços],final.[Cod Item],final.[Descrição Item]) as result
	 
 where result.PIS is null or result.COFINS is null
 order by result.[N° Documento]