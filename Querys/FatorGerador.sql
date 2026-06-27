select fatger.idfatogeradorverba,resg.codigoregistro as [Código Registro],pess.nomepessoa as [Nome],fatger.DataInicio,fatger.DataFim,
tipofat.descricaotipofatogeradorverba as [Tipo Fator],subtipo.descricaosubtipofatogeradorverba as[Sub-Tipo Fator]
,fatger.quantidadefatogeradorverba as [Quantidade],fatger.valorfatogeradorverba as [Valor],dept.descricaodepartamento as [Departamento]from 
(SELECT [idfatogeradorverba]
      ,[idtipofatogeradorverba]
      ,[idsubtipofatogeradorverba]
      ,[idregistro]
      ,convert(varchar(10),datainiciofatogeradorverba,103) as DataInicio
      ,convert(varchar(10),datafimfatogeradorverba,103) as DataFim
      ,[quantidadefatogeradorverba]
      ,[valorfatogeradorverba]
       FROM [NG_Folha].[dbo].[flh_fatogeradorverba]
 ) as fatger
 inner join
 (select idregistro,idpessoaregistro,codigoregistro from [NG_Folha].[dbo].[flh_registro])as resg on fatger.idregistro=resg.idregistro
 inner join
 (select idpessoa,nomepessoa from ng..bpm_pessoa)as pess on pess.idpessoa=resg.idpessoaregistro
 inner join
 (select a.idregistro,b.iddepartamento,dep.descricaodepartamento from 
	(SELECT [idregistro],max([datainicio])as datamax      
	  FROM [NG_Folha].[dbo].[flh_movimentodepartamento]
		group by idregistro
	 ) as a
	inner join
	(select * from [NG_Folha].[dbo].[flh_movimentodepartamento])as b on a.idregistro=b.idregistro
	inner join
	(select * from NG_RH..rh_departamento)as dep on b.iddepartamento=dep.iddepartamento
  ) as dept on dept.idregistro=resg.idregistro
  inner join
 (select * from [NG_Folha].[dbo].[flh_tipofatogeradorverba]) as tipofat on fatger.idtipofatogeradorverba=tipofat.idtipofatogeradorverba
 inner join
 (select * from [NG_Folha].[dbo].[flh_subtipofatogeradorverba]) as subtipo on fatger.idsubtipofatogeradorverba=subtipo.idsubtipofatogeradorverba

GO


