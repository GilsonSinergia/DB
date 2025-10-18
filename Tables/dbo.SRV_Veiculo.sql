CREATE TABLE [dbo].[SRV_Veiculo]
(
[Placa] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[MarcaID] [tinyint] NOT NULL,
[ModeloID] [smallint] NOT NULL,
[ANO] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[SRV_Veiculo] ADD CONSTRAINT [PK_SRV_Veiculo] PRIMARY KEY CLUSTERED ([Placa])
GO
ALTER TABLE [dbo].[SRV_Veiculo] ADD CONSTRAINT [FK_SRV_Veiculo_SRV_Veiculo_Modelo1] FOREIGN KEY ([MarcaID], [ModeloID]) REFERENCES [dbo].[SRV_Veiculo_Modelo] ([MarcaID], [ModeloID]) ON UPDATE CASCADE
GO
