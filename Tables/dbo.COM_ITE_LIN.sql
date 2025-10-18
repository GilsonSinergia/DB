CREATE TABLE [dbo].[COM_ITE_LIN]
(
[LinhaID] [tinyint] NOT NULL,
[Linha] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[MaxDesconto] [float] NOT NULL,
[MaxComissao] [float] NOT NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_LIN] ADD CONSTRAINT [PK_CadLinh0] PRIMARY KEY CLUSTERED ([LinhaID])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_LIN].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_LIN].[MaxComissao]'
GO
