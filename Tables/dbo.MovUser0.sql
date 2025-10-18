CREATE TABLE [dbo].[MovUser0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Data] [datetime] NOT NULL,
[UsuarioID] [int] NOT NULL,
[Historico] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovUser0] ADD CONSTRAINT [PK_MovUser0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [Data])
GO
ALTER TABLE [dbo].[MovUser0] ADD CONSTRAINT [FK_MovUser0_CadUser0] FOREIGN KEY ([UsuarioID]) REFERENCES [dbo].[CadUser0] ([UsuarioID])
GO
ALTER TABLE [dbo].[MovUser0] ADD CONSTRAINT [FK_MovUser0_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
