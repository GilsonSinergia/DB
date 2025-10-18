CREATE TABLE [dbo].[SYS_Auditoria]
(
[AuditoriaID] [int] NOT NULL IDENTITY(1, 1),
[Data] [datetime] NOT NULL CONSTRAINT [DF_SYS_Auditoria_Data] DEFAULT (getdate()),
[Host_Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_SYS_Auditoria_Host_Nome] DEFAULT (host_name()),
[DBUserNome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_SYS_Auditoria_DBUserNome] DEFAULT (suser_name()),
[LogType] [tinyint] NOT NULL,
[APPNome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_SYS_Auditoria_APP_NAME] DEFAULT (app_name()),
[APPUserNome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Titulo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Mensagem] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[SYS_Auditoria] ADD CONSTRAINT [PK_SYS_Auditoria] PRIMARY KEY CLUSTERED ([AuditoriaID])
GO
