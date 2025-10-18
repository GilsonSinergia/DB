CREATE TABLE [dbo].[PES_Rotulo_CAD]
(
[PES_Rotulo_ID] [tinyint] NOT NULL,
[PES_Rotulo_Nome] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[PES_Rotulo_CAD] ADD CONSTRAINT [PK_PES_Rotulo_+CAD] PRIMARY KEY CLUSTERED ([PES_Rotulo_ID])
GO
