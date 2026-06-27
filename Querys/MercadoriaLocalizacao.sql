select IT.codigoitem as [Código],IT.descricaoitem as [Descrição],SITMER.descricaosituacaomercadoria as [Situação Mercadoria],
pess.nomepessoa as [Filial],loc.descricaolocalizacao as [Localização] from 
(select * FROM [NG_Estoque].[dbo].[est_item]) as IT
left join
(select * from [NG_Estoque].[dbo].[est_estoque])as EST on EST.iditem=IT.iditem
left join
(select * from ng..bpm_pessoa) as pess on pess.idpessoa=EST.idpessoaempresa
left join
(select * FROM [NG_Estoque].[dbo].[est_localizacao]) as loc on est.idlocalizacao=loc.idlocalizacao
left join
(select * from [NG_Estoque].[dbo].[est_itemdadosfiscais])as ITFIS on IT.iditem=ITFIS.iditem
left join
(select * from NG_Dominio..dom_situacaomercadoria) as SITMER on ITFIS.idsituacaomercadoria=SITMER.idsituacaomercadoria
 
GO


