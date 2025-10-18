SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [dbo].[SP_R_GiroEstoque]
	@UnidadeID    INT = 1,
	@GrupoID      INT = NULL,
	@LinhaID      INT = NULL,
	@DtInicial    DATETIME = '20240201',
	@DtFinal      DATETIME = '20240229'
AS
  Declare @dtSaldo datetime
  Set @dtSaldo=@dtinicial-1


SELECT  
  VWS_Itens.ItemID,
  VWS_Itens.Item,  
  VWS_Itens.Referencia,  
  VWS_Itens.Grupo,  
  VWS_Itens.Linha,  
  VWS_Itens.aplicacao,
  Custo.Valor Custo,
  VWS_Itens.EstMinimo, 
  VWS_Itens.EstMaximo,
  COM_ITE_PRC.Valor Venda,
  (COM_ITE_PRC.Valor/Custo.Valor) Margem,
  ((COM_ITE_PRC.Valor/Custo.Valor)-1)*100 Margem,
  ISNULL(E.Contabil, 0) SaldoAnterior, 
  SUM( IIF(LkpNota0.Estoque = 1, COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator, 0)) AS Entradas,
  SUM( IIF(COM_ITE_MOV.TipoID = 1 AND COM_ITE_MOV.StatusID=2,  COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator,0)  ) AS Compras,
  MAX( IIF(COM_ITE_MOV.TipoID = 1 AND COM_ITE_MOV.StatusID=2, COM_ITE_MOV.DtMovimento,  NULL)) AS DtCompras,
  SUM( IIF(LkpNota0.Estoque =  1 AND  COM_ITE_MOV.TipoID <> 1 AND COM_ITE_MOV.StatusID=2, COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator, 0)) AS OutrasEntradas,
  SUM( IIF(LkpNota0.Estoque = -1 AND COM_ITE_MOV.StatusID=2 , COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator, 0) ) AS Saidas,
  SUM( IIF(COM_ITE_MOV.TipoID IN (7, 8, 9, 10) AND COM_ITE_MOV.StatusID=2, COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator,0 )) AS Vendas,
  SUM( IIF(COM_ITE_MOV.TipoID IN (7, 8, 9, 10) AND COM_ITE_MOV.StatusID=1, COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator,0)) AS Reservado,
  MAX( IIF(COM_ITE_MOV.TipoID IN (7, 8, 9, 10), COM_ITE_MOV.DtMovimento, NULL)) AS DtVendas,
  SUM( IIF(LkpNota0.Estoque = -1 AND NOT COM_ITE_MOV.TipoID IN (7, 8, 9, 10), COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator, 0 )) AS OutraSaidas,  
  ISNULL(EAtual.Contabil, 0)Saldo,
  ISNULL(EAtual.Contabil, 0) - SUM( CASE WHEN COM_ITE_MOV.TipoID IN (7, 8, 9, 10) AND COM_ITE_MOV.StatusID=1 THEN COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator ELSE 0 END )  SaldoDisponivel,
  0 Falta
FROM VWS_Itens
  JOIN COM_ITE_MED ON COM_ITE_MED.MedidaID = VWS_Itens.MedidaID
  JOIN COM_ITE_PRC
    ON COM_ITE_PRC.UnidadeID = VWS_Itens.UnidadeID
   AND COM_ITE_PRC.ItemID = VWS_Itens.ItemID
  JOIN COM_ITE_PRC Custo
    ON Custo.UnidadeID = VWS_Itens.UnidadeID
   AND Custo.ItemID = VWS_Itens.ItemID
 LEFT JOIN dbo.fns_Estoque(@dtSaldo, NULL)E
    ON E.UnidadeID = VWS_Itens.UnidadeID
   AND E.ItemID = VWS_Itens.ItemID
  LEFT JOIN dbo.fns_Estoque(GETDATE(), NULL)EAtual
    ON EAtual.UnidadeID = VWS_Itens.UnidadeID
   AND EAtual.ItemID = VWS_Itens.ItemID
  LEFT OUTER JOIN
         (SELECT 
           COM_ITE_MOV.UnidadeID, 
           COM_ITE_MOV.TipoID, 
           COM_ITE_MOV.Nota,
           MovNota0.DtMovimento, 
           COM_ITE_MOV.ItemID, 
           COM_ITE_MOV.Quantidade, 
           COM_ITE_MOV.Fator,
           MovNota0.StatusID
          FROM COM_ITE_MOV
	        JOIN MovNota0
	         ON MovNota0.UnidadeID = COM_ITE_MOV.UnidadeID
	        AND MovNota0.TipoID    = COM_ITE_MOV.TipoID
	        AND MovNota0.Nota      = COM_ITE_MOV.Nota
          WHERE  (MovNota0.StatusID IN (2) OR (StatusID=1 AND COM_ITE_MOV.TipoID IN(7,8,9)))
            AND MovNota0.dtmovimento >= @DtInicial
	        AND MovNota0.dtmovimento <= @DtFinal
                                        ) COM_ITE_MOV
    ON COM_ITE_MOV.UnidadeID = VWS_Itens.UnidadeID 
   AND COM_ITE_MOV.ItemID = VWS_Itens.ItemID
  LEFT JOIN LkpNota0
    ON LkpNota0.TipoID = COM_ITE_MOV.TipoID
WHERE ( @LinhaID       IS NULL OR VWS_Itens.LinhaID   =  @LinhaID )
  AND ( @UnidadeID     IS NULL OR VWS_Itens.UnidadeID = @UnidadeID )
  AND ( @GrupoID       IS NULL OR VWS_Itens.GrupoID = @GrupoID )  
  AND ( VWS_Itens.Ativo = 1)
  AND ( COM_ITE_PRC.PrecoID=3)
  AND ( Custo.PrecoID=1)
  AND Custo.Valor> 0  
  AND ISNULL(EAtual.Contabil, 0)>0
GROUP BY 
  VWS_Itens.ItemID,
  VWS_Itens.item, 
  VWS_Itens.Referencia,
  VWS_Itens.Aplicacao, 
  E.Contabil,
  VWS_Itens.Grupo,
  VWS_Itens.Linha,
  COM_ITE_PRC.Valor,
  VWS_Itens.EstMinimo, 
  VWS_Itens.EstMaximo,
  Custo.Valor,
  EAtual.Contabil, 
  VWS_Itens.UN
         
GO
