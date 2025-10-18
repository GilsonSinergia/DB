CREATE TABLE [dbo].[FIN_CBR_CAD]
(
[ConvenioID] [tinyint] NOT NULL,
[ContaID] [int] NOT NULL,
[CodigoCedente] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[TipoCobranca] [tinyint] NOT NULL,
[LayoutCobranca] [tinyint] NOT NULL,
[LayotImpressao] [tinyint] NOT NULL,
[Homologacao] [bit] NOT NULL,
[NossoNumero] [int] NOT NULL,
[Mensagem] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[DiasProtesto] [int] NOT NULL,
[Especie] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Moeda] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Aceite] [bit] NOT NULL,
[Carteira] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[LocalPagamento] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Remessa] [int] NOT NULL,
[INSTRUCAO_1] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[INSTRUCAO_2] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[FIN_CBR_CAD] ADD CONSTRAINT [PK_FIN_CBR_CAD] PRIMARY KEY CLUSTERED ([ConvenioID])
GO
ALTER TABLE [dbo].[FIN_CBR_CAD] ADD CONSTRAINT [FK_FIN_CBR_CAD_CadCont0] FOREIGN KEY ([ContaID]) REFERENCES [dbo].[CadCont0] ([ContaID])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[FIN_CBR_CAD].[ConvenioID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_CAD].[LayoutCobranca]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_CAD].[LayotImpressao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[FIN_CBR_CAD].[Homologacao]'
GO
