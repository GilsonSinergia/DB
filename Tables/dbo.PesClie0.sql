CREATE TABLE [dbo].[PesClie0]
(
[PessoaID] [int] NOT NULL,
[Desconto] [decimal] (18, 2) NOT NULL,
[Credito] [money] NOT NULL,
[DtCredito] [datetime] NULL,
[Carencia] [int] NOT NULL,
[Juros] [float] NOT NULL,
[AreaID] [int] NULL,
[PagamentoID] [smallint] NULL
)
GO
ALTER TABLE [dbo].[PesClie0] ADD CONSTRAINT [PK_PesClie0] PRIMARY KEY CLUSTERED ([PessoaID])
GO
ALTER TABLE [dbo].[PesClie0] ADD CONSTRAINT [FK_PesClie0_CadArea0] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[CadArea0] ([AreaID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PesClie0] ADD CONSTRAINT [FK_PesClie0_CadPaga0] FOREIGN KEY ([PagamentoID]) REFERENCES [dbo].[CadPaga0] ([PagamentoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[PesClie0] ADD CONSTRAINT [FK_PesClie0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesClie0].[Desconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesClie0].[Credito]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[PesClie0].[DtCredito]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesClie0].[Carencia]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[PesClie0].[Juros]'
GO
