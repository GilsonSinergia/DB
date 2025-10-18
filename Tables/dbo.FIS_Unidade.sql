CREATE TABLE [dbo].[FIS_Unidade]
(
[UnidadeID] [tinyint] NOT NULL,
[RegimeID] [tinyint] NOT NULL,
[CaptalSocial] [decimal] (6, 2) NOT NULL,
[CSLL] [decimal] (6, 2) NOT NULL,
[IRPJ] [decimal] (8, 2) NOT NULL,
[COFINS] [decimal] (6, 2) NOT NULL,
[PIS] [decimal] (6, 2) NOT NULL,
[CPP] [decimal] (6, 2) NOT NULL,
[ICMS] [decimal] (8, 2) NOT NULL,
[ISS] [decimal] (8, 2) NOT NULL,
[IDCSC] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[CSC] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[PerfilID] [tinyint] NOT NULL,
[Atividade] [tinyint] NOT NULL,
[ClasseIPI] [tinyint] NOT NULL,
[IND_NAT_PJ] [tinyint] NOT NULL,
[IND_SIT_ESP] [tinyint] NOT NULL,
[COD_INC_TRIB] [tinyint] NOT NULL,
[IND_APRO_CRED] [tinyint] NOT NULL,
[COD_TIPO_CONT] [tinyint] NOT NULL,
[IND_REG_CUM] [tinyint] NOT NULL,
[REC_BRU_NCUM_TRIB_MI] [float] NOT NULL,
[REC_BRU_NCUM_NT_MI] [float] NOT NULL,
[REC_BRU_NCUM_EXP] [float] NOT NULL,
[REC_BRU_CUM] [float] NOT NULL,
[IND_ESCRI] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_Unidade] ADD CONSTRAINT [PK_FIS_Unidade_1] PRIMARY KEY CLUSTERED ([UnidadeID])
GO
ALTER TABLE [dbo].[FIS_Unidade] ADD CONSTRAINT [FK_FIS_Unidade_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[FIS_Unidade].[RegimeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[CaptalSocial]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[CSLL]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IRPJ]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[COFINS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[CPP]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[ISS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[PerfilID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[Atividade]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[ClasseIPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IND_NAT_PJ]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IND_SIT_ESP]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[COD_INC_TRIB]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IND_APRO_CRED]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[COD_TIPO_CONT]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IND_REG_CUM]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[REC_BRU_NCUM_TRIB_MI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[REC_BRU_NCUM_NT_MI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[REC_BRU_NCUM_EXP]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[REC_BRU_CUM]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIS_Unidade].[IND_ESCRI]'
GO
