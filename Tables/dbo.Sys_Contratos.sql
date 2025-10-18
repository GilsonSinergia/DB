CREATE TABLE [dbo].[Sys_Contratos]
(
[CNPJ] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Data] [datetime] NOT NULL,
[Expira] [smallint] NOT NULL,
[Valor] [float] NOT NULL,
[DiaVencimento] [tinyint] NOT NULL,
[DtConsulta] [datetime] NOT NULL,
[MD5] [char] (32) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[Sys_Contratos] ADD CONSTRAINT [PK_Sys_Contratos_1] PRIMARY KEY CLUSTERED ([CNPJ])
GO
