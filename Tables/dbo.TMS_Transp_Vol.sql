CREATE TABLE [dbo].[TMS_Transp_Vol]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[ID] [tinyint] NOT NULL,
[Quantidade] [int] NOT NULL,
[Especie] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Marca] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[nVol] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[PL] [float] NOT NULL,
[PB] [float] NOT NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[TMS_Transp_Vol] ADD CONSTRAINT [PK_TMS_Transp_Vol] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [ID])
GO
ALTER TABLE [dbo].[TMS_Transp_Vol] ADD CONSTRAINT [FK_TMS_Transp_Vol_TMS_Transp] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[TMS_Transp] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Transp_Vol].[PL]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Transp_Vol].[PB]'
GO
