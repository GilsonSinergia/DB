CREATE TABLE [dbo].[CadRete0]
(
[RetencaoID] [tinyint] NOT NULL,
[Retencao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Aliquota] [float] NOT NULL
)
GO
ALTER TABLE [dbo].[CadRete0] ADD CONSTRAINT [PK_CadRete0] PRIMARY KEY CLUSTERED ([RetencaoID])
GO
