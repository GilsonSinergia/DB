SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[SPS_Gera_Tributo]
  @Chave CHAR(14), @Calcula BIT=1
AS
DECLARE @Operacao TABLE (TipoID INT, Tipo VARCHAR(20), Estoque INT, OperacaoID INT)
INSERT INTO @Operacao
Select 
  TipoID, Tipo, Estoque,
  case 
    When TipoID =1 then 1
	When TipoID =2 then 2
	When TipoID In(7, 8, 9, 10)  then 3
	When TipoID =13 then 4
	When TipoID = 4 then 5
	When TipoID =11 then 6
	When Estoque =1 OR Financeiro=-1 then 7
	When Estoque =-1 OR Financeiro=1 then 8
  end OperacaoID
from LkpNota0
Where Estoque<>0

UPDATE COM_ITE_MOV SET
 VL_CustoMedio=dbo.COM_ITE_PRC.Valor,
 VL_CustoBruto=dbo.COM_ITE_PRC.Valor,
 CFOP= CASE 
   WHEN IM.TipoID IN (7,8,9,10) AND (P.AtividadesID=0 OR P.Inscricao IS NULL) AND U.UFID<>P.UFID THEN 6108
   WHEN U.UFID=P.UFID THEN IIF(Operacao.Estoque=1, 1000, 5000)+T.CFOP
   WHEN U.UFID<>P.UFID THEN IIF(Operacao.Estoque=1, 2000, 6000)+T.CFOP
 END,
 CST_IPI  = T.CST_IPI * @Calcula,
 BC_IPI=@Calcula * IIF(T.Aliq_IPI>0, VL_Item,0),
 Aliq_IPI = T.Aliq_IPI * @Calcula, 
 CST_ICMS = T.CST_ICMS  * @Calcula, 
 Modalidade_ICMS = T.Modalidade_ICMS  * @Calcula,
 ReducaoICMS =  @Calcula * T.ReducaoICMS  * @Calcula,  
 BC_ICMS= (@Calcula * IIF(T.CST_ICMS IN (0, 10, 20, 70, 101, 201), VL_Liquido + VL_Frete+VL_Seguro+VL_Outro+VL_IPI * IIF(P.AtividadesID=0 OR P.Inscricao IS NULL, 1, 0),0)),
 ALIQ_ICMS = @Calcula * IIF(T.CST_ICMS IN (0, 10, 20, 70, 101, 201),IIF(T.Aliq_ICMS>0, T.Aliq_ICMS, ICMS.ICMS), 0),    
 MVA = CASE 
           WHEN T.CST_ICMS IN (10, 70, 201) THEN T.MVA_Pauta
	  	   WHEN M.TipoID IN (7,8,9,10) AND (P.AtividadesID=0 OR P.Inscricao IS NULL) AND U.UFID<>P.UFID THEN 1
           ELSE 0 
		 END,
 Modalidade_ICMSSub = T.Modalidade_ICMSSub, 
 Aliq_ICMSSub = @Calcula * IIF(T.CST_ICMS IN(10, 70, 201) 
                               OR (M.TipoID IN (7,8,9,10) 
							       AND (P.AtividadesID=0 OR P.Inscricao IS NULL) 
								   AND U.UFID<>P.UFID)  , IIF(T.Aliq_ICMSSub>0, T.Aliq_ICMSSub, ICMSST.ICMS), 0), 

 CST_PIS = @Calcula * T.CST_PIS,
 Aliq_PIS = @Calcula * IIF(T.Aliq_PIS>0, T.Aliq_PIS, FIS_Unidade.PIS),
 CST_COFINS = @Calcula * T.CST_COFINS,
 Aliq_COFINS = @Calcula * IIF(T.Aliq_COFINS>0, T.Aliq_COFINS, FIS_Unidade.COFINS)
FROM MovNota0 M    
  JOIN COM_ITE_MOV IM ON IM.Chave=M.Chave
  JOIN dbo.COM_ITE_PRC ON COM_ITE_PRC.UnidadeID = IM.UnidadeID AND COM_ITE_PRC.ItemID = IM.ItemID AND COM_ITE_PRC.PrecoID=1
  JOIN VWS_Unidades U ON U.UnidadeID=IM.UnidadeID
  JOIN dbo.FIS_Unidade ON FIS_Unidade.UnidadeID = U.UnidadeID
  JOIN VWS_Pessoas P ON P.PessoaID=M.PessoaID  
  JOIN COM_ITE_CAD I ON I.ItemID=IM.ItemID
  JOIN dbo.FIS_NCM ON FIS_NCM.NCM = I.NCM
  JOIN @Operacao Operacao ON Operacao.TipoID = M.TipoID
  JOIN FIS_GRP_TRB T ON T.GFID=dbo.FIS_NCM.GFID
  JOIN VWS_ICMS_Aliquotas ICMS 
    ON ICMS.Emi_UFID = IIF(Operacao.Estoque=1, P.UFID, U.UFID) 
   AND ICMS.Dest_UFID = IIF(Operacao.Estoque=-1, P.UFID, U.UFID)
   JOIN VWS_ICMS_Aliquotas ICMSST 
    ON ICMSST.Emi_UFID = ICMSST.Dest_UFID
   AND ICMSST.Dest_UFID = IIF(Operacao.Estoque=1, U.UFID, P.UFID)   
WHERE M.Chave=@Chave
 AND Operacao.OperacaoID=t.OperacaoID 


--BC
UPDATE COM_ITE_MOV SET 
  BC_ICMS = BC_ICMS * (100 - ReducaoICMS) / 100,
  BC_ICMSSub= @Calcula * (VL_Liquido + VL_Frete+VL_Seguro+VL_Outro+VL_IPI) * MVA,
  BC_PIS= @Calcula *IIF(Aliq_PIS>0, VL_Liquido-VL_ICMS,0),
  BC_COFINS= @Calcula * IIF(Aliq_COFINS>0, VL_Liquido-VL_ICMS,0) 
WHERE Chave=@Chave

GO
