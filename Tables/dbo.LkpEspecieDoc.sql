CREATE TABLE [dbo].[LkpEspecieDoc]
(
[TipoBoletoID] [tinyint] NOT NULL,
[TipoBoleto] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Sigla] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LkpEspecieDoc] ADD CONSTRAINT [PK_LkpTipoBoleto] PRIMARY KEY CLUSTERED ([TipoBoletoID])
GO
