SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE View [dbo].[VWS_Conta]
AS
Select 
  CadCont0.ContaID,
  CadCont0.Conta + ' - ' +CadCont0.ContaDV Conta,
  LkpCont0.Tipo,
  CadPort0.PortadorID,
  CadPort0.Portador,
  CadCont0.Agencia +' - '+ CadCont0.AgenciaDV Agencia,
  CadPess0.Nome Titular,
  CadCont0.Limite,
  CadCont0.Conta + ' - ' +CadCont0.ContaDV +' / '+ CadCont0.Agencia +' - '+ CadCont0.AgenciaDV +' / '+CadPort0.Portador Conta_Extenso
from CadCont0
  JOIN CadPort0 on CadPort0.PortadorID=CadCont0.PortadorID
  JOIN CadPess0 on CadPess0.PessoaID=CadCont0.PessoaID
  JOIN LkpCont0 on LkpCont0.TipoID=CadCont0.TipoID
GO
