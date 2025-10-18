SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE    Procedure [dbo].[SP_R_PISCOFINS]
  @UnidadeID Int,
  @DtIni     DateTime,
  @DtFin     DateTime
as
SELECT
 MovNota0.Chave,   
 VWS_Itens.NCM,
 VWS_Itens.ItemID Codigo, 
 VWS_Itens.Item,
 SUM(COM_ITE_MOV.VL_Liquido * LkpNota0.Financeiro) VL_Total,
 SUM((COM_ITE_MOV.VL_Liquido - COM_ITE_MOV.BC_PIS)* LkpNota0.Financeiro) VL_Isento,
 SUM(COM_ITE_MOV.BC_PIS * LkpNota0.Financeiro) BC_PIS,
 SUM(COM_ITE_MOV.VL_PIS * LkpNota0.Financeiro) VL_PIS,
 SUM(COM_ITE_MOV.BC_COFINS * LkpNota0.Financeiro) BC_COFINS,
 SUM(COM_ITE_MOV.VL_COFINS * LkpNota0.Financeiro) VL_COFINS,
 SUM((COM_ITE_MOV.VL_COFINS+COM_ITE_MOV.VL_PIS)* LkpNota0.Financeiro) VL_PIS_COFINS
FROM VWS_Itens 
  JOIN COM_ITE_UND on COM_ITE_UND.ItemID=VWS_Itens.ItemID  
  JOIn COM_ITE_MOV
    on COM_ITE_MOV.UnidadeID=COM_ITE_UND.UnidadeID
   AND COM_ITE_MOV.ItemID=COM_ITE_UND.ItemID 
  JOIn MovNota0
    on COM_ITE_MOV.Chave=MovNota0.Chave
  JOIn LkpNota0 on LkpNota0.TipoID=MovNota0.TipoID 
WHERE MovNota0.StatusID=2
  AND MovNota0.TipoID in(7,8,9,10,13)
  AND  COM_ITE_UND.UnidadeID = @UnidadeID 
  AND MovNota0.DtMovimento BetWeen @DtIni AND @DtFin
GROUP BY MovNota0.Chave, VWS_Itens.NCM, VWS_Itens.ItemID, VWS_Itens.Item
Order by MovNota0.Chave, VWS_Itens.NCM, VWS_Itens.ItemID

GO
