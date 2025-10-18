CREATE TABLE [dbo].[CadInde0]
(
[IndexID] [tinyint] NOT NULL,
[Nome] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Valor] [decimal] (18, 0) NOT NULL
)
GO
ALTER TABLE [dbo].[CadInde0] ADD CONSTRAINT [PK_CadInde0] PRIMARY KEY CLUSTERED ([IndexID])
GO
