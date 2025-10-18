SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE       Procedure  [dbo].[SP_R_Parcela]   
   @Financeiro  int,
   @UnidadeID   Int = Null, 
   @PessoaID    Int = Null,
   @PortadorID  Int = Null,

   @DtIni  DateTime = Null,
   @DtFin  DateTime = Null,
   @IniVen DateTime = Null,
   @FinVen DateTime = Null,
   @IniLan DateTime = Null,
   @FinLan DateTime = Null,

   @Tipos      Int = Null,
   @Documentos Int = Null,
   @Conciliado Bit = 0,
   @StatusID   Int = Null 
AS
Declare @Data datetime 
set @Data=getdate()

  
SELECT 
  U.UnidadeID,
  U.Unidade,
  MovNota0.Chave,
  MovFina0.ChaveTitulo,
  CadPess0.Nome Pessoa,
  CadPess0.tel,
  CadPess0.Fax,
  CadPess0.Celular,
  MovFina0.Parcela,
  MovFina0.Fatura,
  CadDocu0.Documento,
  MovFina0.PortadorID,
  CadPort0.Portador,
  MovFina0.DtEmissao,
  MovFina0.DtVencimento,
  Financeiro.Historico,
  MovFina0.Valor,
  Parcela.Aberto,
  Parcela.Quitado,
  Parcela.StatusID,
  Parcela.Status
FROM MovFina0
  JOIN dbo.VWS_Unidades U ON U.UnidadeID = MovFina0.UnidadeID
  JOIN MovNota0 ON MovFina0.Chave = MovNota0.Chave    
  JOIN Financeiro ON Financeiro.Chave = MovFina0.Chave    
  JOIN LkpNota0 ON MovNota0.TipoID = LkpNota0.TipoID
  JOIN CadPort0 ON MovFina0.PortadorID = CadPort0.PortadorID
  JOIN CadDocu0 ON MovFina0.DocumentoID = CadDocu0.DocumentoID
  JOIN dbo.VWS_Pessoas CadPess0 ON MovNota0.PessoaID    = CadPess0.PessoaID
  JOIN FN_Staus_Parcela(@Financeiro, @PessoaID, @Conciliado, @Data)  AS Parcela
    ON MovFina0.ChaveTitulo = Parcela.ChaveTitulo   
Where (MovFina0.StatusID = 0)
  AND (@Financeiro is null OR LkpNota0.Financeiro  = @Financeiro)
  AND (@Tipos         IS Null OR Power(2,MovFina0.TipoID) & @Tipos > 0)
  AND (@Documentos    IS Null OR Power(2,MovFina0.DocumentoID) & @Documentos > 0)
  AND (@UnidadeID     Is Null Or Power(2,MovNota0.UnidadeID ) & @UnidadeID > 0)
  AND (@StatusID      IS NULL OR Power(2,Parcela.StatusID) & @StatusID > 0 )
  AND (@PessoaID      Is Null Or MovNota0.PessoaID   = @PessoaID)
  AND (@PortadorID    Is Null Or MovFina0.PortadorID = @PortadorID)
  AND (@DtIni Is Null OR MovFina0.DtEmissao    >= @DtIni)
  AND (@DtFin Is Null OR MovFina0.DtEmissao    <= @DtFin)
  AND (@IniVen Is Null OR MovFina0.DtVencimento >= @IniVen)
  AND (@FinVen Is Null OR MovFina0.DtVencimento <= @FinVen)
  AND (@IniLan Is Null OR MovFina0.DtLancamento >= @IniLan)
  AND (@FinLan Is Null OR MovFina0.DtLancamento <= @FinLan)
  AND ( MovNota0.StatusID = 2 )
  AND ( MovFina0.StatusID = 0)
GO
