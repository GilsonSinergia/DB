CREATE TABLE [dbo].[rptJOIN]
(
[Name] [sys].[sysname] NOT NULL,
[FK_Table] [sys].[sysname] NOT NULL,
[PK_Table] [sys].[sysname] NOT NULL,
[FK_Campo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Operador] [varchar] (19) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[JoinType] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[PK_Campo] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
