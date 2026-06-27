select IT.iditem,IT.codigoitem,IT.descricaoitem,un.descricaounidademedida,ITMAT.fatorconversao,ORI.descricaoorigemregistro,
case when IT.indativo=1 then 'ATIVO' else 'INATIVO' end as Ativo,SITMER.descricaosituacaomercadoria,IT.idtipoitem,ITTIPO.descricaotipomercadoria,
IT.precovenda,ITFIS.ncm,CATMER.descricaocategoriamercadoria,codigomercadoriaexterno,
case when ITMAT.inditeminventariado=1 then 'SIM' else 'NAO' end as Inventariado,IT.descricaocompleta,
 ICMS.*,PIS.*,COFINS.*,IPI.*,ISS.*,CSLL.*
		from NG_Estoque..est_item as IT
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_ICMS,
		 aa.percentualbasecalculo as PercTCalculo_ICMS,
		 aa.percentualaliquota as PercTAli_ICMS,
		 aa.tipomovimento  as TP_ICMS
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 8)as ICMS on IT.iditem=ICMS.iditem
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_PIS,
		 aa.percentualbasecalculo as PercTCalculo_PIS,
		 aa.percentualaliquota as PercTAli_PIS,
		 aa.tipomovimento  as TP_PIS
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 5)as PIS on IT.iditem=PIS.iditem
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_COFINS,
		 aa.percentualbasecalculo as PercTCalculo_COFINS,
		 aa.percentualaliquota as PercTAli_COFINS,
		 aa.tipomovimento  as TP_COFINS
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 6)as COFINS on IT.iditem=COFINS.iditem
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_IPI,
		 aa.percentualbasecalculo as PercTCalculo_IPI,
		 aa.percentualaliquota as PercTAli_IPI,
		 aa.tipomovimento  as TP_IPI
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 3)as IPI on IT.iditem=IPI.iditem
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_ISS,
		 aa.percentualbasecalculo as PercTCalculo_ISS,
		 aa.percentualaliquota as PercTAli_ISS,
		 aa.tipomovimento  as TP_ISS
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 10)as ISS on IT.iditem=ISS.iditem
left join
		(select aa.iditem,
		 aa.descricaosituacaotributaria  as DescTrib_CSLL,
		 aa.percentualbasecalculo as PercTCalculo_CSLL,
		 aa.percentualaliquota as PercTAli_CSLL,
		 aa.tipomovimento  as TP_CSLL
		 from
		(select a.iditem,d.idgrupotributo,d.descricaogrupotributo,e.descricaosituacaotributaria,a.percentualbasecalculo,a.percentualaliquota,a.tipomovimento FROM [NG_Estoque].[dbo].[est_itemimpostos] as a
		inner join 
		(select idtributo,idsituacaotributariaportributo,idsituacaotributaria from [NG_Dominio]..[dom_situacaotributariaportributo] )as b on a.idsituacaotributariaportributo=b.idsituacaotributariaportributo
		inner join
		(select idtributo,idgrupotributo from [NG_Dominio]..[dom_tributo]) as c on b.idtributo=c.idtributo
		inner join 
		(select idgrupotributo,descricaogrupotributo from [NG_Dominio]..[dom_grupotributo])as d on c.idgrupotributo=d.idgrupotributo
		inner join 
		(select idsituacaotributaria,descricaosituacaotributaria from [NG_Dominio]..[dom_situacaotributaria]) as e on b.idsituacaotributaria=e.idsituacaotributaria
		/*where a.iditem=17088*/ )as aa
		where aa.idgrupotributo= 4)as CSLL on IT.iditem=CSLL.iditem
left join
		(select * from [NG_Estoque]..[est_unidademedida])as un on IT.idunidademedida=un.idunidademedida
left join 
		(select * from [NG_Estoque]..[est_itemmaterial]) as ITMAT on IT.iditem=ITMAT.iditem
left join
		(select * from [NG_Dominio]..[dom_origemregistro]) as ORI on IT.idorigemregistro=ORI.idorigemregistro
left join
		(select * from [NG_Estoque].[dbo].[est_itemdadosfiscais])as ITFIS on IT.iditem=ITFIS.iditem
left join
		(select * from NG_Dominio..dom_categoriamercadoria)as CATMER on ITFIS.idcategoriamercadoria=CATMER.idcategoriamercadoria
left join
		(select * from [NG_Dominio]..[dom_tipomercadoria])as ITTIPO on IT.idtipoitem=ITTIPO.idtipomercadoria
left join
		(select * from NG_Dominio..dom_situacaomercadoria) as SITMER on ITFIS.idsituacaomercadoria=SITMER.idsituacaomercadoria		
where IT.iditem=17088