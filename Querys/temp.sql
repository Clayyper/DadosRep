select * from 
(SELECT [iditem] ,[idcontagerencial] ,[idcentrocusto]      
  FROM [NG_Estoque].[dbo].[est_itemapropriacaogerencial]
  where indapropriacaoentrada=1) as contEnt
left join(select idcentrocusto,codigoestruturado,descricaocentrocusto from [NG].[dbo].[bpm_centrocusto]) as centCust on centCust.idcentrocusto=contEnt.idcentrocusto
left join(select idcontagerencial,codigoestruturadocontagerencial,descricaocontagerencial from [NG].[dbo].[bpm_contagerencial]) as contGer on contGer.idcontagerencial=contEnt.idcontagerencial
GO


