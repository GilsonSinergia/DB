CREATE TABLE [dbo].[CadUnid0]
(
[UnidadeID] [tinyint] NOT NULL,
[Unidade] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_CadFili0_Unidade] DEFAULT ('Test'),
[Ativa] [bit] NOT NULL,
[Homilogacao] [bit] NOT NULL,
[TipoID] [tinyint] NOT NULL,
[Comercial] [decimal] (8, 2) NOT NULL,
[Juros] [float] NOT NULL,
[Propietario] [tinyint] NULL,
[Logo] [varbinary] (max) NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create    TRIGGER [dbo].[InsereItemUnidade] ON [dbo].[CadUnid0]
FOR INSERT
AS

insert into COM_ITE_UND (UnidadeID, ItemID, Ativo)
select (Select  UnidadeID  from inserted), ItemID, 0 
from COM_ITE_CAD
GO
ALTER TABLE [dbo].[CadUnid0] ADD CONSTRAINT [PK_CadFili0] PRIMARY KEY CLUSTERED ([UnidadeID])
GO
ALTER TABLE [dbo].[CadUnid0] ADD CONSTRAINT [IX_Unidade] UNIQUE NONCLUSTERED ([Unidade])
GO
ALTER TABLE [dbo].[CadUnid0] ADD CONSTRAINT [FK_CadUnid0_CadUnid0] FOREIGN KEY ([Propietario]) REFERENCES [dbo].[CadUnid0] ([UnidadeID])
GO
ALTER TABLE [dbo].[CadUnid0] ADD CONSTRAINT [FK_CadUnid0_LkpUnid1] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[LkpUnid1] ([TipoID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadUnid0].[Ativa]'
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[CadUnid0].[Homilogacao]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadUnid0].[Comercial]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadUnid0].[Juros]'
GO
