CREATE TABLE [dbo].[COM_ITE_MOV]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Seq] [int] NOT NULL,
[ItemID] [int] NOT NULL,
[VL_CustoBruto] [decimal] (18, 10) NOT NULL,
[VL_CustoMedio] [decimal] (18, 10) NOT NULL,
[QT_Estoque] [decimal] (18, 3) NOT NULL,
[Comissao] [decimal] (6, 4) NOT NULL,
[MaxDesconto] [decimal] (6, 4) NOT NULL,
[MedidaID] [tinyint] NOT NULL,
[Fator] [decimal] (18, 6) NOT NULL,
[Estoque] [bit] NOT NULL,
[Quantidade] [decimal] (18, 3) NOT NULL,
[VL_Pedido] [decimal] (18, 2) NOT NULL,
[VL_Unitario] [decimal] (18, 10) NOT NULL,
[VL_Item] AS (CONVERT([decimal](18,6),([Quantidade]*[fator])*[VL_Unitario],(0))) PERSISTED,
[Desconto] [decimal] (18, 15) NOT NULL,
[VL_Desconto] AS (CONVERT([decimal](18,6),((([VL_Unitario]*[Quantidade])*[Fator])*[Desconto])/(100),(0))) PERSISTED,
[VL_Liquido] AS (CONVERT([decimal](18,6),(([VL_Unitario]*[Quantidade])*[Fator])*(((100)-[Desconto])/(100)),(0))) PERSISTED,
[VL_Frete] [decimal] (18, 2) NOT NULL,
[VL_Seguro] [decimal] (18, 2) NOT NULL,
[VL_Outro] [decimal] (18, 2) NOT NULL,
[VL_Operacional] [decimal] (18, 6) NOT NULL,
[VL_Anexo] [decimal] (18, 2) NOT NULL,
[CFOP] [smallint] NOT NULL,
[OrigemID] [tinyint] NOT NULL,
[Descricao] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[CST_IPI] [tinyint] NOT NULL,
[BC_IPI] [decimal] (18, 2) NOT NULL,
[Aliq_IPI] [decimal] (6, 4) NOT NULL,
[Vl_IPI] AS (CONVERT([decimal](18,6),([BC_IPI]*[Aliq_IPI])/(100),(0))) PERSISTED,
[CST_ICMS] [smallint] NOT NULL,
[Modalidade_ICMS] [tinyint] NOT NULL,
[ReducaoICMS] [decimal] (7, 4) NOT NULL,
[BC_ICMS] [decimal] (18, 2) NOT NULL,
[Aliq_ICMS] [decimal] (6, 4) NOT NULL,
[Vl_ICMS] AS (CONVERT([decimal](18,6),([BC_ICMS]*[Aliq_ICMS])/(100),(0))) PERSISTED,
[Aliq_FCP] [decimal] (6, 4) NOT NULL,
[Vl_FCP] AS (CONVERT([decimal](18,6),([BC_ICMS]*[Aliq_FCP])/(100),(0))),
[VL_DIFAL] AS (CONVERT([decimal](18,6),case  when [CFOP]=(6108) AND [Aliq_ICMSSub]>(0) then ([BC_ICMS]*([Aliq_ICMSSub]-[Aliq_ICMS]))/(100) else (0) end,(0))),
[Modalidade_ICMSSub] [tinyint] NOT NULL,
[MVA] [decimal] (18, 15) NOT NULL,
[BC_ICMSSub] [decimal] (18, 2) NOT NULL,
[Aliq_ICMSSub] [decimal] (6, 4) NOT NULL,
[Vl_ICMSSUB] AS (CONVERT([decimal](18,6),([BC_ICMSSub]*[Aliq_ICMSSub])/(100)-case  when [BC_ICMSSub]=(0) then (0) else ([BC_ICMS]*[Aliq_ICMS])/(100) end,(0))) PERSISTED,
[CST_II] [tinyint] NOT NULL,
[BC_II] [decimal] (18, 2) NOT NULL,
[Aliq_II] [decimal] (6, 4) NOT NULL,
[VL_II] AS (CONVERT([decimal](18,6),([BC_II]*[Aliq_II])/(100),(0))) PERSISTED,
[CST_ISS] [tinyint] NOT NULL,
[BC_ISS] [decimal] (18, 2) NOT NULL,
[Aliq_ISS] [decimal] (6, 4) NOT NULL,
[VL_ISS] AS (CONVERT([decimal](18,6),([BC_ISS]*[Aliq_ISS])/(100),(0))) PERSISTED,
[CST_PIS] [tinyint] NOT NULL,
[BC_PIS] [decimal] (18, 2) NOT NULL,
[Aliq_PIS] [decimal] (6, 4) NOT NULL,
[Vl_PIS] AS (CONVERT([decimal](18,6),([BC_PIS]*[Aliq_PIS])/(100),(0))) PERSISTED,
[CST_COFINS] [tinyint] NOT NULL,
[BC_COFINS] [decimal] (18, 2) NOT NULL,
[Aliq_COFINS] [decimal] (6, 4) NOT NULL,
[Vl_COFINS] AS (CONVERT([decimal](18,6),([BC_Cofins]*[Aliq_Cofins])/(100),(0))) PERSISTED,
[BC_ICMSCONS] [decimal] (18, 2) NOT NULL,
[Totalizar] [bit] NOT NULL,
[Valido] [bit] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[COM_ITE_MOV] ADD CONSTRAINT [PK_MovItem] PRIMARY KEY NONCLUSTERED ([UnidadeID], [TipoID], [Nota], [Seq])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IDX_COM_ITE_MOV_Chave_Seq] ON [dbo].[COM_ITE_MOV] ([Chave], [Seq]) INCLUDE ([VL_Frete], [VL_Seguro], [VL_Outro], [VL_Operacional], [VL_Anexo])
GO
CREATE CLUSTERED INDEX [IX_COM_ITE_MOV_UnidadeID_ItemID] ON [dbo].[COM_ITE_MOV] ([UnidadeID], [ItemID])
GO
ALTER TABLE [dbo].[COM_ITE_MOV] ADD CONSTRAINT [FK_COM_ITE_MOV_CadMedi0] FOREIGN KEY ([MedidaID]) REFERENCES [dbo].[COM_ITE_MED] ([MedidaID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_MOV] ADD CONSTRAINT [FK_COM_ITE_MOV_COM_ITE_UND] FOREIGN KEY ([UnidadeID], [ItemID]) REFERENCES [dbo].[COM_ITE_UND] ([UnidadeID], [ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_MOV] ADD CONSTRAINT [FK_COM_ITE_MOV_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_CustoBruto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_CustoMedio]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[QT_Estoque]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Comissao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[MedidaID]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[Fator]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[Estoque]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Quantidade]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Pedido]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Unitario]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Desconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Frete]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Seguro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Outro]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Operacional]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[VL_Anexo]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CFOP]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[OrigemID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_IPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_IPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_IPI]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Modalidade_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[ReducaoICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_ICMS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_FCP]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Modalidade_ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[MVA]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_ICMSSub]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_II]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_II]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_II]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_ISS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_ISS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_ISS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_PIS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[CST_COFINS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_COFINS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[Aliq_COFINS]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_MOV].[BC_ICMSCONS]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[Totalizar]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[COM_ITE_MOV].[Valido]'
GO
