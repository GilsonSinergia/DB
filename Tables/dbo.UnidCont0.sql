CREATE TABLE [dbo].[UnidCont0]
(
[UnidadeID] [tinyint] NOT NULL,
[ContaID] [int] NOT NULL,
[DRE] [bit] NOT NULL
)
GO
ALTER TABLE [dbo].[UnidCont0] ADD CONSTRAINT [PK_UnidCont0] PRIMARY KEY CLUSTERED ([UnidadeID], [ContaID])
GO
ALTER TABLE [dbo].[UnidCont0] ADD CONSTRAINT [FK_UnidCont0_CadCont0] FOREIGN KEY ([ContaID]) REFERENCES [dbo].[CadCont0] ([ContaID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[UnidCont0] ADD CONSTRAINT [FK_UnidCont0_CadUnid0] FOREIGN KEY ([UnidadeID]) REFERENCES [dbo].[CadUnid0] ([UnidadeID])
GO
EXEC sp_bindefault N'[dbo].[DF_UM]', N'[dbo].[UnidCont0].[DRE]'
GO
