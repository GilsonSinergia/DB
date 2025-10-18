CREATE TABLE [dbo].[TMS_Veiculo]
(
[VeiculoID] [tinyint] NOT NULL,
[Placa] [char] (7) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Tara] [float] NOT NULL,
[Area] [float] NOT NULL
)
GO
ALTER TABLE [dbo].[TMS_Veiculo] ADD CONSTRAINT [PK_TMS_Veiculo] PRIMARY KEY CLUSTERED ([VeiculoID])
GO
