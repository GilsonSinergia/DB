CREATE TABLE [dbo].[CTE_Conecimento_Participantes]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[NaturzaID] [tinyint] NOT NULL,
[PessoaID] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[CTE_Conecimento_Participantes] ADD CONSTRAINT [PK_CTE_Conecimento_Participantes] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota], [NaturzaID])
GO
ALTER TABLE [dbo].[CTE_Conecimento_Participantes] ADD CONSTRAINT [FK_CTE_Conecimento_Participantes_CTE_Conhecimento] FOREIGN KEY ([UnidadeID], [TipoID], [Nota]) REFERENCES [dbo].[CTE_Conhecimento] ([UnidadeID], [TipoID], [Nota]) ON DELETE CASCADE ON UPDATE CASCADE
GO
