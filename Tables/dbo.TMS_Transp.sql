CREATE TABLE [dbo].[TMS_Transp]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Documento] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[IE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Endereco] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Municipio] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[TMS_Transp] ADD CONSTRAINT [PK_TMS_Transp] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[TMS_Transp] ADD CONSTRAINT [FK_TMS_Transp_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota])
GO
