CREATE TABLE [dbo].[MovNota0]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Nota] [int] NOT NULL,
[DtLancamento] [datetime] NOT NULL,
[DtMovimento] [date] NOT NULL,
[PessoaID] [int] NOT NULL,
[FinalidadeID] [tinyint] NOT NULL,
[StatusID] [tinyint] NOT NULL,
[Impresso] [bit] NOT NULL,
[ParentTipoID] [tinyint] NULL,
[ParentNota] [int] NULL,
[OBS] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
[Chave] AS (CONVERT([char](14),(replace(str([UnidadeID],(2)),' ','0')+replace(str([TipoID],(2)),' ','0'))+replace(str([Nota],(10)),' ','0'),(0))) PERSISTED
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[TR_MovNota0]
   ON [dbo].[MovNota0] 
   for INSERT,DELETE,UPDATE
AS 
BEGIN
     if GetDate() >= '20500101'
	 RAISERROR ('SQL General Error', -- Message text.  
               16, -- Severity.  
               1 -- State.  
               );  

END
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [PK_MovNota0] PRIMARY KEY CLUSTERED ([UnidadeID], [TipoID], [Nota])
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [IX_MovNota0] UNIQUE NONCLUSTERED ([Chave])
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [CK_MovNota0] UNIQUE NONCLUSTERED ([UnidadeID], [TipoID], [Nota], [PessoaID])
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [FK_MovNota0_CadPess0] FOREIGN KEY ([PessoaID]) REFERENCES [dbo].[CadPess0] ([PessoaID])
GO
ALTER TABLE [dbo].[MovNota0] WITH NOCHECK ADD CONSTRAINT [FK_MovNota0_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID])
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [FK_MovNota0_CTB_Finalidade] FOREIGN KEY ([FinalidadeID]) REFERENCES [dbo].[CTB_Finalidade] ([FinalidadeID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [FK_MovNota0_LkpNota0] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[LkpNota0] ([TipoID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovNota0] ADD CONSTRAINT [FK_MovNota0_LkpNota1] FOREIGN KEY ([StatusID]) REFERENCES [dbo].[LkpNota1] ([StatusID]) ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[MovNota0] WITH NOCHECK ADD CONSTRAINT [FK_MovNota0_MovNota0] FOREIGN KEY ([UnidadeID], [ParentTipoID], [ParentNota]) REFERENCES [dbo].[MovNota0] ([UnidadeID], [TipoID], [Nota])
GO
EXEC sp_bindefault N'[dbo].[DataHora]', N'[dbo].[MovNota0].[DtLancamento]'
GO
EXEC sp_bindefault N'[dbo].[DF_DtHoje]', N'[dbo].[MovNota0].[DtMovimento]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovNota0].[FinalidadeID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovNota0].[StatusID]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[MovNota0].[Impresso]'
GO
