OUTPUT TO VALUE('C:\TEMP\List_item.TXT').
FOR EACH ITEM NO-LOCK:
    FOR EACH grup-estoque NO-LOCK WHERE grup-estoque.ge-codigo=ITEM.ge-codigo:
        FOR EACH familia NO-LOCK WHERE familia.fm-codigo= ITEM.fm-codigo:
            PUT UNFORMATTED class-fiscal ";" desc-item ";" un ";" grup-estoque.descricao ";" it-codigo ";" peso-bruto ";" peso-liquido ";" un ";" familia.descricao ";" "V" ";" preco-ul-ent ";" "" ";" substring(ITEM.char-2,212,1) ";" codigo-orig SKIP.
        END.
        
    END.
    
END.
OUTPUT CLOSE.
