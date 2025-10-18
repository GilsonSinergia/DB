SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[SP_R_Cobranca]
  @ClienteID  Int = Null,
  @VendedorID Int = null,
  @ResponsavelID Int = null,
  @CidadeID   Int = Null,
  @Conciliado Bit = 1,
  @UnidadeID  Int = Null,
  @Documentos Int   = Null,
  @IniEmi     DateTime = Null,
  @FinEmi     DateTime = Null,
  @DtIni      DateTime = Null,
  @dtFin      DateTime = Null
As
Select 
  Clientes.PessoaID,
  Clientes.Reduzido + ' (' + Clientes.Nome + ')' Cliente,
  Clientes.Tel,
  Clientes.Celular,
  Clientes.EMail,
  IsNull(Vendedor.Reduzido, VWS_Unidades.Reduzido)Vendedor,
  IsNull(CadArea0.Area, VWS_Unidades.Reduzido)Area,
  IsNull(Responsavel.Reduzido, VWS_Unidades.Reduzido) Responsavel,
  MovNota0.Chave,
  MovFina0.ChaveTitulo,
  Financeiro.Historico,
  MovFina0.Fatura,
  CadDocu0.Documento,
  MovFina0.DtVencimento,
  DATEDIFF(dd,DtEmissao, MovFina0.DtVencimento) Dias,
  MovFina0.valor,
  SP.Aberto,
  SP.Juros,
  SP.Corrigido,
  SP.Quitado,
  SP.Status, 
  Clientes.Cidade,
  Clientes.Endereco,
  Clientes.Bairro,
  Clientes.Numero,
  Clientes.CEP,
  Clientes.UF   
from MovFina0
  Join VWS_Unidades ON MovFina0.UnidadeID = VWS_Unidades.UnidadeID    
  JOIN CadPort0 On Cadport0.PortadorID = Movfina0.PortadorID  
  JOIN CadDocu0 On CadDocu0.DocumentoID = MovFina0.DocumentoID     
  Join dbo.FN_Staus_Parcela(1, @ClienteID, @Conciliado, Getdate())SP ON SP.ChaveTitulo = MovFina0.ChaveTitulo  
  Join MovNota0 ON MovNota0.Chave = MovFina0.Chave
  Join Financeiro ON Financeiro.Chave = MovFina0.Chave
  JOIN VWS_Pessoas Clientes on Clientes.PessoaID=MovNota0.PessoaID
  LEFT JOIN PesClie0 ON PesClie0.PessoaID=Clientes.PessoaID
  LEFT Join CadArea0 On CadArea0.AreaID = PesClie0.AreaID
  LEFT Join CadPess0 Responsavel ON Responsavel.PessoaID=CadArea0.PessoaID   
  LEFT Join MovVend0 ON MovVend0.Chave = Financeiro.Chave
  LEFT JOIN CadPess0 Vendedor on Vendedor.PessoaID=MovVend0.PessoaID
Where SP.Aberto > 0
  AND (@ClienteID   Is Null OR Clientes.PessoaID = @ClienteID)
  AND (@VendedorID  Is Null OR IsNull(MovVend0.PessoaID, CadArea0.PessoaID) = @VendedorID)
  AND (@ResponsavelID  Is Null OR CadArea0.PessoaID= @VendedorID)
  AND (@dtini       Is null OR MovFina0.DtVencimento >= @Dtini)
  AND (@dtfin       Is null OR MovFina0.DtVencimento <= @Dtfin)
  AND (@iniEmi      Is null OR MovNota0.DtMovimento >= @iniEmi)
  AND (@finEmi      Is null OR MovNota0.DtMovimento <= @FinEmi)
  AND (@UnidadeID   Is null OR Power(2, MovFina0.UnidadeID) & @UnidadeID <> 0)
  AND (@CidadeID    Is Null OR Clientes.CidadeID = @CidadeID)
  AND (@Documentos  IS Null OR Power(2,MovFina0.DocumentoID) & @Documentos > 0)
  AND (Movnota0.StatusID=2)
Order BY Responsavel, Clientes.Reduzido, MovFina0.ChaveTitulo
GO
