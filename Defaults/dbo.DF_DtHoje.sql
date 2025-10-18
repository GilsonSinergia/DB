SET QUOTED_IDENTIFIER OFF
GO
create default [dbo].[DF_DtHoje] as Convert(DateTime,floor(Convert(Float,GetDate())))
GO
