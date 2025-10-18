CREATE TABLE [dbo].[DFe_Evennto]
(
[ID] [char] (44) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[tpEvento] [tinyint] NOT NULL,
[Seq] [tinyint] NOT NULL,
[XML] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL
)
GO
ALTER TABLE [dbo].[DFe_Evennto] ADD CONSTRAINT [PK_DFe_Evennto] PRIMARY KEY CLUSTERED ([ID], [tpEvento], [Seq])
GO
ALTER TABLE [dbo].[DFe_Evennto] ADD CONSTRAINT [FK_DFe_Evennto_DFe_XML] FOREIGN KEY ([ID]) REFERENCES [dbo].[DFe_XML] ([ID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
