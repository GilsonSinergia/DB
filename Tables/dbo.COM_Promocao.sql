CREATE TABLE [dbo].[COM_Promocao]
(
[PromocaoID] [int] NOT NULL,
[Promocao] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[DtInicio] [datetime] NOT NULL,
[DtTermino] [datetime] NOT NULL,
[PrecoID] [tinyint] NOT NULL,
[Cor] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[COM_Promocao] ADD CONSTRAINT [PK_EstPrdPro_0328E628] PRIMARY KEY CLUSTERED ([PromocaoID])
GO
ALTER TABLE [dbo].[COM_Promocao] ADD CONSTRAINT [FK_EstPrdPro_CadPrec0] FOREIGN KEY ([PrecoID]) REFERENCES [dbo].[COM_PRC_CAD] ([PrecoID]) ON UPDATE CASCADE
GO
