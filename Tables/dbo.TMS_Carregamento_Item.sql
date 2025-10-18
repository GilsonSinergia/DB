CREATE TABLE [dbo].[TMS_Carregamento_Item]
(
[UnidadeID] [int] NOT NULL,
[CargaID] [int] NOT NULL,
[Chave] [char] (14) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Ordem] [tinyint] NOT NULL,
[Distancia] [int] NOT NULL,
[Tempo] [int] NOT NULL,
[OBS] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[OBS_Entrega] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[TMS_Carregamento_Item] ADD CONSTRAINT [PK_TMS_Carregamento_Item] PRIMARY KEY CLUSTERED ([UnidadeID], [CargaID], [Chave])
GO
ALTER TABLE [dbo].[TMS_Carregamento_Item] ADD CONSTRAINT [FK_TMS_Carregamento_Item_MovNota0] FOREIGN KEY ([Chave]) REFERENCES [dbo].[MovNota0] ([Chave]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[TMS_Carregamento_Item] ADD CONSTRAINT [FK_TMS_Carregamento_Item_TMS_Carregamento] FOREIGN KEY ([UnidadeID], [CargaID]) REFERENCES [dbo].[TMS_Carregamento] ([UnidadeID], [CargaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Carregamento_Item].[Ordem]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Carregamento_Item].[Distancia]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[TMS_Carregamento_Item].[Tempo]'
GO
