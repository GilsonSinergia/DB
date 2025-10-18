CREATE TABLE [dbo].[TMS_Rota]
(
[RotaID] [tinyint] NOT NULL,
[Rota] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[TMS_Rota] ADD CONSTRAINT [PK_TMS_Rota] PRIMARY KEY CLUSTERED ([RotaID])
GO
