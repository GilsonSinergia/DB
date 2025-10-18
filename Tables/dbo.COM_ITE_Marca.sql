CREATE TABLE [dbo].[COM_ITE_Marca]
(
[MarcaID] [int] NOT NULL,
[MaxDesconto] [float] NOT NULL,
[MaxComissao] [float] NOT NULL,
[Marca] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_Marca] ADD CONSTRAINT [PK_COM_ITE_Marca] PRIMARY KEY CLUSTERED ([MarcaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Marca].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Marca].[MaxComissao]'
GO
