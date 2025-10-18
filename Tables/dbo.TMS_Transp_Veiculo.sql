CREATE TABLE [dbo].[TMS_Transp_Veiculo]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[ID] [tinyint] NOT NULL,
[Placa] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[UF] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Peso] [decimal] (15, 4) NOT NULL,
[RNTRC] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[TMS_Transp_Veiculo] ADD CONSTRAINT [PK_TMS_Tansp_Veiculo] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [ID])
GO
ALTER TABLE [dbo].[TMS_Transp_Veiculo] ADD CONSTRAINT [FK_TMS_Transp_Veiculo_MovNota0] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Transp_Veiculo].[Peso]'
GO
