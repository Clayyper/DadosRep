SELECT [iddadosfornecedor]
      ,[idpessoa]
      ,[indativo]
      ,[numbanco]
      ,[numagencia]
      ,[numagenciadv]
      ,[numconta]
      ,[numcontadv]
      ,[numidentificacaobanco]
      ,[descricaotipocobranca]
      ,[idcondicaopagamento]
      ,[especie]
      ,[cp]
      ,[datacadastramento]
      ,[idcontacontabil]
      ,[idhistoricocontabil]
      ,[indregistroimportado]
      ,[idregraretencao]
      ,[indutilizarateio]
      ,[idrateio]
      ,[idcentrocusto]
      ,[idcentroresultado]
      ,[idunidadeadministrativa]
      ,[idcontagerencial]
      ,[idowner]
      ,[indabaterretencaovalortotalnota]
      ,[idcontacontabilunicapiscofinscsll]
      ,[descricaohistoricounicopiscofinscsll]
      ,[idusuariolog]
      ,[datahoralog]
      ,[idOrigemRegistro]
      ,[indintermediarioservico]
  FROM [NG].[dbo].[bpm_dadosfornecedor]
  where iddadosfornecedor in (1042,1321)
GO


delete [NG].[dbo].[bpm_dadosfornecedor]
  where iddadosfornecedor in (1042,1321)
  
delete ng..bpm_dadosfornecedorfiscal where
iddadosfornecedor in
(select iddadosfornecedor from [NG].[dbo].[bpm_dadosfornecedor]
  where iddadosfornecedor in (1042,1321))
  
 select * from  ng..bpm_dadosfornecedortributo where
iddadosfornecedor in
(select iddadosfornecedor from [NG].[dbo].[bpm_dadosfornecedor]
  where iddadosfornecedor in (1042,1321,1455))
  
  update ng..bpm_dadosfornecedortributo
  set iddadosfornecedor=1455
  where iddadosfornecedortributo in (3493,3494)