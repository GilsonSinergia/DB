CREATE TABLE [dbo].[PesFisi0]
(
[PessoaID] [int] NOT NULL,
[OrgExp] [char] (10) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[DtExp] [datetime] NULL,
[DtNascimento] [datetime] NULL,
[Idade] AS (datediff(year,[DtNascimento],getdate())),
[Pai] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Mae] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Sexo] [tinyint] NULL,
[CidadeID] [int] NULL,
[Nacionalidade] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[EstCivil] [int] NULL,
[Conjurge] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Intrucao] [tinyint] NULL,
[Proficao] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Empresa] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[dtAdmissao] [datetime] NULL,
[Cargo] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Salario] [float] NULL,
[Dependentes] [tinyint] NULL,
[OtRendas] [float] NULL,
[DiaNacimento] AS (datepart(day,[DtNascimento])),
[MesNacimento] AS (datepart(month,[DtNascimento]))
)
GO
ALTER TABLE [dbo].[PesFisi0] ADD CONSTRAINT [PK_PesFisi0] PRIMARY KEY CLUSTERED ([PessoaID])
GO
ALTER TABLE [dbo].[PesFisi0] ADD CONSTRAINT [FK_PesFisi0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
