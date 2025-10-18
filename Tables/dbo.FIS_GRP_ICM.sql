CREATE TABLE [dbo].[FIS_GRP_ICM]
(
[GFID] [tinyint] NOT NULL,
[OperacaoID] [tinyint] NOT NULL,
[UFID] [tinyint] NOT NULL,
[CFOP] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[CST_ICMS] [smallint] NOT NULL,
[Modalidade_ICMS] [tinyint] NOT NULL,
[ICMS] [decimal] (6, 2) NOT NULL,
[ReducaoICMS] [decimal] (6, 3) NOT NULL,
[MVA_Pauta] [decimal] (18, 15) NOT NULL,
[ICMSSub] [decimal] (6, 2) NOT NULL,
[Modalidade_ICMSSub] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_GRP_ICM] ADD CONSTRAINT [PK_FIS_GRP_ICM] PRIMARY KEY CLUSTERED ([GFID], [OperacaoID], [UFID])
GO
ALTER TABLE [dbo].[FIS_GRP_ICM] ADD CONSTRAINT [FK_FIS_GRP_ICM_FIS_CFOP] FOREIGN KEY ([CFOP]) REFERENCES [dbo].[FIS_CFOP] ([CFOP]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FIS_GRP_ICM] ADD CONSTRAINT [FK_FIS_GRP_ICM_FIS_GRP_TRB] FOREIGN KEY ([GFID], [OperacaoID]) REFERENCES [dbo].[FIS_GRP_TRB] ([GFID], [OperacaoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[FIS_GRP_ICM] ADD CONSTRAINT [FK_FIS_GRP_ICM_LkpUF0] FOREIGN KEY ([UFID]) REFERENCES [dbo].[LkpUF0] ([UFID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[CST_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[Modalidade_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[ReducaoICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[MVA_Pauta]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_ICM].[Modalidade_ICMSSub]'
GO
