CREATE TABLE [dbo].[DFe_XML]
(
[ID] [char] (44) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[XML] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Lote] [int] NOT NULL,
[StatusID] [smallint] NOT NULL,
[MSG] [varchar] (200) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[XML_DOC] AS (CONVERT([xml],[XML],(0)))
)
GO
ALTER TABLE [dbo].[DFe_XML] ADD CONSTRAINT [PK_DFe_XML] PRIMARY KEY CLUSTERED ([ID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[DFe_XML].[Lote]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[DFe_XML].[StatusID]'
GO
