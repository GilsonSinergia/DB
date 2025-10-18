CREATE TABLE [dbo].[TMS_Carregamento]
(
[UnidadeID] [int] NOT NULL,
[CargaID] [int] NOT NULL,
[DtCarga] [datetime] NOT NULL,
[StatusID] [tinyint] NOT NULL,
[PessoaID] [int] NOT NULL,
[VeiculoID] [tinyint] NOT NULL
)
GO
ALTER TABLE [dbo].[TMS_Carregamento] ADD CONSTRAINT [PK_TMS_Carregamento] PRIMARY KEY CLUSTERED ([UnidadeID], [CargaID])
GO
ALTER TABLE [dbo].[TMS_Carregamento] ADD CONSTRAINT [FK_TMS_Carregamento_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[TMS_Carregamento] ADD CONSTRAINT [FK_TMS_Carregamento_TMS_Veiculo] FOREIGN KEY ([VeiculoID]) REFERENCES [dbo].[TMS_Veiculo] ([VeiculoID])
GO
