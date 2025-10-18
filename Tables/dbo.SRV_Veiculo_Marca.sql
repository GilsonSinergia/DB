CREATE TABLE [dbo].[SRV_Veiculo_Marca]
(
[MarcaID] [tinyint] NOT NULL,
[Marca] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[SRV_Veiculo_Marca] ADD CONSTRAINT [PK_SRV_Veiculo_Marca] PRIMARY KEY CLUSTERED ([MarcaID])
GO
