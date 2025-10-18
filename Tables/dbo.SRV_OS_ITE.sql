CREATE TABLE [dbo].[SRV_OS_ITE]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[ServicoID] [tinyint] NOT NULL,
[Quantidade] [decimal] (18, 3) NOT NULL,
[Unitario] [money] NOT NULL,
[Desconto] [float] NOT NULL,
[PessoaID] [int] NOT NULL,
[OBS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[SRV_OS_ITE] ADD CONSTRAINT [PK_SRV_OS_ITE] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [ServicoID])
GO
ALTER TABLE [dbo].[SRV_OS_ITE] ADD CONSTRAINT [FK_SRV_OS_ITE_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SRV_OS_ITE] ADD CONSTRAINT [FK_SRV_OS_ITE_SRV_ITE_CAD] FOREIGN KEY ([ServicoID]) REFERENCES [dbo].[SRV_ITE_CAD] ([ServicoID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[SRV_OS_ITE].[Quantidade]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[SRV_OS_ITE].[Desconto]'
GO
