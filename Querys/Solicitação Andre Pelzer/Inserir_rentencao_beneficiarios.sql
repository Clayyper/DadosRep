select * from ng..bpm_dadosbeneficiarioretencao
where iddadosbeneficiarioretencao not in(select iddadosbeneficiarioretencao from NG_Tributos..trb_retencaobeneficiario)

idpessoa=13745

select iddadosbeneficiarioretencao from NG_Tributos..trb_retencaobeneficiario
where iddadosbeneficiarioretencao=22

select * from NG_Tributos..trb_retencaobeneficiario


select * from ng..bpm_dadosbeneficiarioretencao
where iddadosbeneficiarioretencao not in(1,2)

update NG_Tributos..trb_retencaobeneficiario
set iddadosbeneficiarioretencao=1
where idretencaobeneficiario=2

INSERT INTO [NG_Tributos].[dbo].[trb_retencaobeneficiario]
           ([iddadosbeneficiarioretencao]
           ,[descricaoservico]
           ,[idcodigodirf]
           ,[idtiporetencaoprestacaoservico]
           ,[idusuariolog]
           ,[datahoralog])
     select iddadosbeneficiarioretencao
           ,'SERVICOS PRESTADOS'
           ,16
           ,3
           ,2
           ,'20140228' from ng..bpm_dadosbeneficiarioretencao
where iddadosbeneficiarioretencao not in(select iddadosbeneficiarioretencao from NG_Tributos..trb_retencaobeneficiario)

    