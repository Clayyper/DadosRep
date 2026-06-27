SELECT [cdNfe]
      ,[chNfe]
      ,[tpAmb]
      ,[tpNF]
      ,[cdTpEmis]
      ,[nNF]
      ,[serie]
      ,[dEmi]
      ,[vNF]
      ,[nRec]
      ,[nProt]
      ,[cdTipoFn]
      ,[cdUFEmit]
      ,[cdUFDest]
      ,[CNPJEmit]
      ,[CNPJDest]
      ,[status]
      ,[FaseProcesso]
      ,[dtProcesso]
      ,[dtRetorno]
      ,[XML]
      ,[SCheck]
      ,[DanfeImpresso]
      ,[cdNota]
      ,[cdstatusnota]
      ,[flagautenticada]
      ,[datasemautenticacao]
      ,[RzSocialDest]
      ,[IEPrestador]
  FROM [NFe_Express].[dbo].[NFe_Processo]
  where nNF=173520
GO


delete from [NFe_Express].[dbo].[NFe_Processo]
where cdNfe in (382842)

UPDATE [NFe_Express].[dbo].[NFe_Processo]
SET nProt='131131066460925',status=' Cancelamento de NF-e homologado',dtRetorno='12/04/2013 10:19:52',cdstatusnota=101,FaseProcesso=6,dtProcesso='12/04/2013 10:19:52'
WHERE cdNfe=381860