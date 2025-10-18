CREATE TABLE [dbo].[Sys_Audity]
(
[AuditoriaID] [int] NOT NULL IDENTITY(1, 1),
[Tabela] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Operacao] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[HostName] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Data] [datetime] NOT NULL,
[Comando] [xml] NOT NULL
)
GO
