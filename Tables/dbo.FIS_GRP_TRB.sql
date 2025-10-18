CREATE TABLE [dbo].[FIS_GRP_TRB]
(
[GFID] [tinyint] NOT NULL,
[OperacaoID] [tinyint] NOT NULL,
[CFOP] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[CST_IPI] [tinyint] NOT NULL,
[Aliq_IPI] [decimal] (6, 2) NOT NULL,
[CST_ICMS] [smallint] NOT NULL,
[Modalidade_ICMS] [tinyint] NOT NULL,
[ReducaoICMS] [decimal] (6, 3) NOT NULL,
[BC_ICMS] [tinyint] NOT NULL,
[Aliq_ICMS] [decimal] (6, 2) NOT NULL,
[Modalidade_ICMSSub] [tinyint] NOT NULL,
[MVA_Pauta] [decimal] (18, 15) NOT NULL,
[Aliq_ICMSSub] [decimal] (6, 2) NOT NULL,
[CST_PIS] [tinyint] NOT NULL,
[Aliq_PIS] [decimal] (6, 2) NOT NULL,
[CST_COFINS] [tinyint] NOT NULL,
[Aliq_COFINS] [decimal] (6, 2) NOT NULL,
[MSG] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[FIS_GRP_TRB] ADD CONSTRAINT [PK_FIS_GRP_TRB] PRIMARY KEY CLUSTERED ([GFID], [OperacaoID])
GO
ALTER TABLE [dbo].[FIS_GRP_TRB] ADD CONSTRAINT [FK_FIS_GRP_TRB_FIS_ITE_GRP_CAD] FOREIGN KEY ([GFID]) REFERENCES [dbo].[FIS_ITE_GRP_CAD] ([GFID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[CST_IPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Aliq_IPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[CST_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Modalidade_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[ReducaoICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[BC_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Aliq_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Modalidade_ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[MVA_Pauta]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Aliq_ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[CST_PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Aliq_PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[CST_COFINS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_GRP_TRB].[Aliq_COFINS]'
GO
