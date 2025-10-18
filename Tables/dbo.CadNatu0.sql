CREATE TABLE [dbo].[CadNatu0]
(
[NaturezaID] [tinyint] NOT NULL,
[Natureza] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[CadNatu0] ADD CONSTRAINT [PK_CadNatu0] PRIMARY KEY CLUSTERED ([NaturezaID])
GO
