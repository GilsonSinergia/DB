CREATE TABLE [dbo].[RPT_Balanco]
(
[Ultima] [int] NOT NULL,
[Dia] [datetime] NULL,
[DataHora] [datetime] NOT NULL,
[BlocoID] [int] NOT NULL,
[Bloco] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ID] [int] NOT NULL,
[Historico] [varchar] (2550) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[valor] [float] NULL,
[Soma] [bit] NULL
)
GO
