SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--GO
CREATE  PROCEDURE [dbo].[SP_R_Comissao]

  @UnidadeID    INT =10,
  @DtInicio     DATETIME    = '20210901',
  @DtFinal      DATETIME    = '20210930',
  @Vendedor     INT         = NULL,
  @Tipo         INT         = 0
AS

DECLARE @Unidades TABLE (UnidadeID INT, Unidade VARCHAR(20))

INSERT INTO @Unidades
SELECT UnidadeID, Unidade
FROM CadUnid0
WHERE CadUnid0.Ativa=1
  AND @UnidadeID IS NULL OR POWER(2, UnidadeID) & @UnidadeID > 0

SELECT 
  MONTH(MovNota0.DtMovimento) Mes,
  YEAR(MovNota0.DtMovimento) Ano,
  MovNota0.DtMovimento, 
  MovNota0.Chave,
  dbo.VWS_Movimento_NF.NF,
  ISNULL(CadPess0.PessoaID, 0) Codigo, 
  ISNULL(CadPess0.Reduzido, '[Não informado]') Vendedor, 
  LkpNota0.Tipo, 
  MovNota0.Nota, 
  --Financeiro.Pagamento, 
  Cliente.Nome Cliente, 
  MovNota0.DtMovimento DtComissao,
  --Valores  
  SUM((COM_ITE_MOV.VL_Liquido + COM_ITE_MOV.Vl_IPI + COM_ITE_MOV.VL_Frete + COM_ITE_MOV.VL_Seguro + COM_ITE_MOV.VL_Outro)  * lkpNota0.Financeiro) VL_Total, 
  SUM(COM_ITE_MOV.VL_Liquido * lkpNota0.Financeiro)BC_Comissao,
  SUM(COM_ITE_MOV.VL_Liquido * COM_ITE_MOV.Comissao / 100 * LkpNota0.Financeiro) / SUM(COM_ITE_MOV.VL_Liquido * LkpNota0.Financeiro) * 100 Comissao,
  SUM(COM_ITE_MOV.VL_Liquido * COM_ITE_MOV.Comissao / 100) VL_Comissao
FROM COM_ITE_MOV  
  JOIN @Unidades U ON U.UnidadeID=COM_ITE_MOV.UnidadeID
  JOIN MovNota0 ON COM_ITE_MOV.Chave = MovNota0.Chave
  JOIN MovVend0 ON MovVend0.Chave = MovNota0.Chave
  JOIN Financeiro  ON Financeiro.Chave = MovNota0.Chave
  JOIN CadPess0 Cliente  ON Cliente.PessoaID = MovNota0.PessoaID
  JOIN LkpNota0  ON LkpNota0.TipoID = MovNota0.TipoID
  LEFT JOIN CadPess0 ON CadPess0.PessoaID = MovVend0.PessoaID
  LEFT JOIN dbo.VWS_Movimento_NF ON VWS_Movimento_NF.Chave = COM_ITE_MOV.Chave
WHERE COM_ITE_MOV.VL_Liquido > 0
  AND MovNota0.TipoID IN(7,8,9,10,13)
  AND MovNota0.StatusID IN (2)
  AND (@Vendedor IS NULL OR MovVend0.PessoaID  = @Vendedor)
  AND MovNota0.DtMovimento >= @DtInicio
  AND MovNota0.DtMovimento <= @DtFinal
  AND @Tipo = 0
GROUP BY   
  MovNota0.Chave,
  CadPess0.PessoaID, 
  CadPess0.Reduzido, 
  MovNota0.DtMovimento,  
  Financeiro.Pagamento,
  LkpNota0.Financeiro,
  lkpnota0.Tipo, 
  MovNota0.Nota, 
  Cliente.Nome,
  dbo.VWS_Movimento_NF.NF
UNION
SELECT 
  MONTH(MovNota0.DtMovimento) Mes,
  YEAR(MovNota0.DtMovimento) Ano,  
  MovNota0.DtMovimento, 
  MovNota0.Chave,
  dbo.VWS_Movimento_NF.NF,
  ISNULL(CadPess0.PessoaID, 0) Codigo, 
  ISNULL(CadPess0.Reduzido, '[Não informado]') Vendedor, 
  LkpNota0.Tipo, 
  MovNota0.Nota, 
  --Financeiro.Pagamento, 
  Cliente.Nome Cliente, 
  MovNota0.DtMovimento DtComissao,
  --Valores  
  SUM(COM_ITE_MOV.VL_Liquido + COM_ITE_MOV.VL_Frete + COM_ITE_MOV.VL_Seguro + COM_ITE_MOV.VL_Outro + COM_ITE_MOV.Vl_IPI + COM_ITE_MOV.Vl_ICMSSUB )* LkpNota0.Financeiro TotalPedido, 
  Parcelas.Quitado * LkpNota0.Financeiro BC_Comisso, 
  (SUM(COM_ITE_MOV.VL_Liquido * COM_ITE_MOV.Comissao / 100 ) / SUM(COM_ITE_MOV.VL_Liquido) * 100) * LkpNota0.Financeiro  PerComissao,
  SUM(COM_ITE_MOV.VL_Liquido * COM_ITE_MOV.Comissao / 100 ) / SUM(COM_ITE_MOV.VL_Liquido) * 100 * Parcelas.Quitado / 100 * LkpNota0.Financeiro VL_Comisso
FROM COM_ITE_MOV
  JOIN @Unidades U ON U.UnidadeID=COM_ITE_MOV.UnidadeID
  JOIN MovNota0 ON COM_ITE_MOV.Chave = MovNota0.Chave      
  JOIN  MovVend0 ON MovVend0.Chave = MovNota0.Chave
  JOIN  Financeiro ON Financeiro.Chave = MovNota0.Chave
  JOIN (SELECT 
           MovFina0.Chave, 
           SUM(Movfina1.ValorLiquido)Quitado
        FROM MovFina0          
          JOIN MovFina1
            ON MovFina1.ChaveTitulo=MovFina0.ChaveTitulo           
          JOIN MovFina2
             ON MovFina1.OperacaoID=MovFina2.OperacaoID
           AND MovFina1.MovimentoID=MovFina2.MovimentoID    
        WHERE MovFina2.DtConciliacao >=@DtInicio
          AND MovFina2.DtConciliacao <=@DtFinal
          AND MovFina2.StatusID<6            
        GROUP BY MovFina0.Chave)Parcelas
    ON Parcelas.Chave = MovNota0.Chave
  JOIN CadPess0 Cliente 
     ON Cliente.PessoaID = MovNota0.PessoaID
  JOIN LkpNota0 ON LkpNota0.TipoID = MovNota0.TipoID
  JOIN COM_ITE_CAD ON COM_ITE_MOV.ItemID = COM_ITE_CAD.ItemID
  LEFT JOIN CadPess0 ON CadPess0.PessoaID = MovVend0.PessoaID
  LEFT JOIN PesFunc0 ON PesFunc0.PessoaID = CadPess0.PessoaID
  LEFT JOIN dbo.VWS_Movimento_NF ON VWS_Movimento_NF.Chave = COM_ITE_MOV.Chave
WHERE  MovNota0.TipoID IN(7,8,9,10,13)
  AND COM_ITE_MOV.VL_Liquido > 0
  AND  MovNota0.StatusID IN (2)
  AND (@Vendedor IS NULL OR MovVend0.PessoaID  = @Vendedor)
  AND @Tipo = 1
GROUP BY   
  MovNota0.Chave,
  CadPess0.PessoaID, 
  CadPess0.Reduzido, 
  MovNota0.DtMovimento,  
  Financeiro.Pagamento,
  LkpNota0.Financeiro,
  lkpnota0.Tipo, 
  MovNota0.Nota, 
  Cliente.Nome, 
  Parcelas.Quitado,
  dbo.VWS_Movimento_NF.NF
ORDER BY Vendedor,Cliente.Nome, DtMovimento, Codigo,Tipo, Nota

GO
