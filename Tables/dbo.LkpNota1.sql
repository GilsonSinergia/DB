CREATE TABLE [dbo].[LkpNota1]
(
[StatusID] [tinyint] NOT NULL,
[Status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Ativo] [bit] NOT NULL,
[Disponivel] AS (case  when [StatusID]=(2) OR [StatusID]=(1) then (1) else (0) end),
[Contabil] AS (case  when [StatusID]=(2) then (1) else (0) end)
)
GO
ALTER TABLE [dbo].[LkpNota1] ADD CONSTRAINT [PK_LkpEsto1] PRIMARY KEY CLUSTERED ([StatusID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[LkpNota1].[Ativo]'
GO
