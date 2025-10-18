CREATE TABLE [dbo].[SRV_Veiculo_Modelo]
(
[MarcaID] [tinyint] NOT NULL,
[ModeloID] [smallint] NOT NULL,
[Modelo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[SRV_Veiculo_Modelo] ADD CONSTRAINT [PK_SRV_Veiculo_Modelo] PRIMARY KEY CLUSTERED ([MarcaID], [ModeloID])
GO
ALTER TABLE [dbo].[SRV_Veiculo_Modelo] ADD CONSTRAINT [FK_SRV_Veiculo_Modelo_SRV_Veiculo_Marca] FOREIGN KEY ([MarcaID]) REFERENCES [dbo].[SRV_Veiculo_Marca] ([MarcaID])
GO
