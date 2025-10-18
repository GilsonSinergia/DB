SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [dbo].[SP_CopiaMovimento]
  @UnidadeID        INT,
  @TipoID           INT,
  @Nota             INT,
  @DestinoUnidadeID INT,
  @DestinoTipoID    INT,
  @UsuarioID        INT = 1
AS
--Cria tabela tempoária para saber os itens serem cadastrados
Set nocount ON 
Select COM_ITE_MOV.ItemID
Into #Cadastrar
From  COM_ITE_MOV 
 Inner Join MovNota0
   On MovNota0.UnidadeID = COM_ITE_MOV.UnidadeID
  And MovNota0.TipoID    = COM_ITE_MOV.TipoID
  And MovNota0.Nota      = COM_ITE_MOV.Nota
 Inner Join CadUnid0 Destinatario
   On Destinatario.UnidadeID  = @DestinoUnidadeID
 Inner Join CadUnid0 Origem
   On Origem.UnidadeID = MovNota0.UnidadeID
 Left Join COM_ITE_UND
   On COM_ITE_UND.UnidadeID = Destinatario.UnidadeID
  And COM_ITE_UND.ItemID    = COM_ITE_MOV.ItemID
Where MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota 
  And COM_ITE_UND.UnidadeID IS Null 



IF EXISTS ( SELECT ItemID FROM #Cadastrar ) 
Begin
  --Exibe a mensagem dos itens
	DECLARE
	@SQLStr VARCHAR(5000) 
	SET @SQLStr='' SELECT @SQLStr=@SQLStr+[a].[nota]+', ' 
	FROM (SELECT CONVERT(VARCHAR(20),ItemID) Nota FROM #Cadastrar ) As a 
	
	Set @SQLStr= '<<ATENÇÃO, os produtos: ' +LEFT(@SQLStr,len(@SQLStr)-1)+ ' devem ser cadastrados na unidade de destino antes de continuar>>'
	RAISERROR (@SQLStr, 16, 1)
END ELSE BEGIN


Declare @Gen_Nota   Int,--Variavel para geração do novo número de Nota
        @ParentTipo int,--Variavel preenchimento de campo parenttipo quando for devolução
        @ParentNota int --Variavel preenchimento de campo parentnota quando for devolução
        
--Se o tipo for devolução então parenttipo e parentnota serão preenchidos 
IF @DestinoTipoID in (2,13) begin
  Set @ParentTipo=@TipoID
  SET @ParentNota=@Nota
END	

--Geração do próximo número de Movimento (nota)
Select @Gen_Nota = IsNull(Max(Nota)+1,1) 
From MovNota0
Where UnidadeID = @DestinoUnidadeID
  AND TipoID    = @DestinoTipoID
 

--Preenchimento de MovNota0 (Movimentos)
INSERT INTO MovNota0
 (
  UnidadeID, 
  TipoID, 
  Nota, 
  DtMovimento, 
  PessoaID,  
  StatusID, 
  ParentTipoID, 
  ParentNota
  )
Select 
  @DestinoUnidadeID, 
  @DestinoTipoID, 
  @Gen_Nota 
  Nota, 
  CONVERT(Date,Getdate()) DtMovimento, 
  case when @DestinoTipoID = 4 then Origem.PessoaID else  MovNota0.PessoaID end,  
  0 StatusID,
  @ParentTipo, 
  @ParentNota
From MovNota0
  JOIN CadUnid0 Destinatario  On Destinatario.UnidadeID  = @DestinoUnidadeID
  JOIN dbo.UND_PES Origem On Origem.UnidadeID = MovNota0.UnidadeID
Where Origem.ID=1
  AND MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota      

  
--Preenchimento de MovVend0  
INSERT INTO MovVend0
Select  
  @DestinoUnidadeID, 
  @DestinoTipoID, 
  @Gen_Nota Nota, 
  MovVend0.PessoaID
From MovVend0
  JOIN MovNota0 ON MovNota0.Chave = MovVend0.Chave
  JOIN dbo.LkpNota0 ON LkpNota0.TipoID = MovNota0.TipoID
Where MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota 
  And (LkpNota0.Estoque=-1 or @DestinoTipoID in (2,13))   


--Preenchimento de COM_ITE_MOV    
Declare @Data Date 
Set @Data=GETDATE()

INSERT INTO [dbo].[COM_ITE_MOV]
           ([UnidadeID]
           ,[TipoID]
           ,[Nota]
           ,[Seq]
           ,[ItemID]
           ,[VL_CustoBruto]
           ,[VL_CustoMedio]
           ,[Comissao]
           ,[MaxDesconto]
           ,[MedidaID]
           ,[Fator]
           ,[Estoque]
           ,[Quantidade]
           ,[VL_Pedido]
           ,[VL_Unitario]
           ,[Desconto]
           ,[VL_Frete]
           ,[VL_Seguro]
           ,[VL_Outro]
           ,[CFOP]
           ,[OrigemID]
           ,[Descricao]
           ,[CST_IPI]
           ,[BC_IPI]
           ,[Aliq_IPI]
           ,[CST_ICMS]
           ,[Modalidade_ICMS]
           ,[ReducaoICMS]
           ,[BC_ICMS]
           ,[Aliq_ICMS]
           ,[Modalidade_ICMSSub]
           ,[MVA]
           ,[BC_ICMSSub]
           ,[Aliq_ICMSSub]
           ,[CST_II]
           ,[BC_II]
           ,[Aliq_II]
           ,[CST_ISS]
           ,[BC_ISS]
           ,[Aliq_ISS]
           ,[CST_PIS]
           ,[BC_PIS]
           ,[Aliq_PIS]
           ,[CST_COFINS]
           ,[BC_COFINS]
           ,[Aliq_COFINS]
           ,[Totalizar]
           ,[Valido])
     Select
          @DestinoUnidadeID, 
		  @DestinoTipoID, 
		  @Gen_Nota Nota,
          Seq, 
          COM_ITE_MOV.ItemID, 
          VL_CustoBruto, 
          VL_CustoMedio, 
          Comissao, 
          MaxDesconto, 
          MedidaID,
          Fator, 
          COM_ITE_MOV.Estoque, 
          Quantidade, 
          VL_Pedido, 
          VL_Unitario, 
          Desconto,
          VL_Frete, 
          VL_Seguro, 
          VL_Outro, 
          CASE
		    WHEN dbo.LkpNota0.Estoque= 1 AND LEFT(CFOP,1) = 5 THEN '1'+RIGHT(CFOP,3)
			WHEN dbo.LkpNota0.Estoque= 1 AND LEFT(CFOP,1) = 6 THEN '2'+RIGHT(CFOP,3)
			WHEN dbo.LkpNota0.Estoque= 1 AND LEFT(CFOP,1) = 7 THEN '3'+RIGHT(CFOP,3)
			WHEN dbo.LkpNota0.Estoque=-1 AND LEFT(CFOP,1) = 1 THEN '5'+RIGHT(CFOP,3)
			WHEN dbo.LkpNota0.Estoque=-1 AND LEFT(CFOP,1) = 2 THEN '6'+RIGHT(CFOP,3)
			WHEN dbo.LkpNota0.Estoque=-1 AND LEFT(CFOP,1) = 3 THEN '7'+RIGHT(CFOP,3)
			ELSE CFOP
		  END CFOP,
          OrigemID, 
          Descricao,           
          CST_IPI,
          BC_IPI, 
          Aliq_IPI, 
          CST_ICMS, 
          Modalidade_ICMS, 
          ReducaoICMS, 
          BC_ICMS, 
          Aliq_ICMS, 
          Modalidade_ICMSSub,
          MVA, 
          BC_ICMSSub, 
          Aliq_ICMSSub, 
          CST_II, 
          BC_II, 
          Aliq_II, 
          CST_ISS,
          BC_ISS, 
          Aliq_ISS, 
          CST_PIS, 
          BC_PIS,
          Aliq_PIS, 
          CST_COFINS, 
          BC_COFINS, 
          Aliq_COFINS,
          Totalizar, 
          Valido    
From COM_ITE_MOV
  JOIN MovNota0 ON COM_ITE_MOV.Chave=dbo.MovNota0.Chave
  Join CadUnid0 Destinatario On Destinatario.UnidadeID  = @DestinoUnidadeID
  Join CadUnid0 Origem On Origem.UnidadeID   = MovNota0.UnidadeID
  Join LkpNota0 On LkpNota0.TipoID   = @DestinoTipoID


Where MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota 
    

--Usuario que execurou a operação 
INSERT INTO MovUser0 (UnidadeID, TipoID, Nota, Data, UsuarioID, Historico)
Select  
  @DestinoUnidadeID, 
  @DestinoTipoID, 
  @Gen_Nota Nota, 
  GETDATE(), 
  @UsuarioID, 
  'Importado do movimento:' + Chave
From  MovNota0
Where MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota 



--Dados referente a operações de frete
insert into CTE_Conhecimento
  (
  UnidadeID, TipoID, Nota, Modelo, Chave, Serie, SubSerie, NUM_DOC, DtEmissao, tpCTe, CHV_CTE_REF, Total, TotalDesconto, TipoFrete, TotalServico, BC_ICMS, ICMS, VL_NT, IND_NAT_FRTID, CST_PIS, NAT_BC_CRED, ALIQ_PIS, BC_PIS, BC_Cofins, ALIQ_Cofins, CST_Cofins, CFOP
  )
select 
  @DestinoUnidadeID, @DestinoTipoID, @Gen_Nota Nota, Modelo, Null Chave, Serie, SubSerie, NUM_DOC, DtEmissao, tpCTe, CHV_CTE_REF, Total, TotalDesconto, TipoFrete, TotalServico, BC_ICMS, ICMS, VL_NT, IND_NAT_FRTID, CST_PIS, NAT_BC_CRED, ALIQ_PIS, BC_PIS, BC_Cofins, ALIQ_Cofins, CST_Cofins, CFOP
from CTE_Conhecimento
 Inner Join MovNota0 ON MovNota0.Chave = CTE_Conhecimento.Chave   
Where MovNota0.UnidadeID = @UnidadeID
  And MovNota0.TipoID    = @TipoID
  And MovNota0.Nota      = @Nota 



SELECT * 
FROM MovNota0
WHERE UnidadeID = @DestinoUnidadeID 
  AND TipoID = @DestinoTipoID
  AND Nota = @Gen_Nota

END

GO
