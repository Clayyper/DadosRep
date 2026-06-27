RESTORE DATABASE [NG] FROM  DISK = N'C:\MMQNG\Backup\NG.BAK' WITH  FILE = 1,  MOVE N'NG' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG.mdf',  MOVE N'NG_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_ADM] FROM  DISK = N'C:\MMQNG\Backup\NG_ADM.BAK' WITH  FILE = 1,  MOVE N'NG_ADM' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_ADM.mdf',  MOVE N'NG_ADM_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_ADM.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Analisador] FROM  DISK = N'C:\MMQNG\Backup\NG_Analisador.BAK' WITH  FILE = 1,  MOVE N'NG_Analisador' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Analisador.mdf',  MOVE N'NG_Analisador_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Analisador.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Arquivos] FROM  DISK = N'C:\MMQNG\Backup\NG_Arquivos.BAK' WITH  FILE = 1,  MOVE N'NG_Arquivos' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Arquivos.mdf',  MOVE N'NG_Arquivos_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Arquivos.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Compras] FROM  DISK = N'C:\MMQNG\Backup\NG_Compras.BAK' WITH  FILE = 1,  MOVE N'NG_Compras' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Compras.mdf',  MOVE N'NG_Compras_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Compras.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Contabil] FROM  DISK = N'C:\MMQNG\Backup\NG_Contabil.BAK' WITH  FILE = 1,  MOVE N'NG_Contabil' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Contabil.mdf',  MOVE N'NG_Contabil_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Contabil.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_CRM] FROM  DISK = N'C:\MMQNG\Backup\NG_CRM.BAK' WITH  FILE = 1,  MOVE N'NG_CRM' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_CRM.mdf',  MOVE N'NG_CRM_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_CRM.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Custom] FROM  DISK = N'C:\MMQNG\Backup\NG_Custom.BAK' WITH  FILE = 1,  MOVE N'NG_Custom' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Custom.mdf',  MOVE N'NG_Custom_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Custom.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Dominio] FROM  DISK = N'C:\MMQNG\Backup\NG_Dominio.BAK' WITH  FILE = 1,  MOVE N'NG_Dominio' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Dominio.mdf',  MOVE N'NG_Dominio_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Dominio.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Estoque] FROM  DISK = N'C:\MMQNG\Backup\NG_Estoque.BAK' WITH  FILE = 1,  MOVE N'NG_Estoque' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Estoque.mdf',  MOVE N'NG_Estoque_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Estoque.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Faturamento] FROM  DISK = N'C:\MMQNG\Backup\NG_Faturamento.BAK' WITH  FILE = 1,  MOVE N'NG_Faturamento' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Faturamento.mdf',  MOVE N'NG_Faturamento_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Faturamento.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Financeiro] FROM  DISK = N'C:\MMQNG\Backup\NG_Financeiro.BAK' WITH  FILE = 1,  MOVE N'NG_Financeiro' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Financeiro.mdf',  MOVE N'NG_Financeiro_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Financeiro.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Fiscal] FROM  DISK = N'C:\MMQNG\Backup\NG_Fiscal.BAK' WITH  FILE = 1,  MOVE N'NG_Fiscal' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Fiscal.mdf',  MOVE N'NG_Fiscal_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Fiscal.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Folha] FROM  DISK = N'C:\MMQNG\Backup\NG_Folha.BAK' WITH  FILE = 1,  MOVE N'NG_Folha' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Folha.mdf',  MOVE N'NG_Folha_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Folha.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Gerencial] FROM  DISK = N'C:\MMQNG\Backup\NG_Gerencial.BAK' WITH  FILE = 1,  MOVE N'NG_Gerencial' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Gerencial.mdf',  MOVE N'NG_Gerencial_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Gerencial.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Imagem] FROM  DISK = N'C:\MMQNG\Backup\NG_Imagem.BAK' WITH  FILE = 1,  MOVE N'NG_Imagem' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Imagem.mdf',  MOVE N'NG_Imagem_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Imagem.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Patrimonio] FROM  DISK = N'C:\MMQNG\Backup\NG_Patrimonio.BAK' WITH  FILE = 1,  MOVE N'NG_Patrimonio' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Patrimonio.mdf',  MOVE N'NG_Patrimonio_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Patrimonio.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_PDV] FROM  DISK = N'C:\MMQNG\Backup\NG_PDV.BAK' WITH  FILE = 1,  MOVE N'NG_PDV' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_PDV.mdf',  MOVE N'NG_PDV_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_PDV.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Ponto] FROM  DISK = N'C:\MMQNG\Backup\NG_Ponto.BAK' WITH  FILE = 1,  MOVE N'NG_Ponto' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Ponto.mdf',  MOVE N'NG_Ponto_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Ponto.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Protocolo] FROM  DISK = N'C:\MMQNG\Backup\NG_Protocolo.BAK' WITH  FILE = 1,  MOVE N'NG_Protocolo' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Protocolo.mdf',  MOVE N'NG_Protocolo_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Protocolo.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_RH] FROM  DISK = N'C:\MMQNG\Backup\NG_RH.BAK' WITH  FILE = 1,  MOVE N'NG_RH' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_RH.mdf',  MOVE N'NG_RH_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_RH.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_SAP] FROM  DISK = N'C:\MMQNG\Backup\NG_SAP.BAK' WITH  FILE = 1,  MOVE N'NG_SAP' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_SAP.mdf',  MOVE N'NG_SAP_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_SAP.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Seguranca] FROM  DISK = N'C:\MMQNG\Backup\NG_Seguranca.BAK' WITH  FILE = 1,  MOVE N'NG_Seguranca' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Seguranca.mdf',  MOVE N'NG_Seguranca_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Seguranca.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Telog] FROM  DISK = N'C:\MMQNG\Backup\NG_Telog.BAK' WITH  FILE = 1,  MOVE N'NG_Telog' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Telog.mdf',  MOVE N'NG_Telog_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Telog.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [NG_Tributos] FROM  DISK = N'C:\MMQNG\Backup\NG_Tributos.BAK' WITH  FILE = 1,  MOVE N'NG_Tributos' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Tributos.mdf',  MOVE N'NG_Tributos_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\NG_Tributos.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO
RESTORE DATABASE [Upgrade] FROM  DISK = N'C:\MMQNG\Backup\Upgrade.BAK' WITH  FILE = 1,  MOVE N'Upgrade' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Upgrade.mdf',  MOVE N'Upgrade_log' TO N'C:\Arquivos de programas\Microsoft SQL Server\MSSQL.1\MSSQL\DATA\Upgrade.ldf',  NOUNLOAD,  REPLACE,  STATS = 10
GO