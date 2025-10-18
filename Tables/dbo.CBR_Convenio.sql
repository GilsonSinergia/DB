CREATE TABLE [dbo].[CBR_Convenio]
(
[ConvenioID] [tinyint] NOT NULL,
[Convenio] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Carteira] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Modalidade] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[CNAB] [tinyint] NOT NULL,
[ContaID] [int] NOT NULL,
[Multa] [float] NOT NULL,
[JurosMora] [float] NOT NULL,
[Registrada] [bit] NOT NULL,
[PrazoDesconto] [tinyint] NOT NULL,
[PrazoProtesto] [tinyint] NOT NULL,
[PrazoBaixa] [tinyint] NOT NULL,
[LocalPagamento] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Mensagem] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[TamanhoNossoNumero] [tinyint] NOT NULL,
[ProximoNossNumero] [int] NOT NULL,
[ProximaRemessa] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[CBR_Convenio] ADD CONSTRAINT [PK_CBR_Convenio] PRIMARY KEY CLUSTERED ([ConvenioID])
GO
ALTER TABLE [dbo].[CBR_Convenio] ADD CONSTRAINT [FK_CBR_Convenio_CadCont0] FOREIGN KEY ([ContaID]) REFERENCES [dbo].[CadCont0] ([ContaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CBR_Convenio].[CNAB]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CBR_Convenio].[ProximoNossNumero]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CBR_Convenio].[ProximaRemessa]'
GO
