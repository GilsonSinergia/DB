CREATE TABLE [dbo].[FIS_NF_Transportador]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Documento] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[IE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Endereco] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Municipio] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[FIS_NF_Transportador] ADD CONSTRAINT [PK_FIS_NF_Transportador] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[FIS_NF_Transportador] ADD CONSTRAINT [FK_FIS_NF_Transportador_MovFisc0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovFisc0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
