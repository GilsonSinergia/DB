CREATE TABLE [dbo].[MovConf0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Conferencia] [tinyint] NOT NULL,
[DtInicio] [datetime] NOT NULL,
[DtTermino] [datetime] NOT NULL,
[UsuarioID] [int] NOT NULL,
[Aprovada] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[MovConf0] ADD CONSTRAINT [PK_MovConf0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [Conferencia])
GO
ALTER TABLE [dbo].[MovConf0] ADD CONSTRAINT [FK_MovConf0_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DataHora]', N'[dbo].[MovConf0].[DtInicio]'
GO
EXEC sp_bindefault N'[dbo].[DataHora]', N'[dbo].[MovConf0].[DtTermino]'
GO
