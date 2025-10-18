CREATE TABLE [dbo].[SRV_ITE_CAD]
(
[ServicoID] [tinyint] NOT NULL,
[Servico] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ValorHora] [money] NOT NULL,
[Duracao] [decimal] (18, 2) NOT NULL
)
GO
ALTER TABLE [dbo].[SRV_ITE_CAD] ADD CONSTRAINT [PK_SRV_ITE_CAD] PRIMARY KEY CLUSTERED ([ServicoID])
GO
