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
GO

select * FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012

select count(distinct(nNF)) FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012

select count(distinct(nNF)) FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012 and RzSocialDest='FIAT AUTOMOVEIS SA'

select count(distinct(nNF)) FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012 and RzSocialDest='FIAT AUTOMOVEIS SA'
and (status like 'Rejeicao:%' or status like 'Falha no Schema%')

select nNF FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012 and RzSocialDest='FIAT AUTOMOVEIS SA'
and (status like 'Rejeicao:%' or status like 'Falha no Schema%')
order by nNF

select distinct nf.nNF,CONVERT(VARCHAR(19),hor.minimo)as Inicio,CONVERT(VARCHAR(19),hor.maximo)as Fim,men.status from [NFe_Express].[dbo].[NFe_Processo]as nf 
inner join 
(select nNF,MIN(dtprocesso)as minimo,MAX(dtprocesso)as maximo FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012 
group by nNF) as hor on nf.nNF=hor.nNF
inner join
(select nNF,status FROM [NFe_Express].[dbo].[NFe_Processo]
where cdNfe>=282012 and RzSocialDest='FIAT AUTOMOVEIS SA'
and (status like 'Rejeicao:%' or status like 'Falha no Schema%'))as men on men.nNF=nf.nNF
order by nf.nNF