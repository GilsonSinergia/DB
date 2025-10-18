CREATE TABLE [dbo].[FIS_Finalidade]
(
[FinalidadeID] [tinyint] NOT NULL,
[Finalidade] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_Finalidade] ADD CONSTRAINT [PK_FISNFEFinalidade] PRIMARY KEY CLUSTERED ([FinalidadeID])
GO
