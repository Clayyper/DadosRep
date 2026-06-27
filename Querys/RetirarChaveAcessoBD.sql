delete from [NG_ADM].[dbo].[adm_documentofiscal]
  where chavenotafiscaleletronica='35130243405547000180550010000157671400606424'
  
delete from NG_ADM..adm_documentofiscalmercadoriaservico where idmovimento in (select idmovimento from [NG_ADM].[dbo].[adm_documentofiscal]
  where chavenotafiscaleletronica='35130243405547000180550010000157671400606424')