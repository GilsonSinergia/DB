SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE                   Procedure [dbo].[SP_R_Sintegra]

@UnidadeID   int ,
@DtIni       datetime  = null,
@DtFin       datetime  = null,
@Registro    Char(3),
@Tipo75      Int =7,
@NF          Int = Null



AS



Create Table #Notas
  (
   UnidadeID Int Not Null,
   TipoID    Int Not Null,
   Nota      Int Not Null,
   PessoaID  Int Not Null,
   Documento VarChar(14) Not Null,
   Inscricao VarChar(20) Not Null,
   UF        Char(3) Not Null,
   UFUnidade Char(3) Not Null,
   Serie     Char(3) Not Null,
   NF        Int Not Null, 
   Emitente  Char(1) Not Null,
   ModeloID  Int Not Null, 
   Status    Char(1) Not Null
   )

Insert Into #Notas 
Select MovFisc0.UnidadeID, 
       MovFisc0.TipoID, 
       MovFisc0.Nota, 
       MovNota0.PessoaID, 
       VWS_Pessoas.Documento, 
       Case when Len(VWS_Pessoas.Documento)= 14 
             AND Len(VWS_Pessoas.Inscricao)>0 then VWS_Pessoas.Inscricao else 'ISENTO' END, 
       VWS_Pessoas.UF,
       CadUnid0.UF,
       Serie, 
       convert ( int, right(NF,6)),
       Case when CadUnid0.PessoaID=MovFisc0.PessoaID then 'P' else 'T' end Emitente, 
       ModeloID, 
       Case MovNota0.StatusID when 2 then 'N' when 3 then 'S' end Status
From MovFisc0
  INNER JOIN VWS_Unidades CadUnid0
     ON CadUnid0.UnidadeID = MovFisc0.UnidadeID
   INNER JOIN MovNota0
    on MovFisc0.UnidadeID = MovNota0.UnidadeID
   AND MovFisc0.TipoID    = MovNota0.TipoID
   AND MovFisc0.Nota      = MovNota0.Nota
  INNER JOIN VWS_Pessoas
     on VWS_Pessoas.PessoaID = MovNota0.PessoaID
  Inner Join Lkpnota0
     On Lkpnota0.TipoID = Movnota0.TipoID
Where MovNota0.StatusID  In (2,3)
  AND MovNota0.UnidadeID = @UnidadeID
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  And (lkpnota0.Estoque = -1 Or MovNota0.StatusID = 2) 



If @Registro = '10'  begin

Select Documento CNPJ, Inscricao, Nome Razao,  IsNull(Numero,0)Numero,
       UF, Fax, Endereco, Bairro, Cidade, UF, CEP, Contato, Tel
from VWS_Unidades
Where UnidadeID = @UnidadeID

end


If  @NF is not null  OR  @Registro = '50' begin

Create Table #50 
  ( 
   UnidadeID Int Not Null,
   TipoID    Int Not Null,
   Nota      Int Not Null,
   Documento   Varchar(14) not Null,
   IE          Varchar(20) not Null,
   AliqICMS    Decimal(18,2)   Null,
   DtMovimento Datetime not Null,
   UF          Char(2)not Null,
   Modelo      int not Null,
   Serie       Char(3) not Null,
   NF          Int   not Null,
   CFO         Char(4) null,
   Total       Decimal(18,2) not Null,
   BaseICMS    Decimal(18,2) not Null,
   ICMS        Decimal(18,2) not Null,
   Isento      Decimal(18,2) not Null,
   Outras      Decimal(18,2) not Null,   
   Status      Char(1)not Null,
   Emitente    Char(1)not Null
   )

Insert into #50
Select MovNota0.UnidadeID,
	   MovNota0.TipoID,
	   MovNota0.Nota,
	   VWS_Pessoas.Documento,
	   Case when LEN(Notas.Inscricao)=0 then 'ISENTO' else isnull(Notas.Inscricao,'ISENTO') end Inscricao,
	   COM_ITE_MOV.Aliq_ICMS,
	   MovNota0.DtMovimento,
	   VWS_Pessoas.UF,
	   ModeloDesc Modelo, 
       Notas.Serie, 
       Notas.NF,
       COM_ITE_MOV.CFOP,
	   sum(COM_ITE_MOV.Totalliquido + COM_ITE_MOV.vl_ipi + COM_ITE_MOV.frete + COM_ITE_MOV.seguro + COM_ITE_MOV.outro
	     + COM_ITE_MOV.vl_icmssub) Total,
	   --convert(decimal(18,2),(sum(COM_ITE_MOV.Total) / MovFisc0.Liquido ) * MovProd0.Total) Total,
       Sum(COM_ITE_MOV.BC_ICMS) BaseICMS,
       sum(COM_ITE_MOV.Vl_ICMS) ICMS,
       0.00 Isento,
       sum(COM_ITE_MOV.Vl_ICMSsub + COM_ITE_MOV.Vl_ipi) Outras,
       Status, 
       Notas.Emitente 
From movnota0 
Inner JOIN #Notas Notas
    on Notas.UnidadeID = MovNota0.UnidadeID
   AND Notas.TipoID    = MovNota0.TipoID
   AND Notas.Nota      = MovNota0.Nota
inner join COM_ITE_MOV
  on COM_ITE_MOV.UnidadeID = movnota0.UnidadeID
 and COM_ITE_MOV.TipoID = movnota0.TipoID
 and COM_ITE_MOV.Nota = movnota0.Nota
inner join movfisc0
  on movfisc0.UnidadeID = movnota0.UnidadeID
 and movfisc0.TipoID = movnota0.TipoID
 and movfisc0.Nota = movnota0.Nota
  Inner JOIN LkpFisc0
    on Notas.ModeloID = LkpFisc0.ModeloID
Inner join VWS_Pessoas
  on VWS_Pessoas.PessoaID = MovNota0.PessoaID
Inner join lkpnota0
  on lkpnota0.TipoID = MovNota0.TipoID
Where (MovNota0.StatusID  = 2 or (lkpnota0.estoque = -1 and MovNota0.StatusID in(2,3)))
  AND MovNota0.UnidadeID = @UnidadeID
  -- Quaisquer alteracao deve ser replicadas para registros 51, 53, 54, 56, 70 e 75  
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  AND Notas.ModeloID In(1, 3)
  and (@NF is null or Notas.NF = @NF)
group by movnota0.UnidadeID,
	   movnota0.TipoID,
	   movnota0.Nota,
	   VWS_Pessoas.Documento,
	   VWS_Pessoas.Inscricao,
	   COM_ITE_MOV.Aliq_ICMS,
	   MovNota0.DtMovimento,
	   VWS_Pessoas.UF,
	   ModeloDesc , 
       Notas.Serie, 
       Notas.NF,
       COM_ITE_MOV.CFOP,
        MovFisc0.Liquido,MovProd0.Total ,
       MovProd0.Frete ,
       MovProd0.Outro, 
       Status, 
       Notas.Emitente,Notas.Inscricao


Select * from #50
where @NF is null or NF=@NF
Order by DtMovimento, Documento, NF, Serie, CFO

end



--icms sub
If  @Registro = '53'

Select MovNota0.TipoID, MovNota0.Nota,
       Notas.Documento,
       Notas.Inscricao,
       MovNota0.DtMovimento,
       Notas.UF, 
       ModeloID Modelo,
       Notas.Serie , 
       Notas.NF,
       CFOP, 
       Emitente,
       Sum(COM_ITE_MOV.BC_ICMSSUB)BaseICMSSub, 
       Sum(COM_ITE_MOV.VL_ICMSSUB)ICMSSub, 
       MovProd0.Frete + MovProd0.Seguro + MovProd0.Outro Despesas,
       Status,
       Emitente
From MovNota0
  INNER JOIN #Notas Notas
    on Notas.UnidadeID = MovNota0.UnidadeID
   AND Notas.TipoID    = MovNota0.TipoID
   AND Notas.Nota      = MovNota0.Nota
  INNER JOIN MovProd0
    on MovProd0.UnidadeID = MovNota0.UnidadeID
   AND MovProd0.TipoID    = MovNota0.TipoID
   AND MovProd0.Nota      = MovNota0.Nota
  Inner join lkpnota0
  on lkpnota0.TipoID = MovNota0.TipoID
Where (MovNota0.StatusID  = 2 or (lkpnota0.estoque = -1 and MovNota0.StatusID in(2,3)))
  AND ModeloID in(1, 3)
  and COM_ITE_MOV.BC_ICMSSUB > 0
  AND MovNota0.UnidadeID =   @UnidadeID
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  AND (@NF IS null or (Notas.NF)= @NF)
group by Notas.Documento,ModeloID,
       Notas.Inscricao,
       MovNota0.DtMovimento,
       Notas.UF, 
       Notas.Serie , 
       Notas.NF,
       CFOP, 
       MovProd0.Frete, MovProd0.Seguro, MovProd0.Outro,
       Status,
       Notas.Emitente, MovNota0.TipoID, MovNota0.Nota
Order BY Notas.Emitente desc, Documento, NF



If  @NF is not null OR   @Registro = '54'Begin 

Create Table #54 
  ( 
   Documento  Varchar(14) not Null,
   Modelo     int Not Null,
   Serie      char(3) not Null,
   NF         int Not Null,
   CFO        Char(4)not null,
   STID       int not null,
   ProdutoID  int not null,
   Quantidade Decimal(18,2) not null,
   Total      Decimal(18,2) not null,
   Desconto   Decimal(18,8) not null,
   BaseICMS   Decimal(18,2)  not null,
   BaseICMSub Decimal(18,2)  not null,
   IPI        Decimal(18,2)  not null,
   ICMS       Decimal(18,2)  not null,
   Emitente   Char(1) not null
   
  )

Insert Into #54 
Select Documento,
       ModeloDesc Modelo,
       Notas.Serie,
       Notas.NF,
       CFOP,
       COM_ITE_MOV.CST_ICMS, 
       COM_ITE_MOV.ItemID, 
       COM_ITE_MOV.Quantidade, 
       (COM_ITE_MOV.TotalLiquido + COM_ITE_MOV.Frete + COM_ITE_MOV.Seguro + COM_ITE_MOV.Outro +
		COM_ITE_MOV.VL_ICMSSUB + COM_ITE_MOV.Vl_IPI) Total, 
       0.00 Desconto,
       COM_ITE_MOV.BC_ICMS BaseICM,
       COM_ITE_MOV.BC_ICMSSub BaseICMSub,
       Case When MOvNota0.TipoID in (1,5) then 0.00 else COM_ITE_MOV.Aliq_IPI end IPI, 
       COM_ITE_MOV.Aliq_ICMS AliqICMS,
      Emitente
From MovNota0
  INNER JOIN COM_ITE_MOV
    on COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
   AND COM_ITE_MOV.TipoID    = MovNota0.TipoID
   AND COM_ITE_MOV.Nota      = MovNota0.Nota
  INNER JOIN #Notas Notas
    on Notas.UnidadeID = MovNota0.UnidadeID
   AND Notas.TipoID    = MovNota0.TipoID
   AND Notas.Nota      = MovNota0.Nota
  Inner JOIN LkpFisc0
    on Notas.ModeloID = LkpFisc0.ModeloID
Where MovNota0.StatusID  In (2)
  AND MovNota0.UnidadeID = @UnidadeID
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  AND Notas.ModeloID In(1, 3)
 


Select * From #54 
--where NF = 142761
Where (@NF is null or NF = @NF) 

Order By Emitente Desc, Documento, NF, CFO, ProdutoID


end


/*
If @NF IS Not Null OR  @Registro = '56'

Select Documento,
       1 Modelo,
       Notas.Serie,
       Notas.NF,
       CFO,
       CadTrib0.STID, 
       COM_ITE_MOV.ItemID,
       Case when Substring(CFO,1,1) in(1,2,3)then 1 else 0 end Tipo,
       '00000000000000' CNPJConsercionaria,
       COM_ITE_MOV.IPI ,
       PrdLote0.Lote
From MovNota0
  INNER JOIN COM_ITE_MOV
    on COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
   AND COM_ITE_MOV.TipoID    = MovNota0.TipoID
   AND COM_ITE_MOV.Nota      = MovNota0.Nota
   INNER JOIN PrdLote0
    on COM_ITE_MOV.UnidadeID = PrdLote0.UnidadeID
   AND COM_ITE_MOV.TipoID    = PrdLote0.TipoID
   AND COM_ITE_MOV.Nota      = PrdLote0.Nota
   AND COM_ITE_MOV.ItemID= PrdLote0.ProdutoID
  INNER JOIN #Notas Notas
    on Notas.UnidadeID = MovNota0.UnidadeID
   AND Notas.TipoID    = MovNota0.TipoID
   AND Notas.Nota      = MovNota0.Nota
Where MovNota0.StatusID  In (2, 3)
  AND MovNota0.TipoID in (8,9)
  AND MovNota0.UnidadeID = @UnidadeID
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  AND (@NF IS null or NF = @NF)
Order By Emitente Desc, Documento, NF, CFO, COM_ITE_MOV.ItemID
*/


If    @Registro = '60M'
SELECT 
  PAF_ECF_RZM.Data,
  PAF_ECF_RZM.Serie,
  IsNull(MIN(PAF_ECF_Movimento.COO),PAF_ECF_RZM.COO) IniCOO,
  PAF_ECF_RZM.COO,
  PAF_ECF_Cadastro.Caixa,
  PAF_ECF_RZM.CRZ,
  PAF_ECF_RZM.CRO,
  PAF_ECF_RZM.BRT,
  PAF_ECF_RZM.GT
FROM PAF_ECF_RZM
  Join VWS_Unidades on VWS_Unidades.Documento=PAF_ECF_RZM.CNPJ
  JOIN PAF_ECF_Cadastro on PAF_ECF_Cadastro.Serie=PAF_ECF_RZM.Serie
  LEFT JOIN PAF_ECF_Movimento
    on PAF_ECF_Movimento.Serie=PAF_ECF_RZM.Serie
   AND PAF_ECF_Movimento.Data=PAF_ECF_RZM.Data
Where UnidadeID =@UnidadeID  
  AND  Year(PAF_ECF_RZM.Data) = DatePart (yy,@DtIni)
  AND Month(PAF_ECF_RZM.Data) = DatePart (mm,@DtIni)   
Group by 
  PAF_ECF_RZM.Data,
  PAF_ECF_RZM.Serie,
  PAF_ECF_RZM.COO,
  PAF_ECF_Cadastro.Caixa,
  PAF_ECF_Cadastro.Modelo,
  PAF_ECF_RZM.CRZ,
  PAF_ECF_RZM.CRO,
  PAF_ECF_RZM.BRT,
  PAF_ECF_RZM.GT



If  @Registro = '60A'

SELECT 
  PAF_ECF_RZM.Serie,
  PAF_ECF_RZM.Data,
  Case 
    when PAF_ECF_RZA.Totalizador in('F', 'F1') then 'F'
    when PAF_ECF_RZA.Totalizador = 'I1' then 'I'
    when PAF_ECF_RZA.Totalizador = 'N1' then 'N'
    when PAF_ECF_RZA.Totalizador in( 'Canc-T','Can-T') then 'CANC'
    when PAF_ECF_RZA.Totalizador = 'DT' then 'DESC'

    else   case 
	        when charindex('T', PAF_ECF_RZA.Totalizador) > 0 then 
				substring(PAF_ECF_RZA.Totalizador,4, len(PAF_ECF_RZA.Totalizador)) 
		else PAF_ECF_RZA.Totalizador end
  end Totalizado,
  PAF_ECF_RZA.Total  
FROM PAF_ECF_RZM
  JOIN PAF_ECF_RZA
    ON PAF_ECF_RZA.Serie=PAF_ECF_RZM.Serie
   AND PAF_ECF_RZA.COO=PAF_ECF_RZM.COO 
  Join VWS_Unidades on VWS_Unidades.Documento=PAF_ECF_RZM.CNPJ 
Where UnidadeID =@UnidadeID  
  AND  Year(PAF_ECF_RZM.Data) = DatePart (yy,@DtIni)
  AND Month(PAF_ECF_RZM.Data) = DatePart (mm,@DtIni) 


If  @Registro = '60R'

Select 
 Replace(STR(Month(PAF_ECF_Movimento.DtMovimento),2,0),' ', '0')
 +Replace(STR(Year(PAF_ECF_Movimento.DtMovimento),4,0),' ' , '0')Data,
 Convert(varchar(14),Com_Ite_Cad.ItemID) Codigo,
 SUM(PAF_ECF_CUPOM_Item.Quantidade)Quantidade,
 SUM(PAF_ECF_CUPOM_Item.Quantidade * PAF_ECF_CUPOM_Item.Unitario)Valor,
 SUM(case when PAF_ECF_CUPOM_Item.AliquotaID =1 then  PAF_ECF_CUPOM_Item.Quantidade * PAF_ECF_CUPOM_Item.Unitario else 0 end)BaseICMS,
 Case 
   when PAF_ECF_CUPOM_Item.AliquotaID = 1  then REPLACE( STR(PAF_ECF_CUPOM_Item.Aliquota * 100, 4,0), ' ','0')  
   when PAF_ECF_CUPOM_Item.AliquotaID = 2  then 'I'
   when PAF_ECF_CUPOM_Item.AliquotaID = 3  then 'N'
   when PAF_ECF_CUPOM_Item.AliquotaID = 4  then 'F'
   ELSE 'ISS'
 end ST 
from PAF_ECF_CUPOM_Item
  JOIN PAF_ECF_Movimento
    on PAF_ECF_Movimento.Serie=PAF_ECF_CUPOM_Item.Serie
   AND PAF_ECF_Movimento.COO=PAF_ECF_CUPOM_Item.COO 
   Inner Join Com_Ite_Cad
     On Paf_Ecf_Cupom_Item.Codigo = Com_Ite_Cad.ItemID  
  Join VWS_Unidades on VWS_Unidades.Documento=PAF_ECF_Movimento.CNPJ 
   Inner Join paf_ecf_cupom
     On paf_ecf_cupom.serie = paf_ecf_cupom_item.serie
	And paf_ecf_cupom.Coo = paf_ecf_cupom_item.Coo 
 Where UnidadeID =@UnidadeID  
  AND  Year(PAF_ECF_Movimento.Data) = DatePart (yy,@DtIni)
  AND Month(PAF_ECF_Movimento.Data) = DatePart (mm,@DtIni) 
  And   paf_ecf_cupom.cancelado = 0
Group by 
  Replace(STR(Month(PAF_ECF_Movimento.DtMovimento),2,0),' ', '0')
 +Replace(STR(Year(PAF_ECF_Movimento.DtMovimento),4,0),' ' , '0'),
   Com_Ite_Cad.ItemID,
  PAF_ECF_CUPOM_Item.AliquotaID,
  PAF_ECF_CUPOM_Item.Aliquota
Order by data,  Com_Ite_Cad.ItemID





--select * from MovProd0
If  @Registro = '70'

Select VWS_Pessoas.Documento,
       VWS_Pessoas.Inscricao,
       DtMovimento,
       VWS_Pessoas.UF, 
       8 Modelo, 
       CTE_Conhecimento.Serie,CTE_Conhecimento.NUM_DOC NF,
       CTE_Conhecimento.CFOP CFO, 
       Total, 
       CTE_Conhecimento.BC_ICMS BaseIcms, 
       CTE_Conhecimento.ICMS,
       0 Isencao, 
       Abs(Total - CTE_Conhecimento.BC_ICMS)  Outros, 
       TipoFrete,
       Case MovNota0.StatusID when 2 then 'N' when 3 then 'S' end Situacao
From  MovNota0
  INNER JOIN VWS_Pessoas
     ON VWS_Pessoas.PessoaID = MovNota0.PessoaID
  INNER JOIN CTE_Conhecimento  
     ON CTE_Conhecimento.UnidadeID = MovNota0.UnidadeID
    AND CTE_Conhecimento.TipoID    = MovNota0.TipoID
    AND CTE_Conhecimento.Nota      = MovNota0.Nota
Where MovNota0.TipoID = 19
  AND MovNota0.StatusID=2
  AND MovNota0.UnidadeID = @UnidadeID
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin



--If  @NF is not Null  OR   @Registro = '74' Begin


--Select  Case when GetDate() < @DtFin then GetDate() else @DtFin end  Data,
--        COM_ITE_UND.ItemID,
--        Estoque.Fisico,
--        Convert(Decimal(18, 2),Estoque.Fisico * ProPrec0.Valor) Valor,
--        1 Posse,   
--        '00000000000000' CNPJ,
--        '              ' IE,
--        'BA' UF 
--FROM COM_ITE_UND
--  INNER JOIN  DBO.fn_Estoque(@UnidadeID, Default, Default ,@Dtfin) Estoque
--    ON Estoque.ProdutoID = CadProd1.ProdutoID
-- Inner Join FN_Preco(@UnidadeID,Null,Null,Null) ProPrec0
--    On ProPrec0.UnidadeID = COM_ITE_UND.UnidadeID
--   And ProPrec0.ProdutoID = COM_ITE_UND.ItemID
--Where ProPrec0.PrecoID = 1
--    AND CadProd1.UnidadeID = @UnidadeID
--    AND Fisico > 0
--    AND OrigemID=0
--end
     
If  @NF is not Null  OR   @Registro = '75' Begin

Create Table #75
    (
     DtInicio    DateTime     Not Null,
     DtFim       DateTime     Not Null,
     NCM         INT          null,
     ProdutoID   Int          Not Null,
     Produto     Varchar(200)  Not Null,
     UN          Char(3)      Not Null,
     IPI         Float        Not Null,
     ICMS        Float        Not Null,
     BaseICMS    Float        Not Null,
     BaseICMSSub Float        Not Null

)

--75 do 54
insert into #75
Select  @DtIni,
        @DtFin,
        COM_ITE_CAD.NCM,
        COM_ITE_CAD.ItemID,
        COM_ITE_CAD.Item,
        CadMedi0.UN,
        FIS_ITE_NCM_CAD.IPI, 
        0.00 ICMS,
        0.00 BaseICMS,
        0.00 BaseICMSSub                
FROM COM_ITE_CAD 
  Inner Join COM_ITE_PRD
     On COM_ITE_PRD.ItemID = COM_ITE_CAD.ItemID
  Inner Join COM_ITE_UND
     On COM_ITE_UND.ItemID = COM_ITE_CAD.ItemID
  INNER JOIN CadMedi0
     ON CadMedi0.MedidaID = COM_ITE_PRD.MedidaID
  Inner Join FIS_ITE_NCM_CAD
     On FIS_ITE_NCM_CAD.NCM = COM_ITE_CAD.NCM
  INNER JOIN COM_ITE_MOV
     ON COM_ITE_MOV.UnidadeID = COM_ITE_UND.UnidadeID
    AND COM_ITE_MOV.ItemID= COM_ITE_CAD.ItemID
  INNER JOIN MovNota0
     ON MovNota0.UnidadeID = COM_ITE_MOV.UnidadeID
    AND MovNota0.TipoID    = COM_ITE_MOV.TipoID
    AND MovNota0.Nota      = COM_ITE_MOV.Nota
  INNER JOIN Movfisc0 Notas
    on Notas.UnidadeID = MovNota0.UnidadeID
   AND Notas.TipoID    = MovNota0.TipoID
   AND Notas.Nota      = MovNota0.Nota 
   Left Join #75
    On #75.produtoID=COM_ITE_CAD.ItemID
Where MovNota0.StatusID  In (2)
  AND MovNota0.UnidadeID    = @UnidadeID
  AND Movnota0.Tipoid  <> 19
  AND MovNota0.DtMovimento >= @DtIni
  AND MovNota0.DtMovimento <= @DtFin
  And Notas.ModeloID in (1,3)  
  AND(@NF is null Or Notas.NF = @NF)
  And  2 & @Tipo75 <> 0 
  And #75.produtoID is null
Order by MovNota0.DtMovimento,COM_ITE_CAD.ItemID


 --75 do 60
 insert into #75
 Select @DtIni,
        @DtFin,
        COM_ITE_CAD.NCM,
        COM_ITE_CAD.ItemID,
        COM_ITE_CAD.Item,
        CadMedi0.UN,
        FIS_ITE_NCM_CAD.IPI, 
        0.00 ICMS,
        0.00 BaseICMS,
        0.00 BaseICMSSub                
FROM COM_ITE_CAD 
  Inner Join COM_ITE_PRD
     On COM_ITE_PRD.ItemID = COM_ITE_CAD.ItemID
  Inner Join COM_ITE_UND
     On COM_ITE_UND.ItemID = COM_ITE_CAD.ItemID
  INNER JOIN CadMedi0
     ON CadMedi0.MedidaID = COM_ITE_PRD.MedidaID
  Inner Join FIS_ITE_NCM_CAD
     On FIS_ITE_NCM_CAD.NCM = COM_ITE_CAD.NCM
  Inner Join paf_ecf_cupom_item
     On Paf_Ecf_Cupom_Item.Codigo = COM_ITE_UND.ItemID
  Inner Join paf_ecf_cupom
     On paf_ecf_cupom.serie = paf_ecf_cupom_item.serie
	And paf_ecf_cupom.Coo = paf_ecf_cupom_item.Coo
  Inner Join paf_ecf_Movimento
     On paf_ecf_Movimento.serie = paf_ecf_cupom.serie
	And paf_ecf_Movimento.Coo = paf_ecf_cupom.Coo
  Inner Join VWS_Unidades
     On VWS_Unidades.Documento = paf_ecf_Movimento.cnpj  
   Left Join #75
    On #75.produtoID=COM_ITE_CAD.ItemID
Where paf_ecf_cupom.Cancelado = 0
  AND VWS_Unidades.UnidadeID    = @UnidadeID
  AND Convert(Date,paf_ecf_Movimento.Data) >= @DtIni
  AND Convert(Date,paf_ecf_Movimento.Data) <= @DtFin
  And 4 & @Tipo75 <> 0
  And #75.produtoID is null
  Order by paf_ecf_Movimento.Data, COM_ITE_CAD.ItemID



--insert into #75
----75 do 74
--Select  @DtIni,
--        @DtFin,
--        COM_ITE_CAD.NCM,
--        COM_ITE_CAD.ItemID,
--        COM_ITE_CAD.Item,
--        CadMedi0.UN,
--        FIS_ITE_NCM_CAD.IPI, 
--        0.00 ICMS,
--        0.00 BaseICMS,
--        0.00 BaseICMSSub    
--FROM COM_ITE_CAD 
--  Inner Join COM_ITE_PRD
--     On COM_ITE_PRD.ItemID = COM_ITE_CAD.ItemID
--  Inner Join COM_ITE_UND
--     On COM_ITE_UND.ItemID = COM_ITE_CAD.ItemID
--  INNER JOIN CadMedi0
--     ON CadMedi0.MedidaID = COM_ITE_PRD.MedidaID
--  Inner Join FIS_ITE_NCM_CAD
--     On FIS_ITE_NCM_CAD.NCM = COM_ITE_CAD.NCM
--  INNER JOIN  DBO.fn_Estoque(@UnidadeID, Default,Default,@dtFin) Estoque
--    ON Estoque.ProdutoID = COM_ITE_PRD.ItemID
--   Left Join #75
--    On #75.produtoID=COM_ITE_CAD.ItemID
-- Where  COM_ITE_UND.UnidadeID = @UnidadeID
--    AND Estoque.Fisico > 0
--    AND COM_ITE_UND.OrigemID=0
--    And 8 & @Tipo75 <> 0 
--    And #75.produtoID is null
--Order by  COM_ITE_CAD.ItemID
		             

Select  DtInicio, DtFim, NCM, ProdutoID, Produto, UN, IPI, ICMS, BaseICMS, BaseICMSSub  
From #75
group by DtInicio, DtFim, NCM, ProdutoID, Produto, UN, IPI, ICMS, BaseICMS, BaseICMSSub  
end
GO
