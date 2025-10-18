CREATE TYPE [dbo].[Telefone] FROM varchar (15) NOT NULL
GO
GRANT REFERENCES ON TYPE:: [dbo].[Telefone] TO [public]
GO
