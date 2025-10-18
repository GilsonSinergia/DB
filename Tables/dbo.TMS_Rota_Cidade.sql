CREATE TABLE [dbo].[TMS_Rota_Cidade]
(
[RotaID] [tinyint] NOT NULL,
[CidadeID] [int] NOT NULL,
[Ordem] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TMS_Rota_Cidade] ADD CONSTRAINT [PK_TMS_Rota_Cidade] PRIMARY KEY CLUSTERED ([RotaID], [CidadeID])
GO
ALTER TABLE [dbo].[TMS_Rota_Cidade] ADD CONSTRAINT [FK_TMS_Rota_Cidade_CadCida0] FOREIGN KEY ([CidadeID]) REFERENCES [dbo].[CadCida0] ([CidadeID])
GO
ALTER TABLE [dbo].[TMS_Rota_Cidade] ADD CONSTRAINT [FK_TMS_Rota_Cidade_TMS_Rota] FOREIGN KEY ([RotaID]) REFERENCES [dbo].[TMS_Rota] ([RotaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
