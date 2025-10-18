CREATE TABLE [dbo].[Sys_Modulo_Politica]
(
[ClassID] [smallint] NOT NULL,
[ObjectName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Nivel] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[Sys_Modulo_Politica] ADD CONSTRAINT [PK_Sys_Modulo_Politica_1] PRIMARY KEY CLUSTERED ([ClassID], [ObjectName])
GO
ALTER TABLE [dbo].[Sys_Modulo_Politica] ADD CONSTRAINT [FK_Sys_Modulo_Politica_Sys_Modulos] FOREIGN KEY ([ClassID]) REFERENCES [dbo].[Sys_Modulos] ([ClassID])
GO
