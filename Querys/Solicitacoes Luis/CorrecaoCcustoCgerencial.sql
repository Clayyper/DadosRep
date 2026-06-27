select * from NG_Estoque..est_item
where codigoitem>='100000' and codigoitem<='109999' and len(codigoitem)=6



SELECT [iditem] ,[idcontagerencial] ,[idcentrocusto],* FROM [NG_Estoque].[dbo].[est_itemapropriacaogerencial] where indapropriacaoentrada=1
and iditem in (select iditem from NG_Estoque..est_item
where codigoitem>='100000' and codigoitem<='109999' and len(codigoitem)=6)


select idcentrocusto,codigoestruturado,descricaocentrocusto from [NG].[dbo].[bpm_centrocusto]
where codigoestruturado In ('6.1.005','6.1.002','6.1.004','6.1.006','6.1.008','6.1.007')

select idcontagerencial,codigoestruturadocontagerencial,descricaocontagerencial from [NG].[dbo].[bpm_contagerencial]
where codigoestruturadocontagerencial='3.1.01.03.0001'



update [NG_Estoque].[dbo].[est_itemapropriacaogerencial]
set idcontagerencial=822,idcentrocusto=792
where indapropriacaoentrada=1
and iditem in (select iditem from NG_Estoque..est_item
where codigoitem>='600000' and codigoitem<='609999' and len(codigoitem)=6)



select * from NG_Estoque..est_item
where codigoitem>='200000' and codigoitem<='209999' and len(codigoitem)=6
 and iditem not in (select *from [NG_Estoque].[dbo].[est_itemapropriacaogerencial] 
					where indapropriacaoentrada=1)
					
					
INSERT INTO [NG_Estoque].[dbo].[est_itemapropriacaogerencial]
           ([iditem]
           ,[indapropriacaoentrada]
           ,[indapropriacaosaida]
           ,[indutilizarateio]
           ,[idrateio]
           ,[idcentroresultado]
           ,[idcontagerencial]
           ,[idcentrocusto]
           ,[idunidadeadministrativa]
           ,[idusuariolog]
           ,[datahoralog])
     select iditem,1,0,0,null,null,822,792,null,15031,'20130121' from NG_Estoque..est_item
where codigoitem>='600000' and codigoitem<='609999' and len(codigoitem)=6
 and iditem not in (select iditem from [NG_Estoque].[dbo].[est_itemapropriacaogerencial] 
					where indapropriacaoentrada=1)	