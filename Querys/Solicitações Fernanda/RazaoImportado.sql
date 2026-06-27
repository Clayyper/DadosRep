SELECT [DIA]
      ,[LCTO#]
      ,[CONTRA-PARTIDA]
      ,[HISTÓRICO]
      ,[DÉBITO MÊS]
      ,[CRÉDITO MÊS]
      ,LEFT(dbo.TiraLetras(HISTÓRICO),6) as Nota
      ,LEFT(dbo.TiraLetras(HISTÓRICO),15) as Notaaux
  FROM [NFe_Express].[dbo].[Razao012012]
  order by Nota