SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [dbo].[VWS_Movimento_Tipo]
AS
SELECT 
  TipoID,
  Tipo,
  Sigla,
  CASE 
    WHEN TipoID=1 THEN 1
	WHEN TipoID=2 THEN 2
	WHEN TipoID IN(7,8,9,10) THEN 3
	WHEN TipoID=13 THEN 4
	WHEN TipoID=4 THEN 5
	WHEN TipoID=11 THEN 6
	WHEN TipoID IN (5,6, 17, 19, 21) THEN 7
	WHEN TipoID IN (12, 15, 16, 18, 22) THEN 8
  END OperacaoID,
  CASE 
    WHEN TipoID=1 THEN 'Compra'
	WHEN TipoID=2 THEN 'Devolução de compra'
	WHEN TipoID IN(7,8,9,10) THEN 'Venda'
	WHEN TipoID=13 THEN 'Devolução de venda'
	WHEN TipoID=4 THEN 'Entrada por transferência'
	WHEN TipoID=11 THEN 'Saída por transferência'
	WHEN TipoID IN (5,6, 17, 19, 21) THEN 'Outras entradas'
	WHEN TipoID IN (12, 15, 16, 18, 22) THEN 'Outras saídas'
  END Operacao,
  Estoque,
  Financeiro
FROM dbo.LkpNota0
WHERE Estoque<> 0
GO
