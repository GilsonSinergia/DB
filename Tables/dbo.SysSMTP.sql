CREATE TABLE [dbo].[SysSMTP]
(
[EmitenteID] [tinyint] NOT NULL,
[Email] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[NomeAmigavel] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[SMTP] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Porta] [int] NOT NULL,
[Autenticacao] [tinyint] NOT NULL,
[TimeOut] [int] NOT NULL,
[Usuario] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Senha] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[SysSMTP] ADD CONSTRAINT [PK_SysSMTP] PRIMARY KEY CLUSTERED ([EmitenteID])
GO
ALTER TABLE [dbo].[SysSMTP] ADD CONSTRAINT [IX_SysSMTP] UNIQUE NONCLUSTERED ([Email])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[SysSMTP].[Autenticacao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[SysSMTP].[TimeOut]'
GO
