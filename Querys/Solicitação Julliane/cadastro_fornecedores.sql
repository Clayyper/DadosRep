select b.codigopessoa,e.cnpj,b.nomepessoa,c.descricaotipocontato as [Telefone],d.descricaotipocontato as [Email] from
(SELECT  *
  FROM [NG].[dbo].[bpm_dadosfornecedor] where idowner=19218) as a
  inner join
  (select * from ng..bpm_pessoa) as b on a.idpessoa=b.idpessoa
  left join
  (select * from ng..bpm_pessoatipocontato where idtipocontato=2) as c on a.idpessoa=c.idpessoa
  left join
  (select * from ng..bpm_pessoatipocontato where idtipocontato=3) as d on a.idpessoa=d.idpessoa
  left join
  (select * from ng..bpm_dadospessoajuridica)as e on a.idpessoa=e.idpessoa
GO


