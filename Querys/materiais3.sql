select IT.codigoitem as [Código],IT.descricaoitem as [Descrição],un.descricaounidademedida as [Unidade Medida],
ITMAT.fatorconversao as [Fator Conversão],FAM.descricaofamilia as [Familia],ITMAT.pesobruto as [Peso Bruto],ITMAT.pesoliquido as [Peso Liquido],
ITMAT.quantidadeembalagem as [Quantidade Embalagem],CONVERT(varchar(10), IT.datahoralog, 103)as [Ultima Atualização],
case when ITMAT.indfracionado=1 then 'SIM' else 'NÃO' end as [Quantidade Fracionada], ORI.descricaoorigemregistro as [Origem do Registro],
APROENTRADA.codigoestruturado as [Cód. CCusto Ent.],APROENTRADA.descricaocentrocusto as [Descrição CCusto Ent.],
APROENTRADA.codigoestruturadocontagerencial as [Cód. CGerencial Ent.],APROENTRADA.descricaocontagerencial as [Descrição CGerencial Ent.],
APROSAIDA.codigoestruturado as [Cód. CCusto Said.],APROSAIDA.descricaocentrocusto as [Descrição CCusto Said.],
APROSAIDA.codigoestruturadocontagerencial as [Cód. CGerencial Said.],APROSAIDA.descricaocontagerencial as [Descrição CGerencial Said.],
case when IT.indativo=1 then 'ATIVO' else 'INATIVO' end as Ativo,SITMER.descricaosituacaomercadoria as [Situação Mercadoria],
ITTIPO.descricaotipomercadoria as [Tipo Mercadoria],IT.precovenda as [Preço Venda],ITFIS.ncm as NCM,
CATMER.descricaocategoriamercadoria as [Categoria Mercadoria],codigomercadoriaexterno as [Codigo Externo],
case when ITMAT.inditeminventariado=1 then 'SIM' else 'NAO' end as Inventariado,IT.descricaocompleta as [TAG],
ICMS.DescTrib_ICMS as[Situação Tributária ICMS],ICMS.PercTCalculo_ICMS as[Base de Cálculo % ICMS],ICMS.PercTAli_ICMS as[Alíquota % ICMS],ICMS.TP_ICMS as[Tipo Movimento ICMS],
PIS.DescTrib_PIS as[Situação Tributária PIS],PIS.PercTCalculo_PIS as[Base de Cálculo % PIS],PIS.PercTAli_PIS as[Alíquota % PIS],PIS.TP_PIS as[Tipo Movimento PIS],
COFINS.DescTrib_COFINS as[Situação Tributária COFINS],COFINS.PercTCalculo_COFINS as[Base de Cálculo % COFINS],COFINS.PercTAli_COFINS as[Alíquota % COFINS],COFINS.TP_COFINS as[Tipo Movimento COFINS],
IPI.DescTrib_IPI as[Situação Tributária IPI],IPI.PercTCalculo_IPI as[Base de Cálculo % IPI],IPI.PercTAli_IPI as[Alíquota % IPI],IPI.TP_IPI as[Tipo Movimento IPI],
ISS.DescTrib_ISS as[Situação Tributária ISS],ISS.PercTCalculo_ISS as[Base de Cálculo % ISS],ISS.PercTAli_ISS as[Alíquota % ISS],ISS.TP_ISS as[Tipo Movimento ISS],
CSLL.DescTrib_CSLL as[Situação Tributária CSLL],CSLL.PercTCalculo_CSLL as[Base de Cálculo % CSLL],CSLL.PercTAli_CSLL as[Alíquota % CSLL],CSLL.TP_CSLL as[Tipo Movimento CSLL]
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
left join 
		(select * from [NG_Estoque]..[est_familia]) as FAM on FAM.idfamilia=IT.idfamilia
left join
		(select contEnt.iditem,centCust.codigoestruturado,centCust.descricaocentrocusto,contGer.codigoestruturadocontagerencial,contGer.descricaocontagerencial from 
					 (SELECT [iditem] ,[idcontagerencial] ,[idcentrocusto] FROM [NG_Estoque].[dbo].[est_itemapropriacaogerencial] where indapropriacaoentrada=1) as contEnt
			left join(select idcentrocusto,codigoestruturado,descricaocentrocusto from [NG].[dbo].[bpm_centrocusto]) as centCust on centCust.idcentrocusto=contEnt.idcentrocusto
			left join(select idcontagerencial,codigoestruturadocontagerencial,descricaocontagerencial from [NG].[dbo].[bpm_contagerencial]) as contGer on contGer.idcontagerencial=contEnt.idcontagerencial
		) as APROENTRADA on APROENTRADA.iditem=IT.iditem
left join
		(select contEnt.iditem,centCust.codigoestruturado,centCust.descricaocentrocusto,contGer.codigoestruturadocontagerencial,contGer.descricaocontagerencial from 
					 (SELECT [iditem] ,[idcontagerencial] ,[idcentrocusto] FROM [NG_Estoque].[dbo].[est_itemapropriacaogerencial] where indapropriacaosaida=1) as contEnt
			left join(select idcentrocusto,codigoestruturado,descricaocentrocusto from [NG].[dbo].[bpm_centrocusto]) as centCust on centCust.idcentrocusto=contEnt.idcentrocusto
			left join(select idcontagerencial,codigoestruturadocontagerencial,descricaocontagerencial from [NG].[dbo].[bpm_contagerencial]) as contGer on contGer.idcontagerencial=contEnt.idcontagerencial
		) as APROSAIDA on APROSAIDA.iditem=IT.iditem				
