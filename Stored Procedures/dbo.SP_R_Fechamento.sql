SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SP_R_Fechamento]
	@UnidadeID INT =10,
	@Data DATETIME = '20250930',
	@Resumo BIT = 0,
	@ValorInformado FLOAT = 0,  
	@Chave CHAR(14) = NULL
AS	

DECLARE @DtIni DATE = DATEADD(DAY, -DAY(@Data)+1, @Data);
DECLARE @DtFin DATE = @Data;
DECLARE @B10 BIGINT  = 10;
DECLARE @Len TINYINT = 11;
 
WITH
--Grupamento agrupamento estrutural contendo a raiz do plano de contas 
Rais AS (
  SELECT * FROM (VALUES
	(1 , 'BP', NULL),
		(11, 'Ativo', 1),
			(111, 'Disponibilidade', 11),
		(12, 'Passivo', 1),	
		(13, 'Patrimônio Líquido', 1),
	(2, 'DRE', NULL),

	(9, 'Erros', NULL)
  ) V (ID, Pasta, Parent) 
)


,Contas AS (
SELECT 
   111 GrupoID, 'Disponibilidade'Grupo,
   Rais.ID, ISNULL(Rais.Pasta, R.Pasta)Pasta, Baixas.Valor * LB1.Multiplicador valor, Rais.Parent
FROM dbo.MovFina2 Baixas 
JOIN dbo.LkpBaix1 LB1 ON LB1.OperacaoID=Baixas.OperacaoID
JOIN dbo.CadCont0 Contas ON Contas.ContaID=Baixas.ContaID
JOIN dbo.CadPort0 Portadores ON Portadores.PortadorID = Contas.PortadorID
CROSS APPLY(VALUES 
  (1,NULL, NULL),
  (11,1, NULL),
  (111,11, NULL),
  (111000+Portadores.PortadorID, 111, Portadores.Portador),
  (11100000000+Portadores.PortadorID * 100000+Contas.ContaID, 111000+Portadores.PortadorID, Contas.Conta)
) Rais (ID, Parent, Pasta)
LEFT JOIN Rais R ON R.ID=Rais.ID
WHERE 0=0
  AND Baixas.StatusID=3
  --AND Contas.PortadorID=1
)

, Titulos AS (
SELECT 
  2 GrupoID, 'Titulos' Grupo, Unir.*
FROM dbo.fns_Movimento_Titulos(@Data) T
CROSS APPLY (VALUES
	(
	 IIF(T.FinalidadeID=2, 13, IIF(T.NaturezaID=1,11,12)),
	 
	 IIF(T.FinalidadeID=2, T.Quitado * T.Multiplicador, T.Aberto)
	)
)BP (ID, Valor)
JOIN Rais ON BP.ID=Rais.ID
CROSS APPLY(VALUES
  (Rais.ID, Rais.Pasta, BP.Valor, Rais.Parent),
  (Rais.ID * 10 + T.StatusID, IIF(T.FinalidadeID=2, NULL, T.Status), T.Valor, Rais.ID),
  (Rais.ID * 1000 + T.StatusID * 100 + T.DocumentoID , IIF(T.FinalidadeID=2, NULL, T.Documento), T.Valor, Rais.ID* 10 + T.StatusID)
)Unir (ID, Pasta, Valor, Parent)
WHERE BP.Valor <> 0
AND Unir.Pasta IS NOT NULL
  
)

, Unir AS (
SELECT C.GrupoID, C.Grupo, C.ID, C.Pasta, C.Valor, C.Parent FROM Titulos C
)



, Soma AS (
SELECT 
  S.ID, S.Pasta, S.Parent, SUM(Valor)Valor
FROM Unir S
GROUP BY S.ID, S.Pasta,S.Parent
)

, Mascara AS (
SELECT 
  ( Mascara.ID * POWER(@B10, @Len - LEN(Mascara.ID))) ID, 
  Mascara.Pasta, 
  Mascara.Valor,
  (Mascara.Parent * POWER(@B10, @Len - LEN(Mascara.Parent))) Parent 
FROM Soma Mascara)


SELECT * FROM Mascara T ORDER BY 1

GO
