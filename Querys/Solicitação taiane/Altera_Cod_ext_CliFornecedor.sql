select LEFT(cnpj,8),SUBSTRING(cnpj,11,2),*  FROM [NG].[dbo].[bpm_dadospessoajuridica]

update ng..bpm_dadoscliente as c inner join  ng..bpm_dadospessoajuridica as j on c.idpessoa=j.idpessoa
set c.cp=LEFT(j.cnpj,8)+SUBSTRING(j.cnpj,11,2)


select * from ng..bpm_dadoscliente as c inner join  ng..bpm_dadospessoajuridica as j on c.idpessoa=j.idpessoa

update c
set c.cp=LEFT(j.cnpj,8)+SUBSTRING(j.cnpj,11,2)
from ng..bpm_dadoscliente as c inner join  ng..bpm_dadospessoajuridica as j on c.idpessoa=j.idpessoa

update c
set c.cp=LEFT(j.cnpj,8)+SUBSTRING(j.cnpj,11,2)
from ng..bpm_dadosfornecedor as c inner join  ng..bpm_dadospessoajuridica as j on c.idpessoa=j.idpessoa