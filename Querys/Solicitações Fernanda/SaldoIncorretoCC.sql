SELECT [idsaldocontacontabil]
      ,[idcontacontabil]
      ,[saldoinicial]
      ,[totaldebitos]
      ,[totalcreditos]
      ,[saldomensal]
      ,[mes]
      ,[ano]
      ,[idcenario]
      ,[idconfiguracaoperiodo]
      ,[naturezasaldo]
      ,[idowner]
      ,[idusuariolog]
      ,[datahoralog]
  FROM [NG_Contabil].[dbo].[ctb_saldocontacontabil]
  where ano=2012 and mes=4 and idcontacontabil=36410
GO


select * from ng..bpm_pessoa where idpessoa=12492

3207166,26

update [NG_Contabil].[dbo].[ctb_saldocontacontabil]
set totalcreditos=109068.32
where idsaldocontacontabil=1280800
