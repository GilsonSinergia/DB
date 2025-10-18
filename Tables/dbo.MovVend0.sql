CREATE TABLE [dbo].[MovVend0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[PessoaID] [int] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovVend0] ADD CONSTRAINT [PK_MovVend0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[MovVend0] ADD CONSTRAINT [FK_MovVend0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[MovVend0] ADD CONSTRAINT [FK_MovVend0_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
