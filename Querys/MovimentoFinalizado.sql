select mov.dataemissao,mov.valormovimento,pess.nomepessoa,mov.numeromovimento,
movpar.datavencimento,movpar.dataquitacao,pessFor.nomepessoa as [Cliente/Fornecedor],mov.indfinalizado
from 
(select * from [NG_ADM].[dbo].[adm_movimento]) as mov
left join
(select * from [NG_ADM].[dbo].[adm_dadosfinanceiro]) as finan on mov.idmovimento=finan.idmovimento
left join
(select * from [NG_Financeiro].[dbo].[fin_movimentoparcela])as movpar on mov.idmovimento=movpar.idmovimentofinanceiro
left join
(select * from ng..bpm_pessoa)as pess on mov.idpessoaempresa=pess.idpessoa
left join
(select * from ng..bpm_pessoa)as pessFor on mov.idpessoaclientefornecedor=pessFor.idpessoa
where numeromovimento='0000181774'

----------------so-mente o-s movimentos nao finalizados