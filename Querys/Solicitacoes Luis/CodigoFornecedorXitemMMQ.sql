select a.codigoitem as [Codigo MMQ],a.descricaoitem as [Descricao MMQ]
,b.codigoitemporfornecedor as [Codigo Fornecedor],b.descricaoitemporfornecedor as [Descricao Fornecedor]
,d.codigopessoa as [Codigo Pessoa], d.nomepessoa as [Nome Fornecedor]
 from 
(select iditem,codigoitem,descricaoitem from ng_estoque..est_item) as a
inner join 
(SELECT [iditem]
      ,[iddadosfornecedor]     
      ,[codigoitemporfornecedor]
      ,[descricaoitemporfornecedor]      
  FROM [NG_Estoque].[dbo].[est_itemfornecedor])as b on a.iditem=b.iditem
inner join
(select idpessoa,iddadosfornecedor from ng..bpm_dadosfornecedor)as c on b.iddadosfornecedor=c.iddadosfornecedor
inner join
(select idpessoa,nomepessoa,codigopessoa from ng..bpm_pessoa) as d on c.idpessoa=d.idpessoa