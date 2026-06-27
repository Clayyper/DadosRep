DECLARE @name VARCHAR(150) -- Nome do Database  
DECLARE @path VARCHAR(256) -- Caminho do arquivo de backup
DECLARE @fileName VARCHAR(256) -- Arquivo do backup   -- Define caminho de destino do backup
declare @data varchar(20) -- datadobackup
declare @hora varchar(2)
declare @caminho varchar(50)

set @data=CONVERT(nvarchar(12), GETDATE(), 112)
set @hora=datepart(hh,GETDATE())
set @caminho= 'md D:\backup\'+@data+@hora

EXEC xp_cmdshell @caminho
SET @path = 'D:\backup\'+@data+@hora+'\'  

-- Cria um cursor para selecionar todas as databases,  
--  excluindo model, msdb e tempdb
DECLARE db_cursor CURSOR FOR     
	SELECT name      
	FROM master.dbo.sysdatabases     
	WHERE name NOT IN ('model','msdb','tempdb','master','upgrade')   
	
-- Abre o cursor e faz a primeira leitura 
OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name    

-- Loop de leitura das databases selecionadas

WHILE @@FETCH_STATUS = 0   
BEGIN      
	SET @fileName = @path +@data+@hora+@name + '.BAK'    
	 -- Executa o backup para o database   
	 BACKUP DATABASE @name TO DISK = @fileName WITH FORMAT;      
	
	 FETCH NEXT FROM db_cursor INTO @name  
END   

-- Libera recursos alocados pelo cursor
CLOSE db_cursor   
DEALLOCATE db_cursor  