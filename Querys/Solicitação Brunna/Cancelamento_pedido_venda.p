for each ped-venda exclusive-lock
where ped-venda.nr-pedcli='4':
assign ped-venda.cod-sit-ped=6 .


for each ped-venda exclusive-lock
where ped-venda.nr-pedcli='00CP01ZZ'
AND cod-emitente=13683:
ASSIGN ped-venda.cod-sit-ped=1.


ped-item
nr-pedcli

FOR EACH ped-item EXCLUSIVE-LOCK
    WHERE nr-pedcli='00cp01zz'
    AND nome-abrev='GMB GUARU':
    DISPLAY ped-item WITH 2 COLUMN WIDTH 320 .
END.

FOR EACH ped-item EXCLUSIVE-LOCK
    WHERE nr-pedcli='00cp01zz'
    AND nome-abrev='GMB GUARU':
    ASSIGN ped-item.dt-canseq=ped-item.dt-reativ.
END.

desc-cancela
dt-usercan
user-canc



FOR EACH embarque EXCLUSIVE-LOCK
    WHERE cdd-embarq=140:
    DISP   situacao.
END.