CREATE TABLE [dbo].[LKPTipoCombustivel]
(
[CombustivelID] [tinyint] NOT NULL,
[Combustivel] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[LKPTipoCombustivel] ADD CONSTRAINT [PK_LKPTipoCombustivel] PRIMARY KEY CLUSTERED ([CombustivelID])
GO
