CREATE TABLE [dbo].[LKPVeic1]
(
[EspecieID] [tinyint] NOT NULL,
[Especie] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[LKPVeic1] ADD CONSTRAINT [PK_LKPVeic1] PRIMARY KEY CLUSTERED ([EspecieID])
GO
