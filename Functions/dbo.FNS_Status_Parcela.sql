SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE     FUNCTION [dbo].[FNS_Status_Parcela] (@date DATE, @Chave CHAR(14))
RETURNS TABLE
AS
RETURN
  (
WITH CTE_Baixas AS (
SELECT 
  R.ChaveTitulo,   
  MAX(B.DtProjecao)DtProjecao,
  MAX(B.DtConciliacao)DtConciliacao,
  SUM(ValorLiquido) ValorLiquido,
  SUM(ValorEncargos) ValorEncargos,
  SUM(ValorDesconto) ValorDesconto,
  SUM(ValorPago) ValorPago
FROM dbo.MovNota0 M
  JOIN dbo.MovFina1 R ON R.Chave = M.Chave
  JOIN dbo.MovFina2 B ON B.OperacaoID = R.OperacaoID AND B.MovimentoID = R.MovimentoID
WHERE B.StatusID=3
  AND M.StatusID=2
  AND (@date IS NOT NULL OR B.DtConciliacao<=@date)
  AND (@date IS NULL OR M.Chave = @Chave)
GROUP BY R.ChaveTitulo
),
CTE_Titulo AS (
SELECT 
  MovNota0.Chave,
  MovFina0.ChaveTitulo,
  DocumentoID,
  Parcela,
  DATEDIFF(DAY, MovFina0.DtVencimento, ISNULL(CTE_Baixas.DtConciliacao, @date)) Dias,
  IIF(DtProjecao >= DtVencimento, DtProjecao, DtVencimento) DtVencimento,
  IIF(MovFina0.Valor-ISNULL(ValorLiquido, 0.0000) >0, NULL, DtConciliacao)DtQuitacao,
  MovFina0.Valor,
  CONVERT(DECIMAL(18,2), MovFina0.Valor - CONVERT(MONEY, ISNULL(ValorLiquido,0.00)))  VL_Aberto,  
  CONVERT(DECIMAL(18,2), ISNULL(ValorLiquido,0.00))VL_Quitado,
  CONVERT(DECIMAL(18,2), ISNULL(ValorEncargos,0.00))VL_Encargo,
  CONVERT(DECIMAL(18,2), ISNULL(ValorDesconto,0.00))VL_Desconto,
  CONVERT(DECIMAL(18,2), ISNULL(ValorPago,0.00))VL_Pago
FROM MovFina0
  JOIN LkpNota0 ON LkpNota0.TipoID = MovFina0.TipoID
  JOIN MovNota0 ON MovNota0.Chave = MovFina0.Chave
  LEFT JOIN CTE_Baixas ON CTE_Baixas.ChaveTitulo = MovFina0.ChaveTitulo
WHERE (MovFina0.StatusID = 0)  
  AND MovNota0.StatusID = 2
  AND (@Chave IS NULL OR MovNota0.Chave = @Chave)

)
SELECT 
  *, 
  --@date Data,
  IIF(CTE_Titulo.DtVencimento > ISNULL(CTE_Titulo.DtQuitacao, @date), 0, DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date))) Atrazo,
  CASE
    WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) > 360 THEN 1
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 181 AND 360 THEN 2
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 91 AND 180 THEN 3
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 31 AND 90 THEN 4
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 15 AND 30 THEN 5
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 1 AND 14 THEN 6
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) = 0 THEN 7
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -14 AND -1 THEN 8
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -30 AND -15 THEN 9
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -90 AND -31 THEN 10
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -180 AND -91 THEN 11
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -360 AND -181 THEN 12
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date))< 360 THEN 13
    ELSE 'Indefinido'
  END StatusID,
  CASE
    WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) > 360 THEN 'Vencido a 361 dias ou mais'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 181 AND 360 THEN 'Vencido entre 181 e 360 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 91 AND 180 THEN 'Vencido entre 91 e 180 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 31 AND 90 THEN 'Vencido entre 31 e 90 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 15 AND 30 THEN 'Vencido entre 15 e 30 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN 1 AND 14 THEN 'Vencido entre 1 e 14 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) = 0 THEN 'Vencendo'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -14 AND -1 THEN 'A Vencer entre 1 e 14 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -30 AND -15 THEN 'A Vencer entre 15 e 30 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -90 AND -31 THEN 'A Vencer entre 31 e 90 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -180 AND -91 THEN 'A Vencer entre 91 e 180 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date)) BETWEEN -360 AND -181 THEN 'A Vencer entre 181 e 360 dias'
	WHEN DATEDIFF(DAY, CTE_Titulo.DtVencimento, ISNULL(CTE_Titulo.DtQuitacao, @date))< 360 THEN 'A Vencer a 361 dias ou mais'
    ELSE 'Indefinido'
  END Status       
FROM CTE_Titulo
)
GO
