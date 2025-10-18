CREATE TABLE [dbo].[MovTran0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[CarregamentoID] [int] NULL,
[Documento] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[IE] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Nome] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Endereco] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Municipio] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[VeiculoPlaca] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[VeiculoUF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[VeiculoRNTRC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque1Placa] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque1UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque1RNTRC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque2Placa] [varchar] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque2UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Reboque2RNTRC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Volumes] [int] NULL,
[Marca] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Especie] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovTran0] ADD CONSTRAINT [PK_NotTran0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[MovTran0] ADD CONSTRAINT [FK_MovTran0_TMSCarregamento] FOREIGN KEY ([UnidadeID], [CarregamentoID]) REFERENCES [dbo].[TMSCarregamento] ([UnidadeID], [CarregamentoID])
GO
ALTER TABLE [dbo].[MovTran0] WITH NOCHECK ADD CONSTRAINT [FK_NotTran0_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
