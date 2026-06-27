DEF TEMP-TABLE  tt-medico
    FIELD tipo       as integer 
    FIELD cnpj       as char 
    FIELD cpf        as char FORMAT "X(14)" 
    FIELD matricula  as integer
    FIELD nome       as char FORMAT "x(60)"
    FIELD data-nasc  as char FORMAT "x(10)"
    FIELD ano        as integer FORMAT 9999
    FIELD mes        as integer
    FIELD valor      as char 
    FIELD est        as integer   .
    
    
DEF TEMP-TABLE  tt-dadosfun
    FIELD matricula  as integer
    FIELD data-nasc  as char FORMAT "x(10)"
    FIELD cpf        as char FORMAT "X(14)"
    FIELD est        as integer.
    
    

    
DEF VAR c-arquivo AS CHAR FORMAT "x(50)".
DEF VAR t-nome as char FORMAT "x(60)".
DEF VAR t-matricula as integer.
DEF VAR t-est as integer.

UPDATE c-arquivo.

MESSAGE "SEARCH(c-arquivo): " SEARCH(c-arquivo) VIEW-AS ALERT-BOX.

 INPUT FROM VALUE(SEARCH(c-arquivo)).
REPEAT :
     CREATE tt-medico.
     IMPORT DELIMITER ";" tt-medico.
END.
INPUT CLOSE.

MESSAGE "CAN-FIND(FIRST tt-medico): " CAN-FIND(FIRST tt-medico) VIEW-AS ALERT-BOX.


UPDATE c-arquivo.

MESSAGE "SEARCH(c-arquivo): " SEARCH(c-arquivo) VIEW-AS ALERT-BOX.

 INPUT FROM VALUE(SEARCH(c-arquivo)).
REPEAT :
     CREATE tt-dadosfun.
     IMPORT DELIMITER ";" tt-dadosfun.
END.
INPUT CLOSE.

MESSAGE "CAN-FIND(FIRST tt-dadosfun): " CAN-FIND(FIRST tt-dadosfun) VIEW-AS ALERT-BOX.


output to c:/temp/medico.csv.
    
    put "tipo;Cnpj;CPF;Matricula;Nome;Data Nasc;ano;mes;Valor;Est" skip.



t-nome=''.
t-matricula=0.
t-est=0.

FOR EACH tt-medico exclusive-lock.

    if tt-medico.nome= '' then do:
        assign tt-medico.nome=t-nome
                tt-medico.matricula=t-matricula
                tt-medico.est=t-est.
    end.
    else do:
        t-nome=tt-medico.nome.
        t-matricula=tt-medico.matricula.
        t-est=tt-medico.est.
    end.
    
    for each tt-dadosfun exclusive-lock
        where tt-dadosfun.matricula=tt-medico.matricula
          and tt-dadosfun.est=tt-medico.est:
        assign tt-medico.cpf=tt-dadosfun.cpf
               tt-medico.data-nasc=tt-dadosfun.data-nasc.
    end.     
END.


   FOR EACH tt-medico NO-LOCK:
    
        PUT tt-medico.tipo       ";"
        tt-medico.cnpj           ";"
        tt-medico.cpf            ";"
        tt-medico.matricula      ";"
        tt-medico.nome           ";"
        tt-medico.data-nasc      ";"
        tt-medico.ano            ";"
        tt-medico.mes            ";"
        tt-medico.valor          ";"
        tt-medico.est           SKIP.    
    
    END.

 output close.
