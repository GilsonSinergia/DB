CREATE TABLE [dbo].[CTE_Conhecimento]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Modelo] [tinyint] NOT NULL,
[Chave] [char] (44) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Serie] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[SubSerie] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[NUM_DOC] [int] NOT NULL,
[DtEmissao] [datetime] NOT NULL,
[tpCTe] [tinyint] NOT NULL,
[CHV_CTE_REF] [char] (44) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Total] [decimal] (18, 2) NOT NULL,
[TotalDesconto] [decimal] (18, 2) NOT NULL,
[TipoFrete] [tinyint] NOT NULL,
[TotalServico] [decimal] (18, 2) NOT NULL,
[CST_ICMS] [smallint] NOT NULL,
[BC_ICMS] [decimal] (18, 2) NOT NULL,
[ICMS] [decimal] (9, 2) NOT NULL,
[VL_NT] [decimal] (18, 2) NOT NULL,
[IND_NAT_FRTID] [tinyint] NULL,
[CST_PIS] [tinyint] NOT NULL,
[NAT_BC_CRED] [tinyint] NULL,
[ALIQ_PIS] [decimal] (9, 2) NOT NULL,
[BC_PIS] [decimal] (18, 2) NOT NULL,
[BC_Cofins] [decimal] (18, 2) NOT NULL,
[ALIQ_Cofins] [decimal] (9, 2) NOT NULL,
[CST_Cofins] [tinyint] NOT NULL,
[CFOP] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[CTE_Conhecimento] ADD CONSTRAINT [PK_CTE_Conhecimento] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[CTE_Conhecimento] ADD CONSTRAINT [FK_CTE_Conhecimento_BCCreditoPisCofins] FOREIGN KEY ([NAT_BC_CRED]) REFERENCES [dbo].[BCCreditoPisCofins] ([NAT_BC_CREDID])
GO
ALTER TABLE [dbo].[CTE_Conhecimento] ADD CONSTRAINT [FK_CTE_Conhecimento_Cte_Tipo] FOREIGN KEY ([tpCTe]) REFERENCES [dbo].[Cte_Tipo] ([TipoCteID])
GO
ALTER TABLE [dbo].[CTE_Conhecimento] ADD CONSTRAINT [FK_CTE_Conhecimento_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[CTE_Conhecimento] ADD CONSTRAINT [FK_CTE_Conhecimento_NaturezaFrete] FOREIGN KEY ([IND_NAT_FRTID]) REFERENCES [dbo].[NaturezaFrete] ([IND_NAT_FRTID])
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[CTE_Conhecimento].[DtEmissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CTE_Conhecimento].[TotalDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CTE_Conhecimento].[TotalServico]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CTE_Conhecimento].[CST_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CTE_Conhecimento].[BC_ICMS]'
GO
