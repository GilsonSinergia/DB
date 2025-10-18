SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [dbo].[VWS_Movimento_Baixa]
AS
SELECT 
  -- 1. Chave para JOIN com Título
  R.UnidadeID, R.TipoID, R.Nota, R.Reneg, R.Parcela,
  R.ChaveTitulo,
  
  -- 2. Identificadores da Baixa
  B.OperacaoID, B.MovimentoID,
  
  -- 3. Tipo de Operação
  LB.Operacao, LB.Multiplicador,
  
  -- 4. Conta
  C.PortadorID, PRT.Portador,
  B.ContaID, C.Conta,
  
  -- 5. Datas
  B.DtPagamento AS DtBaixa, 
  B.DtProjecao, 
  B.DtConciliacao,
  
  -- 6. Valores
  R.ValorLiquido,
  R.ValorJuros,
  R.ValorMulta,
  R.ValorDesconto,
  R.ValorPago
  
FROM dbo.MovNota0 M  -- ← MANTÉM para filtrar StatusID
JOIN dbo.MovFina1 R 
  ON R.UnidadeID = M.UnidadeID 
 AND R.TipoID = M.TipoID 
 AND R.Nota = M.Nota  
JOIN dbo.MovFina2 B 
  ON B.OperacaoID = R.OperacaoID 
 AND B.MovimentoID = R.MovimentoID
JOIN dbo.LkpBaix1 LB ON LB.OperacaoID = B.OperacaoID
JOIN dbo.CadCont0 C ON C.ContaID = B.ContaID
JOIN dbo.CadPort0 PRT ON PRT.PortadorID = C.PortadorID
WHERE M.StatusID = 2  -- ← Nota ativa
  AND B.StatusID = 3; -- ← Baixa conciliada
GO
