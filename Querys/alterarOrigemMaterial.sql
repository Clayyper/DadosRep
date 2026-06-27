SELECT *
  FROM [NG_Estoque].[dbo].[est_item]
  where iditem>=20264
  
GO

update [NG_Estoque].[dbo].[est_item]
set idorigemregistro=1,indregistroimportado=0
where iditem>=20254


update a set a.codigoitem=b.codigomercadoriaexterno from [NG_Estoque].[dbo].[est_item] as a inner join [NG_Estoque].[dbo].[est_item] as b on a.iditem=b.iditem 
where a.iditem>=20254 

update a set a.codigomercadoriaexterno='0000000'+b.codigomercadoriaexterno from [NG_Estoque].[dbo].[est_item] as a inner join [NG_Estoque].[dbo].[est_item] as b on a.iditem=b.iditem 
where a.iditem>=20254


update [NG_Estoque].[dbo].[est_item]
set codigoitem='902834',codigomercadoriaexterno='00000000902834'
where iditem=20264