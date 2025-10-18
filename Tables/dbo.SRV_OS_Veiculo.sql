CREATE TABLE [dbo].[SRV_OS_Veiculo]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[Placa] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[ModalidadeID] [tinyint] NOT NULL,
[KM] [int] NOT NULL,
[Tanque] [tinyint] NOT NULL,
[Sintoma] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Avarias] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Objetos] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[SRV_OS_Veiculo] ADD CONSTRAINT [PK_SRV_OS_Veiculo] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [Placa])
GO
ALTER TABLE [dbo].[SRV_OS_Veiculo] ADD CONSTRAINT [FK_SRV_OS_Veiculo_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SRV_OS_Veiculo] ADD CONSTRAINT [FK_SRV_OS_Veiculo_SRV_OS_Modalidade] FOREIGN KEY ([ModalidadeID]) REFERENCES [dbo].[SRV_OS_Modalidade] ([ModalidadeID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[SRV_OS_Veiculo] ADD CONSTRAINT [FK_SRV_OS_Veiculo_SRV_Veiculo] FOREIGN KEY ([Placa]) REFERENCES [dbo].[SRV_Veiculo] ([Placa]) ON DELETE CASCADE ON UPDATE CASCADE
GO
