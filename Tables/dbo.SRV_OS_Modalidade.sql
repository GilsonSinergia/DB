CREATE TABLE [dbo].[SRV_OS_Modalidade]
(
[ModalidadeID] [tinyint] NOT NULL,
[Modalidade] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[SRV_OS_Modalidade] ADD CONSTRAINT [PK_SRV_OS_Modalidade] PRIMARY KEY CLUSTERED ([ModalidadeID])
GO
