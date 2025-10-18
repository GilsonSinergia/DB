CREATE TABLE [dbo].[FIN_CBR_Titulo]
(
[ConvenioID] [tinyint] NOT NULL,
[NossoNumero] [int] NOT NULL,
[ChaveTitulo] [char] (18) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Carteira] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Especie] [char] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Aceite] [bit] NOT NULL,
[DtLancamento] [datetime] NOT NULL,
[DtVencimento] [datetime] NOT NULL,
[Valor] [dbo].[Dinheiro] NOT NULL,
[Desconto] [dbo].[Dinheiro] NOT NULL,
[Acrecimo] [dbo].[Dinheiro] NOT NULL,
[Juros] [dbo].[Dinheiro] NOT NULL,
[Multa] [dbo].[Dinheiro] NOT NULL,
[LocalPagamento] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[INSTRUCAO_1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[INSTRUCAO_2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[DtMoraJuros] [datetime] NULL,
[DtDesconto] [datetime] NULL,
[DtAbatimento] [datetime] NULL,
[DtProtesto] [datetime] NULL,
[DtBaixa] [datetime] NULL,
[Remessa] [int] NULL
)
GO
ALTER TABLE [dbo].[FIN_CBR_Titulo] ADD CONSTRAINT [PK_FIN_CBR_Titulo_1] PRIMARY KEY CLUSTERED ([ConvenioID], [NossoNumero])
GO
ALTER TABLE [dbo].[FIN_CBR_Titulo] ADD CONSTRAINT [FK_FIN_CBR_Titulo_FIN_CBR_CAD1] FOREIGN KEY ([ConvenioID]) REFERENCES [dbo].[FIN_CBR_CAD] ([ConvenioID])
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[FIN_CBR_Titulo].[DtLancamento]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[FIN_CBR_Titulo].[DtVencimento]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_Titulo].[Valor]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_Titulo].[Desconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_Titulo].[Acrecimo]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_Titulo].[Juros]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_Titulo].[Multa]'
GO
