CREATE TABLE [dbo].[SysPara0]
(
[UnidadeID] [tinyint] NOT NULL,
[Parametro] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Caracter] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Numerico] [float] NULL,
[Inteiro] [int] NULL,
[Logico] [bit] NULL,
[Data] [datetime] NULL,
[Tipo] [int] NOT NULL,
[Geral] [bit] NOT NULL,
[Opcoes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[SysPara0] ADD CONSTRAINT [PK_SysPara0] PRIMARY KEY CLUSTERED ([UnidadeID], [Parametro])
GO
ALTER TABLE [dbo].[SysPara0] ADD CONSTRAINT [FK_SysPara0_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[SysPara0].[Geral]'
GO
