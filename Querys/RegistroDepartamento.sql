select a.idregistro,b.iddepartamento,dep.descricaodepartamento from 
(SELECT [idregistro],max([datainicio])as datamax      
  FROM [NG_Folha].[dbo].[flh_movimentodepartamento]
	group by idregistro
 ) as a
inner join
(select * from [NG_Folha].[dbo].[flh_movimentodepartamento])as b on a.idregistro=b.idregistro
inner join
(select * from NG_RH..rh_departamento)as dep on b.iddepartamento=dep.iddepartamento
where a.idregistro=2134
  
GO


