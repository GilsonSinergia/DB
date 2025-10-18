SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE   PROCEDURE [dbo].[SP_F_PISCOFINS]
  @Bloco CHAR(4) = '9999',
  @UnidadID INT = 3,
  @DtIni DATETIME =  '20170701',
  @DtFin DATETIME =  '20170731'
AS
  
  SELECT 
	  VWS_Unidades.UnidadeID
	Into #UbudadesEnvolvidas  
	From VWS_Unidades
	  JOIN CadUnid0 on CadUnid0.UnidadeID=VWS_Unidades.UnidadeID
	where CadUnid0.Ativa=1
	  AND Substring(VWS_Unidades.Documento, 1,8) in( Select Substring(VWS_Unidades.Documento, 1,8) from VWS_Unidades where UnidadeID=@UnidadID)

  IF @Bloco = '0000'
	Select 
	  VWS_Unidades.NOME,
	  VWS_Unidades.Documento CNPJ,
	  VWS_Unidades.UF,
	  VWS_Unidades.CidadeID COD_MUN,
	  SUFRAMA,
	  IND_NAT_PJ
	From VWS_Unidades LEFT JOIN dbo.FIS_Unidade ON FIS_Unidade.UnidadeID = VWS_Unidades.UnidadeID
where VWS_Unidades.UnidadeID=@UnidadID   

  IF @Bloco = '0100'
		Select 
		  @Bloco Bloco,
		  VWS_Pessoas.nome,
		  case when len(VWS_Pessoas.Documento) = 11 then VWS_Pessoas.Documento else Null end CPF,
		  VWS_Pessoas.CRC_Contabil CRC,		  
		  case when len(VWS_Pessoas.Documento) = 14 then VWS_Pessoas.Documento else Null end CNPJ,
		  VWS_Pessoas.CEP,
		  VWS_Pessoas.Endereco,
		  VWS_Pessoas.Numero,
		  VWS_Pessoas.Complemento,
		  VWS_Pessoas.Bairro,
		  VWS_Pessoas.Tel,
		  VWS_Pessoas.Fax,
		  VWS_Pessoas.EMail,
		  VWS_Pessoas.CidadeID
		from VWS_Pessoas
		  JOIN dbo.UND_PES ON UND_PES.PessoaID = VWS_Pessoas.PessoaID
		where ID=2
		  AND UND_PES.UnidadeID=@UnidadID   
	
  IF @Bloco = '0110'	
	  Select 
		  @Bloco Bloco,
		  COD_INC_TRIB, 
		  IND_APRO_CRED, 
		  COD_TIPO_CONT, 
		  IND_REG_CUM	  
	  from dbo.FIS_Unidade
	  Where UnidadeID=@UnidadID	  

  if @Bloco = '0111'	
  Select 
	  @Bloco Bloco, 
	  REC_BRU_NCUM_TRIB_MI, 
	  REC_BRU_NCUM_NT_MI, 
	  REC_BRU_NCUM_EXP, 
	  REC_BRU_CUM,
	  REC_BRU_NCUM_TRIB_MI + REC_BRU_NCUM_NT_MI + REC_BRU_NCUM_EXP + REC_BRU_CUM REC_BRU_TOTAL
  from FIS_Unidade
  Where UnidadeID=@UnidadID	  
  
  if @Bloco = '0140'	
  Select 
    @Bloco Bloco, 
    VWS_Unidades.UnidadeID, 
    @Bloco Bloco, 
    VWS_Unidades.NOME,
	VWS_Unidades.Documento CNPJ,
	VWS_Unidades.UF,
	VWS_Unidades.Inscricao IE,
	VWS_Unidades.CidadeID COD_MUN,	  
	VWS_Unidades.SUFRAMA
	From VWS_Unidades
	  JOIN #UbudadesEnvolvidas on #UbudadesEnvolvidas.UnidadeID=VWS_Unidades.UnidadeID
	
  if @Bloco = '0150' begin   
    Select CadPess0.PessoaID
    Into #Movimentos
    From CadPess0
    JOIn MovNota0 on MovNota0.PessoaID=CadPess0.PessoaID
	   JOIN MovFisc0
		ON MovNota0.UnidadeID=MovFisc0.UnidadeID
	   AND MovNota0.TipoID=MovFisc0.TipoID
	   AND MovNota0.Nota=MovFisc0.Nota 
	    JOIN LkpNota0
		ON LkpNota0.TipoID=MovNota0.TipoID  
	  JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID     
	 Where MovNota0.StatusID in (2,3)
	  AND (MovNota0.StatusID = 2 OR LkpNota0.Estoque=-1)
	  AND MovNota0.DtMovimento  between @DtIni AND @DtFin  
	  AND MovNota0.UnidadeID = @UnidadID     
	Group BY CadPess0.PessoaID
	Union
	Select CadPess0.PessoaID
    From CadPess0
    JOIn MovNota0 on MovNota0.PessoaID=CadPess0.PessoaID
	   JOIN CTE_Conhecimento
		ON MovNota0.UnidadeID=CTE_Conhecimento.UnidadeID
	   AND MovNota0.TipoID=CTE_Conhecimento.TipoID
	   AND MovNota0.Nota=CTE_Conhecimento.Nota 
	    JOIN LkpNota0
		ON LkpNota0.TipoID=MovNota0.TipoID  
	 Where MovNota0.StatusID in (2,3)
	  AND MovNota0.DtMovimento  between @DtIni AND @DtFin  
	  AND MovNota0.UnidadeID = @UnidadID     
	Group BY CadPess0.PessoaID
	
	SELECT  
		@Bloco Bloco,
		VWS_Pessoas.PessoaID,
		VWS_Pessoas.Nome,
		VWS_Pessoas.PaisID,
		CASE WHEN LEN(VWS_Pessoas.Documento) = 11 THEN VWS_Pessoas.Documento ELSE NULL END CPF,
		CASE WHEN LEN(VWS_Pessoas.Documento) = 14 THEN VWS_Pessoas.Documento ELSE NULL END CNPJ,
		VWS_Pessoas.Inscricao,
		VWS_Pessoas.CidadeID,
		VWS_Pessoas.Endereco,
		VWS_Pessoas.Numero,
		VWS_Pessoas.Complemento,
		VWS_Pessoas.Bairro
	FROM VWS_Pessoas
	   JOIN #Movimentos ON #Movimentos.PessoaID=VWS_Pessoas.PessoaID
	END	
    		 	
	if @Bloco = '0190'
	Select  
		@Bloco Bloco,
		COM_ITE_MED.MedidaID,
		COM_ITE_MED.Medida
	from COM_ITE_MOV
		JOIN dbo.COM_ITE_MED ON COM_ITE_MED.MedidaID = COM_ITE_MOV.MedidaID	
		JOIn MovNota0 
		ON MovNota0.UnidadeID=COM_ITE_MOV.UnidadeID
		AND MovNota0.TipoID=COM_ITE_MOV.TipoID
		AND MovNota0.Nota=COM_ITE_MOV.Nota 
		JOIN MovFisc0
		ON MovNota0.UnidadeID=MovFisc0.UnidadeID
		AND MovNota0.TipoID=MovFisc0.TipoID
		AND MovNota0.Nota=MovFisc0.Nota 
		JOIN LkpNota0
		ON LkpNota0.TipoID=MovNota0.TipoID  
		JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID     
		Where MovNota0.StatusID in (2,3)
		AND (MovNota0.StatusID = 2 OR LkpNota0.Estoque=-1)
		AND MovNota0.DtMovimento  between @DtIni AND @DtFin  
		AND MovNota0.UnidadeID = @UnidadID  
	Group by 
		COM_ITE_MED.MedidaID,
		COM_ITE_MED.Medida
				
	if @Bloco = '0200'
	Select  
		@Bloco Bloco,
		COM_ITE_MOV.ItemID,
		COM_ITE_CAD.Item,
		COM_ITE_Referencia.Referencia Barras,
		COM_ITE_PRD.MedidaID,
		COM_ITE_UND.OrigemID,
		COM_ITE_CAD.NCM,
		SUBSTRING(COM_ITE_CAD.NCM, 1,2)COD_GEN,
		COM_ITE_CAD.CEST,
		VWS_Unidades.ICMSInt
	from COM_ITE_MOV
	  JOIN MovNota0 
	    ON MovNota0.Chave = COM_ITE_MOV.Chave
	  JOIN COM_ITE_CAD 
	    ON COM_ITE_CAD.ItemID = COM_ITE_MOV.ItemID 	
	  JOIN COM_ITE_PRD 
	    ON COM_ITE_PRD.ItemID = COM_ITE_MOV.ItemID 	  
	  JOIN COM_ITE_UND 
	    ON COM_ITE_UND.UnidadeID = COM_ITE_MOV.UnidadeID 	    
	   AND COM_ITE_UND.ItemID = COM_ITE_MOV.ItemID 	     
	  LEFT JOIN COM_ITE_Referencia 
	    ON COM_ITE_Referencia.ItemID = COM_ITE_MOV.ItemID
	   AND COM_ITE_Referencia.ReferenciaID=0  	  
      JOIN VWS_Unidades on VWS_Unidades.UnidadeID=MovNota0.UnidadeID
    Where MovNota0.UnidadeID = @UnidadID
       AND  MovNota0.DtMovimento between @DtIni AND @DtFin  
    Group by 
       COM_ITE_MOV.ItemID,
       COM_ITE_CAD.Item,
       COM_ITE_Referencia.Referencia,
       COM_ITE_PRD.MedidaID,
       COM_ITE_UND.OrigemID,
       COM_ITE_CAD.NCM,
       COM_ITE_CAD.CEST,
       VWS_Unidades.ICMSInt

       		
	if @Bloco = '0400'
	Select  
		@Bloco Bloco,
		LkpNota0.TipoID,
		LkpNota0.Tipo
	from MovFisc0
	  JOIN MovNota0 
	    ON MovNota0.UnidadeID = MovFisc0.UnidadeID
	   AND MovNota0.TipoID = MovFisc0.TipoID
	   AND MovNota0.Nota = MovFisc0.Nota
	 JOIN LkpNota0 
	    ON  LkpNota0.TipoID = MovFisc0.TipoID
  	 Where MovNota0.StatusID in (2,3)
	  AND (MovNota0.StatusID = 2 OR LkpNota0.Estoque=-1)
	  AND MovNota0.DtMovimento  between @DtIni AND @DtFin  
	  AND MovNota0.UnidadeID = @UnidadID  
    Group BY 
    LkpNota0.TipoID,
		LkpNota0.Tipo

	if @Bloco = '0450'	OR @Bloco = 'A100' OR @Bloco = 'C100'
	--Registro 0450 MSG De NF
	Select  		
		RANK() over(order by MovNota0.OBS)OBS_ID,
		checksum(MovNota0.OBS)CS,
		MovNota0.OBS
	Into #0450	
	from MovFisc0
	  JOIN MovNota0 
	    ON MovNota0.UnidadeID = MovFisc0.UnidadeID
	   AND MovNota0.TipoID = MovFisc0.TipoID
	   AND MovNota0.Nota = MovFisc0.Nota
	 JOIN LkpNota0 
	    ON  LkpNota0.TipoID = MovFisc0.TipoID
   Where MovNota0.UnidadeID = @UnidadID
      AND MovNota0.DtMovimento between @DtIni AND @DtFin 
      AND MovNota0.OBS	 is not null
    Group by MovNota0.OBS	
    	
	if @Bloco = '0450'
	Select 
	  @Bloco Bloco,
	  OBS_ID,
	  OBS
	From #0450  
			
	if @Bloco = '0500'
	Select  
		@Bloco Bloco,
		FIS_CFO_CTB_Conta.Data DT_ALT,
		FIS_CFO_CTB_Conta.NaturezaID COD_NAT_CC,
		FIS_CFO_CTB_Conta.TipoID IND_CTA,
		FIS_CFO_CTB_Conta.Nivel,
		FIS_CFO_CTB_Conta.Codigo COD_CTA,
		FIS_CFO_CTB_Conta.Conta Nome_CTA
	from COM_ITE_MOV
	  JOIN MovNota0 
	    ON MovNota0.UnidadeID = COM_ITE_MOV.UnidadeID
	   AND MovNota0.TipoID = COM_ITE_MOV.TipoID
	   AND MovNota0.Nota = COM_ITE_MOV.Nota
	  JOIN FIS_CFO_CTB_Conta  ON FIS_CFO_CTB_Conta.CFOP=COM_ITE_MOV.CFOP
    Where MovNota0.UnidadeID = @UnidadID
      AND MovNota0.DtMovimento between @DtIni AND @DtFin  
 Group by 
        FIS_CFO_CTB_Conta.Data,
		FIS_CFO_CTB_Conta.NaturezaID,
		FIS_CFO_CTB_Conta.TipoID,
		FIS_CFO_CTB_Conta.Nivel,
		FIS_CFO_CTB_Conta.Codigo,
		FIS_CFO_CTB_Conta.Conta         
  Union     
  Select  
		@Bloco Bloco,
		FIS_CFO_CTB_Conta.Data DT_ALT,
		FIS_CFO_CTB_Conta.NaturezaID COD_NAT_CC,
		FIS_CFO_CTB_Conta.TipoID IND_CTA,
		FIS_CFO_CTB_Conta.Nivel,
		FIS_CFO_CTB_Conta.Codigo COD_CTA,
		FIS_CFO_CTB_Conta.Conta Nome_CTA
	from CTE_Conhecimento
	  JOIN MovNota0 
	    ON MovNota0.UnidadeID = CTE_Conhecimento.UnidadeID
	   AND MovNota0.TipoID = CTE_Conhecimento.TipoID
	   AND MovNota0.Nota = CTE_Conhecimento.Nota
	  left JOIN FIS_CFO_CTB_Conta  ON FIS_CFO_CTB_Conta.CFOP=CTE_Conhecimento.CFOP
    Where MovNota0.UnidadeID = @UnidadID
      AND MovNota0.DtMovimento between @DtIni AND @DtFin  
 Group by 
        FIS_CFO_CTB_Conta.Data,
		FIS_CFO_CTB_Conta.NaturezaID,
		FIS_CFO_CTB_Conta.TipoID,
		FIS_CFO_CTB_Conta.Nivel,
		FIS_CFO_CTB_Conta.Codigo,
		FIS_CFO_CTB_Conta.Conta   
	
	--Bloco A
	if @Bloco = 'A100'
	Select 
	  @Bloco Bloco,  		
	  #UbudadesEnvolvidas.UnidadeID,
	  MovNota0.Chave,
	  Case when LkpNota0.Estoque = 1 then 0 else 1 end IND_OPER,
	  Case when MovFisc0.NFPropria = 1 then 0 else 1 end IND_EMIT,
	  MovNota0.PessoaID,
	  Case when MovNota0.StatusID=2 then 0 else 2 end COD_SIT,
	  MovFisc0.Serie,
	  MovFisc0.NF,
	  DFe_MOV.ID,
	  MovFisc0.DtEmissao,
	  MovNota0.DtMovimento,
	  MovFisc0.modFrete,
	  #0450.OBS_ID,
	  T.VL_NF,
	  T.VL_Desconto,
	  T.BC_PIS,
	  T.Vl_PIS,
	  T.BC_COFINS,
	  T.Vl_COFINS
	FROM MovFisc0
	 JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovFisc0.Chave 
	 JOIN MovNota0 ON  MovNota0.Chave = MovFisc0.Chave	    
	 JOIN LkpNota0 ON  LkpNota0.TipoID = MovFisc0.TipoID
	 JOIN #UbudadesEnvolvidas on #UbudadesEnvolvidas.UnidadeID=MovNota0.UnidadeID   
	 JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID
	 LEFT JOIN dbo.DFe_MOV ON DFe_MOV.Chave = MovFisc0.Chave
	 LEFT JOIN #0450 ON #0450.CS=checksum(MovNota0.OBS) 
    Where MovNota0.UnidadeID = @UnidadID
      AND MovNota0.DtMovimento between @DtIni AND @DtFin 
      AND TRY_CONVERT(INT, LkpFisc0.Sigla) IN (00)
	  AND MovNota0.StatusID=2

    if @Bloco = 'A170'
	Select	 
	  @Bloco Bloco, 
	  MovNota0.Chave,
	  COM_ITE_MOV.Seq,
	  COM_ITE_MOV.ItemID,
	  COM_ITE_MOV.Descricao,
	  COM_ITE_MOV.VL_Item,
	  COM_ITE_MOV.VL_Desconto,
	 	  	  
	  COM_ITE_MOV.CST_PIS,
	  COM_ITE_MOV.BC_PIS,
	  COM_ITE_MOV.ALIQ_PIS,
	  COM_ITE_MOV.Vl_PIS, 	  
	  
	  COM_ITE_MOV.CST_COFINS,
	  COM_ITE_MOV.BC_COFINS,
	  COM_ITE_MOV.Aliq_COFINS,
	  COM_ITE_MOV.Vl_COFINS, 	 
	  FIS_CFO_CTB_Conta.Codigo COD_CTA
	From MovNota0
	  JOIN COM_ITE_MOV ON COM_ITE_MOV.Chave = MovNota0.Chave	   
	  JOIN COM_ITE_CAD ON COM_ITE_CAD.ItemID = COM_ITE_MOV.ItemID
	  JOIN MovFisc0	On MovFisc0.Chave = MovNota0.Chave
	  JOIN dbo.COM_ITE_MED	On COM_ITE_MED.MedidaID= COM_ITE_MOV.MedidaID
	  JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID  
	  LEFT JOIN FIS_CFO_CTB_Conta on FIS_CFO_CTB_Conta.CFOP=COM_ITE_MOV.CFOP
	Where MovNota0.UnidadeID    = @UnidadID
	  And MovNota0.DtMovimento >= @DTINI
	  And MovNota0.DtMovimento <= @DTFIN
	  And MovNota0.StatusID =2
	  And MovFisc0.ModeloID in (0)
	  AND COM_ITE_MOV.Quantidade> 0	  
	
	--Bloco C
    
    if @Bloco = 'C100'
	Select 
	  @Bloco Bloco,  		
	  #UbudadesEnvolvidas.UnidadeID,
	  MovNota0.Chave,
	  Case when LkpNota0.Estoque = 1 then 0 else 1 end IND_OPER,
	  Case when MovFisc0.NFPropria = 1 then 0 else 1 end IND_EMIT,
	  MovNota0.PessoaID,
	  LkpFisc0.Sigla COD_MOD,
	  Case when MovNota0.StatusID=2 then 0 else 2 end COD_SIT,
	  MovFisc0.Serie,
	  MovFisc0.NF NUM_DOC,
	  DFe_MOV.ID,
	  MovFisc0.DtEmissao,
	  MovNota0.DtMovimento,
	  2 IND_PGTO,	  
	  MovFisc0.modFrete,
	  T.VL_Item,
	  T.VL_Desconto,
	  T.VL_Liquido,	  
	  T.VL_Frete,
	  T.VL_Seguro,
	  T.VL_Outro,	  
	  T.BC_ICMS,
	  T.Vl_ICMS,
	  T.BC_ICMSSub,
	  T.BC_ICMSSub,
	  T.Vl_ICMSSUB,
	  T.Vl_IPI,
	  T.Vl_PIS,
	  T.Vl_COFINS,
	  T.VL_NF,
	  #0450.OBS_ID
	from MovFisc0
	 JOIN MovNota0 ON  MovNota0.Chave = MovFisc0.Chave	    
	 JOIN dbo.VWS_Movimento_Totais T ON T.Chave = MovFisc0.Chave
	 JOIN LkpNota0 ON  LkpNota0.TipoID = MovFisc0.TipoID
	 JOIN #UbudadesEnvolvidas on #UbudadesEnvolvidas.UnidadeID=MovNota0.UnidadeID   
	 JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID
	 LEFT JOIN dbo.DFe_MOV ON DFe_MOV.Chave = MovFisc0.Chave
	 LEFT JOIN #0450 ON #0450.CS=checksum(MovNota0.OBS) 
    Where MovNota0.UnidadeID = @UnidadID
      AND MovNota0.DtMovimento between @DtIni AND @DtFin 
      AND TRY_CONVERT(INT, LkpFisc0.Sigla) IN (01, 55, 65)
	  AND (MovNota0.StatusID=2 )
	        
	if @Bloco = 'C170'
	Select	 
	  @Bloco Bloco, 
	  MovNota0.Chave,
	  COM_ITE_MOV.Seq,
	  COM_ITE_MOV.ItemID,
	  COM_ITE_MOV.Descricao,
	  COM_ITE_MOV.Quantidade,
	  COM_ITE_MOV.MedidaID,
	  COM_ITE_MOV.VL_Item,
	  COM_ITE_MOV.VL_Desconto,
	  COM_ITE_MOV.Totalizar,
	  COM_ITE_MOV.CST_ICMS,
	  COM_ITE_MOV.CFOP,
	  COM_ITE_MOV.TipoID,
	  
	  COM_ITE_MOV.BC_ICMS,
	  COM_ITE_MOV.Aliq_ICMS,
	  COM_ITE_MOV.Vl_ICMS,
	  
	  COM_ITE_MOV.BC_ICMSSub,
	  COM_ITE_MOV.Aliq_ICMSSub,
	  COM_ITE_MOV.Vl_ICMSSUB,
	  
	  COM_ITE_MOV.CST_IPI,
	  COM_ITE_MOV.BC_IPI,
	  COM_ITE_MOV.Aliq_IPI,
	  COM_ITE_MOV.Vl_IPI,
	  
	  COM_ITE_MOV.CST_PIS,
	  COM_ITE_MOV.BC_PIS,
	  COM_ITE_MOV.ALIQ_PIS,
	  COM_ITE_MOV.Vl_PIS, 
	  
	  COM_ITE_MOV.CST_COFINS,
	  COM_ITE_MOV.BC_COFINS,
	  COM_ITE_MOV.Aliq_COFINS,
	  COM_ITE_MOV.Vl_COFINS, 
	  
	  COM_ITE_MOV.ReducaoICMS,
	  COM_ITE_MOV.VL_Liquido,
	  COM_ITE_MOV.VL_Frete,
	  COM_ITE_MOV.VL_Seguro,
	  COM_ITE_MOV.VL_Outro,
	  Com_ite_Cad.NCM,
	  COM_ITE_MOV.VL_Liquido
	  + COM_ITE_MOV.VL_Frete
	  + COM_ITE_MOV.VL_Seguro
	  + COM_ITE_MOV.VL_Outro
	  + COM_ITE_MOV.Vl_IPI
	  + COM_ITE_MOV.Vl_ICMSSUB VL_Total,
	  FIS_CFO_CTB_Conta.Codigo COD_CTA
	From MovNota0
	  JOIN dbo.COM_ITE_MOV ON COM_ITE_MOV.Chave = MovNota0.Chave		
	  JOIN COM_ITE_CAD
		On COM_ITE_CAD.ItemID = COM_ITE_MOV.ItemID
	  JOIN MovFisc0
		On MovFisc0.UnidadeID = MovNota0.UnidadeID
	   And MovFisc0.TipoID    = MovNota0.TipoID
	   And MovFisc0.Nota      = MovNota0.Nota
	  JOIN dbo.COM_ITE_MED
		On COM_ITE_MED.MedidaID= COM_ITE_MOV.MedidaID
	  JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID  
	  LEFT JOIN FIS_CFO_CTB_Conta on FIS_CFO_CTB_Conta.CFOP=COM_ITE_MOV.CFOP
	Where MovNota0.UnidadeID    = @UnidadID
	  And MovNota0.DtMovimento >= @DTINI
	  And MovNota0.DtMovimento <= @DTFIN
	  And MovNota0.StatusID =2
	  And MovFisc0.ModeloID in (1,3)
	  AND COM_ITE_MOV.Quantidade> 0
	  	
	if @Bloco = 'C175'
	Select
	  @Bloco Bloco, 
	  MovNota0.Chave,
	  COM_ITE_MOV.CFOP,
	  Sum(COM_ITE_MOV.VL_Liquido
	  + COM_ITE_MOV.VL_Frete
	  + COM_ITE_MOV.VL_Seguro
	  + COM_ITE_MOV.VL_Outro
	  + COM_ITE_MOV.Vl_IPI
	  + COM_ITE_MOV.Vl_ICMSSUB) VL_OPR,
	  Sum(COM_ITE_MOV.VL_Desconto) VL_DESC,
	  
	  COM_ITE_MOV.CST_PIS,
	  Sum(COM_ITE_MOV.BC_PIS) VL_BC_PIS,
	  COM_ITE_MOV.ALIQ_PIS ALIQ_PIS_PERC,
	  Sum(COM_ITE_MOV.Vl_PIS) VL_PIS,
	  
	  COM_ITE_MOV.CST_Cofins,
	  Sum(COM_ITE_MOV.BC_Cofins) VL_BC_Cofins,
	  COM_ITE_MOV.Aliq_Cofins ALIQ_Cofins_PERC,
	  Sum(COM_ITE_MOV.Vl_Cofins) VL_Cofins,
	  FIS_CFO_CTB_Conta.Codigo COD_CTA
	From MovNota0
	  JOIN COM_ITE_MOV
		On COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
	   And COM_ITE_MOV.TipoID    = MovNota0.TipoID
	   And COM_ITE_MOV.Nota      = MovNota0.Nota
	  JOIN Com_ite_Cad
		On Com_ite_Cad.ItemID = COM_ITE_MOV.ItemID
	  JOIN MovFisc0
		On MovFisc0.UnidadeID = MovNota0.UnidadeID
	   And MovFisc0.TipoID    = MovNota0.TipoID
	   And MovFisc0.Nota      = MovNota0.Nota
	  JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID  
	  LEFT JOIN FIS_CFO_CTB_Conta on FIS_CFO_CTB_Conta.CFOP=COM_ITE_MOV.CFOP 
	Where MovNota0.UnidadeID    = @UnidadID
	  And MovNota0.DtMovimento >= @DTINI
	  And MovNota0.DtMovimento <= @DTFIN
	  And (StatusID =2)
	  And MovFisc0.ModeloID  in (4)
	Group by 
	  MovNota0.Chave,
	  COM_ITE_MOV.CFOP,
	  COM_ITE_MOV.CST_PIS,
	  COM_ITE_MOV.ALIQ_PIS,
	  COM_ITE_MOV.CST_Cofins,
	  COM_ITE_MOV.Aliq_Cofins,
	  FIS_CFO_CTB_Conta.Codigo

	if @Bloco = 'C180'
	Select
	  @Bloco Bloco,
	  LkpFisc0.Sigla, 
	  @DtIni DT_DOC_INI,
	  @DtFin DT_DOC_FIN,
	  COM_ITE_MOV.ItemID COD_ITEM,
	  Com_ite_Cad.NCM COD_NCM,
	  Sum(COM_ITE_MOV.VL_Liquido
	  + COM_ITE_MOV.VL_Frete
	  + COM_ITE_MOV.VL_Seguro
	  + COM_ITE_MOV.VL_Outro
	  + COM_ITE_MOV.Vl_IPI
	  + COM_ITE_MOV.Vl_ICMSSUB) VL_TOT_ITEM,
	  FIS_CFO_CTB_Conta.Codigo COD_CTB
	From MovNota0
	  JOIN COM_ITE_MOV
		On COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
	   And COM_ITE_MOV.TipoID    = MovNota0.TipoID
	   And COM_ITE_MOV.Nota      = MovNota0.Nota
	  JOIN Com_ite_Cad
		On Com_ite_Cad.ItemID = COM_ITE_MOV.ItemID
	  JOIN MovFisc0
		On MovFisc0.UnidadeID = MovNota0.UnidadeID
	   And MovFisc0.TipoID    = MovNota0.TipoID
	   And MovFisc0.Nota      = MovNota0.Nota
	  JOIN LkpFisc0 on LkpFisc0.ModeloID=MovFisc0.ModeloID  
	  LEFT JOIN FIS_CFO_CTB_Conta on FIS_CFO_CTB_Conta.CFOP=COM_ITE_MOV.CFOP
	Where MovNota0.UnidadeID    = @UnidadID
	  And MovNota0.DtMovimento >= @DTINI
	  And MovNota0.DtMovimento <= @DTFIN
	  And (StatusID =2)
	  AND MovFisc0.NFPropria=1
	  AND MovNota0.TipoID in(7,8,9,10)
	Group by 
	LkpFisc0.Sigla, 
	  COM_ITE_MOV.ItemID,
	  Com_ite_Cad.NCM,
	  FIS_CFO_CTB_Conta.Codigo
	  
	if @Bloco = 'D100'  
	Select 
	  @Bloco Bloco, 
	  MovNota0.Chave,
      0 IND_OPER,
      1 IND_EMIT,
	  MovNota0.PessoaID COD_PART, 
	  57 COD_MOD,
	  0 COD_SIT,
	  Cte_Conhecimento.Serie SER, 
	  Cte_Conhecimento.NUM_DOC, 
	  Cte_Conhecimento.DtEmissao DT_DOC, 
	  MovNota0.DtMovimento  DT_A_P,
	  Cte_Conhecimento.Chave CHV_CTE, 
	  case when Cte_Conhecimento.Modelo =57 then Cte_Conhecimento.tpCTe else  Null end Tipo_Cte,  
	  Cte_Conhecimento.Total VL_DOC,
	  Cte_Conhecimento.TotalDesconto VL_DESC,
	  Cte_Conhecimento.tpCTe IND_FRT,
	  Cte_Conhecimento.TotalServico VL_SERV,
	  Cte_Conhecimento.BC_ICMS,
	  Cte_Conhecimento.ICMS Aliq_Icms,
	  Cte_Conhecimento.BC_ICMS * Cte_Conhecimento.ICMS / 100 VL_ICMS,	  
	  Cte_Conhecimento.VL_NT,
	  CTE_Conhecimento.NAT_BC_CRED,
	  
	  --Dados D101
	  CTE_Conhecimento.CST_PIS,
	  CTE_Conhecimento.BC_PIS,
	  CTE_Conhecimento.ALIQ_PIS,
	  
	  --Dados D105
	  CTE_Conhecimento.CST_Cofins,
	  CTE_Conhecimento.BC_Cofins,
	  CTE_Conhecimento.ALIQ_Cofins,
	  FIS_CFO_CTB_Conta.Codigo COD_CTA
	From MovNota0
	 JOIn CTE_Conhecimento
	  ON Cte_Conhecimento.UnidadeID = MovNota0.UnidadeID
	 AND Cte_Conhecimento.TipoID    = MovNota0.TipoID
	 AND Cte_Conhecimento.Nota      = MovNota0.Nota
	 LEFT JOIN FIS_CFO_CTB_Conta on FIS_CFO_CTB_Conta.CFOP=CTE_Conhecimento.CFOP
	Where MovNota0.TipoID   = 19
	 and MovNota0.UnidadeID = @UnidadID
	 and DtMovimento >= @DtIni
	 and DtMovimento <= @DtFin
	 and MovNota0.StatusID = 2  
			  	 
	IF @Bloco = 'M210' 
	SELECT 
	  @Bloco Bloco,  
	  COM_ITE_MOV.CST_PIS,
	  COM_ITE_MOV.Aliq_PIS,
	  COM_ITE_MOV.Aliq_COFINS,
	  SUM(COM_ITE_MOV.BC_PIS)BC,
	  SUM(COM_ITE_MOV.Vl_PIS)VL_PIS,
	  SUM(COM_ITE_MOV.Vl_COFINS)VLCOFINS  	 
	 FROM MovNota0
	 JOIN COM_ITE_MOV
		ON COM_ITE_MOV.UnidadeID = MovNota0.UnidadeID
	   AND COM_ITE_MOV.TipoID    = MovNota0.TipoID
	   AND COM_ITE_MOV.Nota      = MovNota0.Nota
	 JOIN MovFisc0
		ON MovFisc0.UnidadeID = MovNota0.UnidadeID
	   AND MovFisc0.TipoID    = MovNota0.TipoID
	   AND MovFisc0.Nota      = MovNota0.Nota 
	 WHERE MovNota0.UnidadeID    = @UnidadID
	  AND MovNota0.DtMovimento >= @DTINI
	  AND MovNota0.DtMovimento <= @DTFIN
	  AND (StatusID =2)
	  AND MovFisc0.ModeloID NOT IN (0,4)
	 GROUP BY
	   COM_ITE_MOV.CST_PIS,
	  COM_ITE_MOV.Aliq_PIS,
	  COM_ITE_MOV.Aliq_COFINS
	

	IF @Bloco = '9999'
	SELECT 
	  @Bloco Bloco,  		
	  VWS_Unidades.Documento CNPJ,
	  2 IND_ESCRI
	 FROM #UbudadesEnvolvidas 
	   JOIN VWS_Unidades ON VWS_Unidades.UnidadeID = #UbudadesEnvolvidas.UnidadeID







GO
