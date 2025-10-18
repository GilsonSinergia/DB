CREATE TABLE [dbo].[COM_ITE_Destino]
(
[DestinoID] [tinyint] NOT NULL,
[Destino] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Destino] ADD CONSTRAINT [PK_LkpProd0] PRIMARY KEY CLUSTERED ([DestinoID])
GO
