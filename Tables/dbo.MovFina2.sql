CREATE TABLE [dbo].[MovFina2]
(
[OperacaoID] [tinyint] NOT NULL,
[MovimentoID] [int] NOT NULL,
[Titulo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[MoedaID] [tinyint] NOT NULL,
[Parcelas] [tinyint] NOT NULL,
[DtPagamento] [date] NOT NULL,
[DtProjecao] [date] NOT NULL,
[Valor] [money] NOT NULL,
[ContaID] [int] NOT NULL,
[StatusID] [tinyint] NOT NULL,
[Operador] [int] NOT NULL,
[DtMovimento] [datetime] NOT NULL CONSTRAINT [DF_MovFina2_DtMovimento] DEFAULT (getdate()),
[DtConciliacao] [date] NULL,
[Descricao] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[PessoaID] [int] NULL,
[BancoID] [smallint] NULL,
[Agencia] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Conta] [varchar] (14) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Compensacao] [smallint] NULL,
[ParentOperacaoID] [tinyint] NULL,
[ParentMovimentoID] [int] NULL,
[EmitenteID] [int] NULL,
[ClasseID] [tinyint] NULL,
[Emitente] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [CK_MovFina2] CHECK (([StatusID]<>(3) OR [DtConciliacao] IS NOT NULL))
GO
ALTER TABLE [dbo].[MovFina2] WITH NOCHECK ADD CONSTRAINT [CK_MovFina2_Valor0] CHECK (([Valor]>(0)))
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [PK_MovFina2] PRIMARY KEY CLUSTERED ([OperacaoID], [MovimentoID])
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_BaixaClace] FOREIGN KEY ([ClasseID]) REFERENCES [dbo].[BaixaClace] ([ClasseID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_CadCont0] FOREIGN KEY ([ContaID]) REFERENCES [dbo].[CadCont0] ([ContaID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFina2] WITH NOCHECK ADD CONSTRAINT [FK_MovFina2_CadMoed0] FOREIGN KEY ([MoedaID]) REFERENCES [dbo].[CadMoed0] ([MoedaID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_LkpBaix0] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[LkpBaix0] ([StatusID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_LkpBaix1] FOREIGN KEY ([OperacaoID]) REFERENCES [dbo].[LkpBaix1] ([OperacaoID])
GO
ALTER TABLE [dbo].[MovFina2] ADD CONSTRAINT [FK_MovFina2_MovFina2] FOREIGN KEY ([ParentOperacaoID], [ParentMovimentoID]) REFERENCES [dbo].[MovFina2] ([OperacaoID], [MovimentoID])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[MovFina2].[Parcelas]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFina2].[Valor]'
GO
