CREATE TABLE [dbo].[Staging]
(
[UnidadeID] [tinyint] NOT NULL,
[TipoID] [int] NULL,
[Lote] [int] NOT NULL,
[Detalhe] [int] NOT NULL,
[Anterior] [money] NULL,
[Movimento] [money] NULL,
[Atual] [money] NULL
)
GO
