CREATE TABLE [dbo].[COM_ITE_GRP]
(
[GrupoID] [int] NOT NULL,
[Grupo] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[MaxDesconto] [float] NOT NULL,
[MaxComissao] [float] NOT NULL,
[FotoID] [int] NULL
)
GO
ALTER TABLE [dbo].[COM_ITE_GRP] ADD CONSTRAINT [PK_Grupos] PRIMARY KEY NONCLUSTERED ([GrupoID])
GO
CREATE NONCLUSTERED INDEX [NOMGRP] ON [dbo].[COM_ITE_GRP] ([Grupo])
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_GRP].[MaxDesconto]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_GRP].[MaxComissao]'
GO
