select idmovimento,idpessoaempresa FROM [NG_ADM].[dbo].[adm_movimento]
where tipomovimento='s' and idsistemaorigem=14
and (datamovimento between '01/10/2012' and '31/10/2012')


select cfcont.idcfcontabilizacaosubcodigo,cfcont.descricaocontabilizacaosubcodigo,cfcont.subcodigo,mov.numerodocumentoinicial,mov.idpessoaempresa,doc.* 
from [NG_ADM].[dbo].[adm_documentofiscalitens] as doc
inner join 
(select idmovimento,idpessoaempresa,numerodocumentoinicial FROM [NG_ADM].[dbo].[adm_movimento]
where tipomovimento='s' and idsistemaorigem=14
and (datamovimento between '01/10/2012' and '31/10/2012')) as mov on mov.idmovimento=doc.idmovimento
inner join
(select * FROM [NG_ADM].[dbo].[adm_cfcontabilizacaosubcodigo])as cfcont on cfcont.idcf=doc.idcfop and mov.idpessoaempresa=cfcont.idpessoaempresa


update docs
set docs.idcfcontabilizacaosubcodigo=movs.idcfcontabilizacaosubcodigo
from [NG_ADM].[dbo].[adm_documentofiscalitens] as docs inner join
(
select cfcont.idcfcontabilizacaosubcodigo,cfcont.descricaocontabilizacaosubcodigo,cfcont.subcodigo, mov.idpessoaempresa,doc.idmovimento,doc.iddocumentofiscalitens 
from [NG_ADM].[dbo].[adm_documentofiscalitens] as doc
inner join 
(select idmovimento,idpessoaempresa FROM [NG_ADM].[dbo].[adm_movimento]
where tipomovimento='s' and idsistemaorigem=14
and (datamovimento between '01/10/2012' and '31/10/2012')) as mov on mov.idmovimento=doc.idmovimento
inner join
(select * FROM [NG_ADM].[dbo].[adm_cfcontabilizacaosubcodigo])as cfcont on cfcont.idcf=doc.idcfop and mov.idpessoaempresa=cfcont.idpessoaempresa
) as movs on movs.iddocumentofiscalitens=docs.iddocumentofiscalitens