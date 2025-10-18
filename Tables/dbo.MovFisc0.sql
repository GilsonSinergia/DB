CREATE TABLE [dbo].[MovFisc0]
(
[UnidadeID] [tinyint] NOT NULL,
[ModeloID] [tinyint] NOT NULL,
[PessoaID] [int] NOT NULL,
[Serie] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[NF] [int] NOT NULL,
[DtEmissao] [date] NOT NULL,
[FinalidadeID] [tinyint] NOT NULL,
[Consumidor] [bit] NOT NULL,
[modFrete] [tinyint] NOT NULL,
[Operacao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[NFPropria] [bit] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED,
[OBS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [PK_MovFisc0] PRIMARY KEY CLUSTERED ([UnidadeID], [ModeloID], [PessoaID], [Serie], [NF])
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [IX_MovFisc0] UNIQUE NONCLUSTERED ([Chave])
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [IX_MovFisc0_Movimento] UNIQUE NONCLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [FK_MovFisc0_FIS_Finalidade] FOREIGN KEY ([FinalidadeID]) REFERENCES [dbo].[FIS_Finalidade] ([FinalidadeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [FK_MovFisc0_LkpFisc0] FOREIGN KEY ([ModeloID]) REFERENCES [dbo].[LkpFisc0] ([ModeloID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovFisc0] ADD CONSTRAINT [FK_MovFisc0_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[MovFisc0].[DtEmissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFisc0].[Consumidor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovFisc0].[modFrete]'
GO
