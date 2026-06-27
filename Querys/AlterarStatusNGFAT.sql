SELECT [idarquivonfe]
      ,[idstatusnfe]
      ,[indtipoarquivonfe]
      ,[idmovimento]
      ,[idinutilizacaonfe]
      ,[nomearquivonfe]
      ,[arquivonfe]
      ,[idusuariolog]
      ,[datahoralog]
  FROM [NG_Faturamento].[dbo].[fat_arquivonfe]
  where nomearquivonfe like'%176322%'
  
 update [NG_Faturamento].[dbo].[fat_arquivonfe]
 set idmovimento=999999 where idarquivonfe=23728 

delete from NG_Faturamento..fat_arquivonfe
where idarquivonfe in (21415)

SELECT [idhistoricostatusnfe]
      ,[idstatusnfe]
      ,[idmovimento]
      ,[datastatusnfe]
      ,[ocorrenciastatusnfe]
      ,[tipoemissao]
      ,[protocolonfe]
      ,[idusuariolog]
      ,[datahoralog]
  FROM [NG_Faturamento].[dbo].[fat_historicostatusnfe]
  where idmovimento=422041

update [NG_Faturamento].[dbo].[fat_historicostatusnfe]
set idstatusnfe=215
 where idmovimento  in (422041)
--where idhistoricostatusnfe in (25647)

delete from [NG_Faturamento].[dbo].[fat_historicostatusnfe]
where idhistoricostatusnfe in (19553,
19554)

update NG_ADM..adm_dadosfaturamento
set indimpresso=1
where idmovimento=422041
