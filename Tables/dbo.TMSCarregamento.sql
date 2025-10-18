CREATE TABLE [dbo].[TMSCarregamento]
(
[UnidadeID] [tinyint] NOT NULL,
[CarregamentoID] [int] NOT NULL,
[DtCarregamento] [datetime] NOT NULL,
[DtSaida] [datetime] NOT NULL,
[PessoaID] [int] NOT NULL
)
GO
ALTER TABLE [dbo].[TMSCarregamento] ADD CONSTRAINT [PK_TMSCarregamento] PRIMARY KEY CLUSTERED ([UnidadeID], [CarregamentoID])
GO
ALTER TABLE [dbo].[TMSCarregamento] ADD CONSTRAINT [FK_TMSCarregamento_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID])
GO
