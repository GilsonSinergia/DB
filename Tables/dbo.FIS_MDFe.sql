CREATE TABLE [dbo].[FIS_MDFe]
(
[FIS_MDFe_ID] [int] NOT NULL,
[UnidadeID] [tinyint] NOT NULL,
[tpEmitenteID] [tinyint] NOT NULL,
[Modelo] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[Serie] [tinyint] NOT NULL,
[Numero] [int] NOT NULL,
[ModalID] [tinyint] NOT NULL,
[DtEmissao] [datetime] NOT NULL,
[ID] [char] (44) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[UFIni] [tinyint] NOT NULL,
[UFFin] [tinyint] NOT NULL,
[UM] [tinyint] NOT NULL,
[Quantidade] [float] NOT NULL,
[Total] [float] NOT NULL
)
GO
ALTER TABLE [dbo].[FIS_MDFe] ADD CONSTRAINT [PK_FIS_MDFe] PRIMARY KEY CLUSTERED ([FIS_MDFe_ID])
GO
ALTER TABLE [dbo].[FIS_MDFe] ADD CONSTRAINT [FK_FIS_MDFe_DFe_XML] FOREIGN KEY ([ID]) REFERENCES [dbo].[DFe_XML] ([ID])
GO
ALTER TABLE [dbo].[FIS_MDFe] ADD CONSTRAINT [FK_FIS_MDFe_LkpUF0] FOREIGN KEY ([UFIni]) REFERENCES [dbo].[LkpUF0] ([UFID])
GO
ALTER TABLE [dbo].[FIS_MDFe] ADD CONSTRAINT [FK_FIS_MDFe_LkpUF01] FOREIGN KEY ([UFFin]) REFERENCES [dbo].[LkpUF0] ([UFID])
GO
