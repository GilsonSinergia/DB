CREATE TABLE [dbo].[Sys_Modulos]
(
[ClassID] [smallint] NOT NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Titulo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ShortCut] [int] NOT NULL,
[Nivel_C] [tinyint] NOT NULL,
[Nivel_R] [tinyint] NOT NULL,
[Nivel_U] [tinyint] NOT NULL,
[Nivel_D] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[Sys_Modulos] ADD CONSTRAINT [PK_Sys_Modulos] PRIMARY KEY CLUSTERED ([ClassID])
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Sys_Modulos] ON [dbo].[Sys_Modulos] ([Nome])
GO
