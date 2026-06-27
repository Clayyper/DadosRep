select pes.codigopessoa as [Código],pes.nomepessoa as [Razão Social],dpessju.cnpj as [CNPJ],contab.codcompletoconta as [Código Conta],
contab.descricaocompletaconta as [Descrição Conta],tipocli.descricaotipoclientefornecedor as [Categoria],dpessju.inscricaoestadual as [Inscrição Estadual],
dpessju.inscricaomunicipal as [Inscrição Municipal],tipolog.descricaotipologradouro as [Tipo Logradouro],pessend.logradouro as [Logradouro],
pessend.numeroendereco as [Numero],pessend.bairro as [Bairro],munic.nomemunicipio as [Município],pessend.cep as [CEP],unidfed.nomeuf as [UF],
paiss.nomepais as [País],pesscontT.descricaotipocontato as [Telefone Comercial],pesscontE.descricaotipocontato as [E-mail],nat.descricaonaturezaoperacao as [Natureza Operação],
case when pes.inddesativada=1 then 'NÃO'else 'SIM' end as Ativo,
case when dcli.iddadoscliente  is not null then 'SIM' else 'NÃO' end as Cliente,
case when dforn.iddadosfornecedor is not null then 'SIM' else 'NÃO' end as Fornecedor from
(select * from [NG]..[bpm_pessoa])as pes
left join
(select * from [NG]..[bpm_dadoscliente]) as dcli on pes.idpessoa=dcli.idpessoa
left join
(select * from [NG]..[bpm_dadosclientefiscal])as dclifi on dcli.iddadoscliente=dclifi.iddadoscliente
inner join
(select * from [NG]..[bpm_dadospessoajuridica])as dpessju on pes.idpessoa=dpessju.idpessoa
left join
(select * from [NG]..[bpm_pessoaendereco])as pessend on pessend.idpessoa=pes.idpessoa
left join
(select * from [NG]..[bpm_pessoatipocontato] where idtipocontato in (2))as pesscontT on pesscontT.idpessoa=pes.idpessoa
left join
(select * from [NG]..[bpm_pessoatipocontato] where idtipocontato in (3))as pesscontE on pesscontE.idpessoa=pes.idpessoa
left join
(select * from [NG_Contabil]..[ctb_contacontabil])as contab on dcli.idcontacontabil=contab.idcontacontabil
left join
(select * from  [NG_Dominio]..[dom_tipoclientefornecedor]) as tipocli on tipocli.codigotipoclientefornecedor=dclifi.idtipoclientefornecedor
left join
(select * from [NG].[dbo].[bpm_dadosfornecedor])as dforn on dforn.idpessoa=pes.idpessoa
left join
(select * from  [NG]..[bpm_dadosfornecedorfiscal])as dfornfi on dfornfi.iddadosfornecedor=dforn.iddadosfornecedor
left join
(select * from [NG_Dominio]..[dom_naturezaoperacao])as nat on nat.idnaturezaoperacao=dfornfi.idnaturezaoperacao
left join
(select * from ng_dominio..dom_tipologradouro)as tipolog on pessend.idtitulologradouro=tipolog.idtipologradouro
left join
(select * from ng_dominio..dom_municipio)as munic on munic.idmunicipio=pessend.idmunicipio
left join
(select * from NG_Dominio..dom_uf)as unidfed on unidfed.iduf=munic.iduf
left join
(SELECT	* from NG_Dominio..dom_pais) as paiss on paiss.idpais=unidfed.idpais



