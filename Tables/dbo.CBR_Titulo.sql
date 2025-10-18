CREATE TABLE [dbo].[CBR_Titulo]
(
[ConvenioID] [tinyint] NOT NULL,
[NossoNumero] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ChaveTitulo] [char] (18) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Aceite] [bit] NOT NULL,
[Protestar] [bit] NOT NULL,
[Carteira] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Modalidade] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Numero] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[VLDocumento] [float] NOT NULL,
[VLMoraJuros] [float] NOT NULL,
[VLDesconto] [float] NOT NULL,
[VLAbatimento] [float] NOT NULL,
[Multa] [float] NOT NULL,
[DtEmissao] [datetime] NOT NULL,
[DtVencimento] [datetime] NOT NULL,
[DtMoraJuros] [datetime] NULL,
[DtDesconto] [datetime] NULL,
[DtAbatimento] [datetime] NULL,
[DtProtesto] [datetime] NULL,
[DtBaixa] [datetime] NULL,
[Mensagem] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[StatusID] [tinyint] NOT NULL,
[TipoBoletoID] [tinyint] NULL,
[TipoOcorrencia] [tinyint] NULL,
[LocalPagamento] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[CBR_Titulo] ADD CONSTRAINT [PK_CBR_Titulo] PRIMARY KEY CLUSTERED ([ConvenioID], [NossoNumero])
GO
ALTER TABLE [dbo].[CBR_Titulo] ADD CONSTRAINT [FK_CBR_Titulo_CBR_Convenio] FOREIGN KEY ([ConvenioID]) REFERENCES [dbo].[CBR_Convenio] ([ConvenioID])
GO
ALTER TABLE [dbo].[CBR_Titulo] ADD CONSTRAINT [FK_CBR_Titulo_CBR_Titulo_Status] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[CBR_Titulo_Status] ([StatusID])
GO
ALTER TABLE [dbo].[CBR_Titulo] ADD CONSTRAINT [FK_CBR_Titulo_LkpEspecieDoc] FOREIGN KEY ([TipoBoletoID]) REFERENCES [dbo].[LkpEspecieDoc] ([TipoBoletoID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CBR_Titulo].[Protestar]'
GO
