SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE                       Procedure [dbo].[SP_R_GetKardex]
  @ProdutoID Int, 
  @UnidadeID Int = Null,
  @TipoID    Int = 0
AS
Create Table #Kardex
  (
   ID            Int Not Null IDENTITY,
   UnidadeID     Int not Null,
   TipoID        Int not Null,
   Nota          Int not Null,
   NF            Int Null,
   Data          DateTime Null,
   Lote          VarChar(20)Null,
   Operacao      VarChar(20) Not Null,
   CustoMedio    Decimal(18,2)not Null default 0,
   --Entradas
   EQuantidade   Decimal(18,2)not Null default 0,
   ETotal        AS EQuantidade * CustoMedio,
   --Saidas
   SQuantidade   Decimal(18,2)not Null default 0,
   STotal        AS SQuantidade * CustoMedio,
   --Saldos
   SDQuantidade  Decimal(18,2)not Null default 0,
   SDTotal       Decimal(18,2)not Null default 0,
  )
if @TipoID =1
 Insert Into #Kardex (UnidadeID, TipoID, Nota, 
                      NF, Data, COM_ITE_MOV_LOTE.Lote, Operacao,CustoMedio, 
                      EQuantidade, SQuantidade )
             Select   
               MovNota0.UnidadeID, 
               MovNota0.TipoID, 
               MovNota0.Nota,
               IsNull(MovFisc0.NF,MovNota0.Nota),
               MovNota0.DtMovimento,
               COM_ITE_MOV_LOTE.Lote, 
               LkpNota0.Tipo, 
               COM_ITE_MOV.CustoMedio,
               Case  --Quantidade
                 when (LkpNota0.Estoque * COM_ITE_MOV_LOTE.Quantidade) > 0  
                    or MovPrdu0.ProdutoID Is Not Null then COM_ITE_MOV_LOTE.Quantidade * COM_ITE_MOV.Fator 
                    else 0 
                 end,
                 Case  --Quantidade
                    when COM_ITE_MOV_LOTE.Quantidade * LkpNota0.Estoque < 0 
                    AND  MovPrdu0.ProdutoID Is Null
                    then Abs(COM_ITE_MOV_LOTE.Quantidade) * COM_ITE_MOV.Fator 
                    else 0 
                  end 
              from MovNota0
                  JOIN COM_ITE_MOV
                    ON COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
                   AND COM_ITE_MOV.TipoID    = MovNota0.TipoID
                   AND COM_ITE_MOV.Nota      = MovNota0.Nota
                 INNER JOIN LKPNota0
                    ON MovNota0.TipoID    = LKPNota0.TipoID
                 Left JOIN MovFisc0
                    ON MovFisc0.UnidadeID = MovNota0.UnidadeID
                   AND MovFisc0.TipoID    = MovNota0.TipoID
                   AND MovFisc0.Nota      = MovNota0.Nota
                 INNER JOIN COM_ITE_MOV_LOTE
                    ON COM_ITE_MOV.UnidadeID = COM_ITE_MOV_LOTE.UnidadeID
                   AND COM_ITE_MOV.TipoID    = COM_ITE_MOV_LOTE.TipoID
                   AND COM_ITE_MOV.Nota      = COM_ITE_MOV_LOTE.Nota                
                   AND COM_ITE_MOV.Seq = COM_ITE_MOV_LOTE.Seq
                  LEFT join MovPrdu0
   	            ON MovPrdu0.UnidadeID = MovNota0.UnidadeID 
	           AND MovPrdu0.TipoID    = MovNota0.TipoID
	           AND MovPrdu0.Nota      = MovNota0.Nota   
	           AND MovPrdu0.ProdutoID = COM_ITE_MOV.ItemID
                 
               where LkpNota0.Estoque <> 0
                AND(@UnidadeID IS NULL OR MovNota0.UnidadeID = @UnidadeID)
                AND COM_ITE_MOV.ItemID = @ProdutoID
                AND MovNota0.StatusID = 2
             Order BY MovNota0.DtMovimento, LkpNota0.estoque desc,  MovPrdu0.ProdutoID DESC
else 
 Insert Into #Kardex ( UnidadeID, TipoID, Nota, NF, Data, Lote, Operacao,CustoMedio, 
                       EQuantidade, SQuantidade )
             Select   MovNota0.UnidadeID, 
                      MovNota0.TipoID, 
                      MovNota0.Nota,
                      IsNull(MovFisc0.NF,MovNota0.Nota), 
                      MovNota0.DtMovimento,
                      Null Lote, 
                      LkpNota0.Tipo, 
                      COM_ITE_MOV.CustoMedio,
                      Case  -- Quantidade
                        when (LkpNota0.Estoque * COM_ITE_MOV.Quantidade) > 0  
                          OR MovPrdu0.ProdutoID Is Not Null then COM_ITE_MOV.Quantidade * COM_ITE_MOV.Fator 
                        else 0 
                      end,
                      Case  --Quantidade
                        when COM_ITE_MOV.Quantidade * LkpNota0.Estoque < 0 
                        AND MovPrdu0.ProdutoID Is Null then Abs(COM_ITE_MOV.Quantidade) * COM_ITE_MOV.Fator 
                        else 0 
                      end 
              from MovNota0
                 JOIN COM_ITE_MOV
                    ON COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
                   AND COM_ITE_MOV.TipoID    = MovNota0.TipoID
                   AND COM_ITE_MOV.Nota      = MovNota0.Nota
                  INNER JOIN LkpNota0
                     ON MovNota0.TipoID    = LkpNota0.TipoID
                  LEFT JOIN MovFisc0
                    ON MovFisc0.UnidadeID = MovNota0.UnidadeID
                   AND MovFisc0.TipoID    = MovNota0.TipoID
                   AND MovFisc0.Nota      = MovNota0.Nota               
	         LEFT join MovPrdu0
   	            ON MovPrdu0.UnidadeID = MovNota0.UnidadeID 
	           AND MovPrdu0.TipoID    = MovNota0.TipoID
	           AND MovPrdu0.Nota      = MovNota0.Nota   
	           AND MovPrdu0.ProdutoID = COM_ITE_MOV.ItemID
               where LkpNota0.Estoque <> 0
                AND(@UnidadeID IS NULL OR MovNota0.UnidadeID = @UnidadeID)
                AND COM_ITE_MOV.ItemID = @ProdutoID
                AND MovNota0.StatusID = 2
               Order BY MovNota0.DtMovimento, LkpNota0.estoque desc, MovPrdu0.ProdutoID DESC




declare 
  @ID Int, 
  @SDQuantAnt Decimal(18,2),
  @SDQuantidade Decimal(18,2),
  @SDTotalAnt Decimal(18,2),
  @SDTotal Decimal(18,2)

set  @SDQuantAnt  = 0
Set  @SDTotalAnt  = 0

Declare C  Cursor Local for
Select ID, EQuantidade - SQuantidade, -STotal + ETotal from #Kardex
Open C

FETCH FROM C INTO @ID, @SDQuantidade, @SDTotal

WHILE @@FETCH_STATUS = 0
BEGIN  
   UPDATE #Kardex SET 
     SDQuantidade = EQuantidade - SQuantidade + @SDQuantAnt,
     SDTotal      = - STotal      + ETotal      + @SDTotalAnt
   FROM #Kardex
   WHERE CURRENT OF C 
   Set @SDQuantAnt   = @SDQuantidade + @SDQuantAnt
   Set @SDTotalAnt   = @SDTotal      + @SDTotalAnt
   FETCH NEXT FROM C INTO @ID, @SDQuantidade,@SDTotal
END

Select * from #Kardex
drop table #Kardex





GO
