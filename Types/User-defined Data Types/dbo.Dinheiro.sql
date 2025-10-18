CREATE TYPE [dbo].[Dinheiro] FROM decimal (18, 2) NOT NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[Dinheiro] TO [public]
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[Dinheiro]'
GO
