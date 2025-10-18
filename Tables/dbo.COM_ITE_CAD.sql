CREATE TABLE [dbo].[COM_ITE_CAD]
(
[ItemID] [int] NOT NULL,
[Item] [varchar] (150) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[DtCadastro] [datetime] NOT NULL,
[NCM] [char] (8) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[CEST] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Aplicacao] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Similaridade] [int] NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_CAD] ADD CONSTRAINT [PK_COM_ITE_CAD] PRIMARY KEY CLUSTERED ([ItemID])
GO
ALTER TABLE [dbo].[COM_ITE_CAD] ADD CONSTRAINT [IX_COM_ITE_CAD] UNIQUE NONCLUSTERED ([Item])
GO
ALTER TABLE [dbo].[COM_ITE_CAD] ADD CONSTRAINT [FK_COM_ITE_CAD_FIS_NCM] FOREIGN KEY ([NCM]) REFERENCES [dbo].[FIS_NCM] ([NCM])
GO
EXEC sp_bindefault N'[dbo].[DataHora]', N'[dbo].[COM_ITE_CAD].[DtCadastro]'
GO
