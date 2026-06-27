INSERT INTO [NG_Financeiro].[dbo].[fin_movimentoapropriacao]
           ([idmovimentofinanceiro]
           ,[idcentroresultado]
           ,[idunidadeadministrativa]
           ,[idcentrocusto]
           ,[idcontagerencial]
           ,[idpessoaempresa]
           ,[valormovimentoapropriacao]
           ,[percentualrateio]
           ,[mesanocompetencia]
           ,[idusuariolog]
           ,[datahoralog])
     SELECT [idmovimento],null,null,819,983,12492
      ,[valormovimento],0,CAST(month(datamovimento) as varchar(2))+'/'+CAST(month(datamovimento) as varchar(6))
      ,2,'2013-05-03 13:52:10.000'
       FROM [NG_ADM].[dbo].[adm_movimento]
  where idmovimento not in (SELECT [idmovimentofinanceiro]
							 FROM [NG_Financeiro].[dbo].[fin_movimentoapropriacao])
  and numeromovimento in (201202)
GO