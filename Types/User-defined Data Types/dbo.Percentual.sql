CREATE TYPE [dbo].[Percentual] FROM money NOT NULL
GO
EXEC sp_bindrule N'[dbo].[RG_Percentual]', N'[dbo].[Percentual]'
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[Percentual]'
GO
