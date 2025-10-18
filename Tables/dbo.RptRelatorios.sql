CREATE TABLE [dbo].[RptRelatorios]
(
[RelatorioID] [int] NOT NULL,
[PastaID] [int] NOT NULL,
[Nome] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Tamanho] [int] NOT NULL,
[Tipo] [int] NOT NULL,
[DtModificado] [datetime] NOT NULL,
[DtApagado] [datetime] NULL,
[Modelo] [varbinary] (max) NULL
)
GO
ALTER TABLE [dbo].[RptRelatorios] ADD CONSTRAINT [PK_RptRelatorios] PRIMARY KEY CLUSTERED ([RelatorioID])
GO
