SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE Procedure [dbo].[sp_R_FaturamentoItem]
  @UnidadeID int      = null,
  @DtIni     DateTime = null,
  @DtFin     DateTime = null,
  @StatusID  Int      = Null, 
  @ModeloID  Int      = Null,
  @Pessoaid  Int      = Null,
  @ItemID    Int      = null
AS  

Select UnidadeID, Unidade
Into #Unidades
from CadUnid0
where (@UnidadeID Is Null OR Power(2, UnidadeID)& @UnidadeID <> 0 )

Select StatusID, Status
Into #lkpNota1
From lkpNota1
where (@StatusID Is Null OR Power(2, StatusID)& @StatusID <> 0 )

SELECT            
  MovNota0.Chave Chave,
  Modelo, 
  MovFisc0.NF, 
  MovFisc0.DtEmissao
Into #Notas  
From MovNota0
  JOIN #Unidades on #Unidades.UnidadeID=MovNota0.UnidadeID
  JOIN  LkpNota0  ON LkpNota0.TipoID = MovNota0.TipoID
  JOIN  #LkpNota1
     ON #LkpNota1.StatusID = MovNota0.StatusID   
  JOIN MOvFisc0
    ON MOvFisc0.UnidadeID  = MovNota0.UnidadeID
   AND MOvFisc0.TipoID    = MovNota0.TipoID
   AND MOvFisc0.Nota      = MovNota0.Nota     
  JOIN LkpFisc0
    ON MOvFisc0.ModeloID = LkpFisc0.ModeloID      
Where  MovNota0.StatusID in(2,3)
   AND MovNota0.TipoID in(7,8,9,10,13)
   AND (@DtIni     Is Null OR Convert(Date,MovNota0.Dtmovimento)  >= @DtIni)
   AND (@DtFin     Is Null OR Convert(Date,MovNota0.Dtmovimento)  <= @DtFin)
   AND (@ModeloID  IS NULL OR Power(2, MovFisc0.ModeloID) & @ModeloID <> 0 )
   AND (@PessoaID  Is Null OR MovNota0.PessoaID   = @PessoaID)


Select 
  MovNota0.Chave,
  COM_ITE_MOV.ItemID ItemID,
  Case when LkpNota0.Financeiro = 1 then 'Venda' else 'Devolução' end Operacao,
  MovNota0.DtMovimento,
  IsNull(#Notas.Modelo, 'Pedido')Modelo,
  #Notas.NF,
  #Notas.DtEmissao,
  VWS_Pessoas.Nome Cliente, 
  VWS_Pessoas.UF, 
  ISnULL(Area,'Indefinida')Area,
  
  Case MovNota0.StatusID
    When 1 then 'Pendente'
    When 2 then 'Faturada'
    When 3 then 'Extornada'
  End Status, VWS_Pessoas.Cidade,
    LkpNota0.Sigla
from MovNota0
  jOIN #Unidades on #Unidades.UnidadeID=MovNota0.UnidadeID
  Join LkpNota0
     ON LkpNota0.TipoID = MovNota0.TipoID
   Join  #LkpNota1
     ON #LkpNota1.StatusID = MovNota0.StatusID     
  INNER Join VWS_Pessoas
     ON MovNota0.PessoaID = VWS_Pessoas.PessoaID
  LEFT JOIN PesClie0
     ON PesClie0.PessoaID = VWS_Pessoas.PessoaID 
  left JOIN CadArea0
    ON CadArea0.AreaID = PesClie0.AreaID   
  Inner Join #Notas
     on #Notas.Chave=MovNota0.Chave  
  JOIN COM_ITE_MOV
    ON COM_ITE_MOV.UnidadeID  = MovNota0.UnidadeID
   AND COM_ITE_MOV.TipoID     = MovNota0.TipoID
   AND COM_ITE_MOV.Nota       = MovNota0.Nota   
  INNER JOIN COM_ITE_UND
    ON COM_ITE_UND.UnidadeID = COM_ITE_MOV.UnidadeID
   AND COM_ITE_UND.ItemID = COM_ITE_MOV.ItemID
  INNER JOIN COM_ITE_CAD
    ON COM_ITE_CAD.ItemID = COM_ITE_UND.ItemID       
Where  MovNota0.StatusID in(2,3)
   AND MovNota0.TipoID in(7,8,9,10, 13)
   AND (@DtIni     Is Null OR Convert(Date,MovNota0.Dtmovimento)  >= @DtIni)
   AND (@DtFin     Is Null OR Convert(Date,MovNota0.Dtmovimento)  <= @DtFin)
   AND (@PessoaID  Is Null OR MovNota0.PessoaID   = @PessoaID) 
   AND (@ItemID  Is Null OR COM_ITE_MOV.ItemID   = @ItemID) 
Order by MovNota0.DtMovimento, MovNota0.Chave   
                        
drop table #Notas
GO
