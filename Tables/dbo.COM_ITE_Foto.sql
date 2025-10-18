CREATE TABLE [dbo].[COM_ITE_Foto]
(
[FotoID] [int] NOT NULL,
[DtFoto] [datetime] NOT NULL,
[Foto] [varbinary] (max) NOT NULL,
[Tipo] [tinyint] NOT NULL,
[Descricao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Foto] ADD CONSTRAINT [PK_COM_ITE_Foto] PRIMARY KEY CLUSTERED ([FotoID])
GO
EXEC sp_bindefault N'[dbo].[DataHora]', N'[dbo].[COM_ITE_Foto].[DtFoto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Foto].[Tipo]'
GO
