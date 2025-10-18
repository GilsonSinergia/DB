CREATE TABLE [dbo].[MovConf1]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Conferencia] [tinyint] NOT NULL,
[ProdutoID] [int] NOT NULL,
[Quantidade] [decimal] (18, 2) NOT NULL
)
GO
ALTER TABLE [dbo].[MovConf1] ADD CONSTRAINT [PK_MovConf1] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [Conferencia], [ProdutoID])
GO
ALTER TABLE [dbo].[MovConf1] ADD CONSTRAINT [FK_MovConf1_MovConf0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota], [Conferencia]) REFERENCES [dbo].[MovConf0] ([UnidadeID], [TipoID], [Nota], [Conferencia]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovConf1].[Quantidade]'
GO
