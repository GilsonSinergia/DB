CREATE TABLE [dbo].[CadMoed0]
(
[MoedaID] [tinyint] NOT NULL,
[Moeda] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
[TipoID] [tinyint] NOT NULL,
[PrazoConcilia] [smallint] NOT NULL,
[TaxaConcilia] [float] NOT NULL,
[TaxaAntecipacao] [float] NOT NULL,
[TipoMoeda] AS ([TipoID])
)
GO
ALTER TABLE [dbo].[CadMoed0] ADD CONSTRAINT [PK_CadMoed0] PRIMARY KEY CLUSTERED ([MoedaID])
GO
ALTER TABLE [dbo].[CadMoed0] ADD CONSTRAINT [FK_CadMoed0_lkpMoed0] FOREIGN KEY ([TipoID]) REFERENCES [dbo].[lkpMoed0] ([TipoID]) ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadMoed0].[PrazoConcilia]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadMoed0].[TaxaConcilia]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[CadMoed0].[TaxaAntecipacao]'
GO
