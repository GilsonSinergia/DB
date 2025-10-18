CREATE TABLE [dbo].[FIS_NF_TRS_Veiculo]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[ID] [tinyint] NOT NULL,
[Placa] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[RNTC] [varchar] (120) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[FIS_NF_TRS_Veiculo] ADD CONSTRAINT [PK_FIS_NF_TRS_Veiculo] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [ID])
GO
ALTER TABLE [dbo].[FIS_NF_TRS_Veiculo] ADD CONSTRAINT [FK_FIS_NF_TRS_Veiculo_MovFisc0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovFisc0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
