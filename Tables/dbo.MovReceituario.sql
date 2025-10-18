CREATE TABLE [dbo].[MovReceituario]
(
[UnidadeID] [int] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[PessoaID] [int] NULL,
[Paciente] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[OD_Esferico] [float] NULL,
[OD_Cilindrico] [float] NULL,
[OD_Eixo] [tinyint] NULL,
[OD_Adicao] [float] NULL,
[OD_DNP] [float] NULL,
[OE_Esferico] [float] NULL,
[OE_Cilindrico] [float] NULL,
[OE_Exio] [tinyint] NULL,
[OE_Adicao] [float] NULL,
[OE_DNP] [float] NULL,
[COR] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[PA] [float] NULL,
[AM] [float] NULL,
[OBS] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[DtExame] [datetime] NULL,
[DtEntrega] [datetime] NULL,
[DtNacimento] [datetime] NULL,
[TipoLente] [smallint] NULL,
[AV] [float] NULL,
[AH] [float] NULL,
[CO] [float] NULL,
[PT] [float] NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2),(0)),' ','0')+replace(str([TipoID],(2),(0)),' ','0'))+replace(str([Nota],(10),(0)),' ','0'),(0))) PERSISTED
)
GO
ALTER TABLE [dbo].[MovReceituario] ADD CONSTRAINT [PK_MovReceituario] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[MovReceituario] ADD CONSTRAINT [FK_MovReceituario_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
