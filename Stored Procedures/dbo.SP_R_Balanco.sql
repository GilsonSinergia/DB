SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE          Procedure [dbo].[SP_R_Balanco]
  @UnidadeID Int =8,
  @Data DateTime ='20211001',
  @Resumo Bit = 0,
  @ValorInformado float = 0,
  @Index int = 1
AS

--Procedure personalizada favor não alterar
If @Index =0
  Select 1
else  begin  
    Update COM_ITE_MOV set Comissao=1
	from COM_ITE_MOV I JOIN MovNota0 M on M.Chave=I.Chave
	where Comissao=0 and M.StatusID=2 and M.TipoID in (7, 8, 9, 10, 13)

	SET LANGUAGE [Português (Brasil)]

	Declare
		@Chave Char(14) = NULL,
		@Chave2 Char(14) = NULL,--'03010000009869', 03090000004686,
		@Chave3 Char(14) = NULL,--'03010000009869', 03090000004686,
		@BlocoID Int,
		@Bloco VarChar(20),
		@BlocoIni int,
		@BlocoFin int,
		@DtIni Date,
		@CreditoPisID int = 71,
		@CreditoCOFINSID int = 72,
		@CreditoIPIID int = 0,
		@CreditoICMSID int = 0,
		@GradeOrcamentariaDespesas Varchar(10)='1.2.2%' 

	Select @DtIni = @Data - DAY(@Data)+1 

	if @ValorInformado <> 0 begin
  		Delete from USR_FIN_Resultado
		Insert into USR_FIN_Resultado
		Values (@UnidadeID , @ValorInformado, GETDATE() )	
	END
  
	Create Table #T
		(
		BlocoID Int Not Null,
		Bloco VarChar(20)Not Null, 
		ID Int IDENTITY(1,1), 
		Historico VarChar(2550) Not Null,
		Valor Float  Null,
		ValorCupom float null,
		Soma Bit default 0
		)
    
	 Select * Into #CadUnid0 
	 from CadUnid0 
	 where Ativa=1 
	   AND(@UnidadeID IS NULL OR  POWER(2, UnidadeID) & @UnidadeID <>0)
   
   Select @BlocoID=0
	--Saldo em caixa  e em bancos  
	Begin
		Select @BlocoID=@BlocoID+1, @Bloco='Disponibilidades'
		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		
		Select 
			@BlocoID, 
			@Bloco, 
			LkpCont0.Tipo, 
			SUM(Conciliado)  * IIF(@Chave is NULL, 1, 0)
		from  dbo.fn_SaldoContas(@Data) Saldo
			JOIN CadCont0  on CadCont0.ContaID=Saldo.ContaID
			JOIN LkpCont0 on LkpCont0.TipoID=CadCont0.TipoID
			JOIN UnidCont0 On UnidCont0.ContaID = CadCont0.ContaID
			JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=UnidCont0.UnidadeID
		Group BY LkpCont0.Tipo
			     

		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
		from #T 
		group by Bloco 
	end

	--Valores baixados em cheques cartões e outros
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='Recebimentos a Conciliar...'
  
		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select 
		  @BlocoID, @Bloco, lkpMoed0.Tipo,SUM( MovFina2.Valor) *  IIF(@Chave is NULL, 1, 0)
		  From MovFina2
			JOIN CadMoed0 on CadMoed0.MoedaID=MovFina2.MoedaID
			JOIN lkpMoed0 ON lkpMoed0.TipoID=CadMoed0.TipoID
			JOIN UnidCont0 On UnidCont0.ContaID=MovFina2.ContaID
			JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=UnidCont0.UnidadeID
		  where CadMoed0.TipoID>=1 
			AND OperacaoID=1
			AND StatusID<=2
		  Group BY CadMoed0.TipoID, lkpMoed0.Tipo
    
		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		group by Bloco 
		having COUNT(*) >1
	end

	--Contas a receber
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='Contas a Receber' 
   
		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		  select 
			@BlocoID, @Bloco,
			CadDocu0.Documento,
			IsNull(SUM(Parcela.Aberto),0)Valor
		  from CadDocu0 
			 JOIN MovFina0  ON CadDocu0.DocumentoID=MovFina0.DocumentoID
			 JOIN MovNota0 ON MovNota0.Chave = MovFina0.Chave
			 JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovNota0.UnidadeID
			 JOIN FN_Staus_Parcela(1, Null, 1 , @Data )Parcela ON Parcela.ChaveTitulo = MovFina0.ChaveTitulo
		Where Convert(Decimal(18,2),Aberto) > 0   
		  AND MovNota0.StatusID in(2)  
		  AND MovFina0.DtEmissao <=  @Data
		  AND (@Chave IS NULL OR MovNota0.Chave=@Chave OR MovNota0.Chave=@Chave2 OR MovNota0.Chave=@Chave3)
		group by CadDocu0.Documento
	
	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	  AND Soma=0
	group by BlocoID, BlocoID 
	having COUNT(*) >1
	end
   
	-- Estoque
	Begin		
	Declare @MovimentosEstoque Table  
	(
	ID Int,
	Descricao Varchar(30),
	Estoque Int,
	Valor Money
	);	
	With CTE as (
	  Select 1 ID, 'IPI' Descricao Union
	  Select 2 ID, 'ICMS' Union
	  Select 3 ID, 'PIS' Union
	  Select 4 ID, 'COFINS'Union
	  Select 5 ID, 'Comissao'
	)	
	Insert into @MovimentosEstoque
	Select 	 
	    CTE.ID,
		CTE.Descricao,
		Estoque,
		SUM(Case CTE.ID
				When 1  then T.Vl_IPI 
				When 2  then T.Vl_ICMS
				When 3  then T.Vl_PIS 
				When 4 then  T.Vl_COFINS 
				When 5 then  T.VL_Comissao 
				else 0.00
			End)Valor
	from MovNota0 M	  
	  CROSS JOIN CTE 
	  JOIN #CadUnid0 U on U.UnidadeID=M.UnidadeID
	  JOIN LkpNota0 ON LkpNota0.TipoID=M.TipoID
	  JOIN VWS_Movimento_Totais T ON T.Chave=M.Chave
	Where LkpNota0.Estoque <> 0
	  AND M.StatusID=2
	  AND M.DtMovimento between @DtIni AND @Data
	  AND (@Chave IS NULL OR M.Chave=@Chave OR M.Chave=@Chave2)
	Group BY CTE.ID, CTE.Descricao, Estoque
	Union ALL
	Select
		CTE.ID,
		CTE.Descricao,
		Estoque,
		SUM(Case CTE.ID	
				When 3  then C.BC_PIS * C.ALIQ_PIS / 100
				When 4 then  C.BC_Cofins * C.ALIQ_Cofins / 100 
				else 0.00
			End)Valor
	from CTE_Conhecimento C
	  JOIN MovNota0 M
		 ON M.UnidadeID=C.UnidadeID
		AND M.TipoID=C.TipoID
		AND M.Nota=C.Nota
		CROSS JOIN CTE 
	  JOIN #CadUnid0 U on U.UnidadeID=M.UnidadeID
	  JOIN LkpNota0 ON LkpNota0.TipoID=M.TipoID
	Where LkpNota0.Estoque <> 0
	  AND M.StatusID=2
	  AND M.DtMovimento between @DtIni AND @Data
	  AND (@Chave IS NULL OR M.Chave=@Chave OR M.Chave=@Chave2)
	Group BY CTE.ID, CTE.Descricao, Estoque
	Union ALL
	Select  
	    CTE.ID,
		CTE.Descricao + ' - Outros',
		1 Estoque,
	  Sum(F.Total * O.Rateio / 100 )
	from Financeiro F
	  JOIN #CadUnid0 U on U.UnidadeID=F.UnidadeID
	  JOIN MovNota0 M
		 ON M.Chave=F.Chave
	  JOIN MovOrca0 O ON O.Chave=M.Chave
	  JOIN CTE ON CTE.ID = case O.OrcamentoID When @CreditoPisID then 3  when @CreditoCOFINSID then 4 else -1 end 
	Where M.TipoID=3
		  AND M.StatusID=2
		  AND M.DtMovimento between @DtIni AND @Data
		  AND (@Chave IS NULL OR M.Chave=@Chave OR M.Chave=@Chave2)
		  AND OrcamentoID in (@CreditoPisID, @CreditoCOFINSID)
	Group by 
	  OrcamentoID,
	   CTE.ID,
	   CTE.Descricao
	 

	Select @BlocoID=@BlocoID+1, @Bloco='Estoque Custo Médio'

	Insert Into #T (BlocoID,Bloco, Historico, Valor)
	Select 
		@BlocoID, 
		@Bloco, 
		'Saldo Anterior',
		Sum(Estoque.Contabil * COM_ITE_PRC.Valor ) * IIF(@Chave is NULL, 1, 0) Valor 
	from fns_Estoque (@Data, NULL) Estoque
		JOIN #CadUnid0 CadUnid0 ON CadUnid0.UnidadeID=Estoque.UnidadeID
		JOIN COM_ITE_PRC 
			on COM_ITE_PRC.UnidadeID=Estoque.UnidadeID
			AND COM_ITE_PRC.ItemID=Estoque.ItemID
			AND COM_ITE_PRC.PrecoID=1
	Where Contabil >0 	
	
	
	
	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	group by BlocoID, Bloco 
	having COUNT(*) >1 
	End

-- Tributos a Recuperar
begin
	Select @BlocoID=@BlocoID+1, @Bloco='Trubitos a Recuperar'
	Insert Into #T (BlocoID, Bloco, Historico, Valor)
	Select 
		@BlocoID,
		@Bloco,
		M.Descricao,
		SUM(M.Valor)
	from @MovimentosEstoque M
	Where ID in(3,4) 
	  AND Estoque=1
	Group BY M.Descricao, M.ID
	Order by M.ID
	

	

	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	group by BlocoID, Bloco 
	having COUNT(*) >1	
end
	
-- Resumo Ativos
begin
	Set @BlocoIni=1
	Set @BlocoFin=@BlocoID

	Select @BlocoID=@BlocoID+1, @Bloco='Ativos'
 
	Insert Into #T (BlocoID,Bloco, Historico, Valor)
	Select @BlocoID, @Bloco, Bloco, SUM(Valor)  
	from #T 
	Where BlocoID< @BlocoID
		AND Soma = 0
	group by BlocoID, Bloco 
	Order BY BlocoID
  				
	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	group by BlocoID, Bloco 
	having COUNT(*) >1
end

-- Contas a Pagar
begin
	Select @BlocoID=@BlocoID+1, @Bloco='Contas a pagar'
  
  
	Insert Into #T (BlocoID,Bloco, Historico, Valor)
		select 
		@BlocoID, @Bloco,
		CadDocu0.Documento,
		IsNull(SUM(Parcela.Aberto),0)Valor
		from CadDocu0 
			JOIN MovFina0  ON CadDocu0.DocumentoID=MovFina0.DocumentoID
			JOIN MovNota0 ON MovNota0.Chave = MovFina0.Chave
			JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovNota0.UnidadeID
			JOIN FN_Staus_Parcela(-1, Null, 1 , @Data )Parcela ON Parcela.ChaveTitulo = MovFina0.ChaveTitulo
	Where Convert(Decimal(18,2),Aberto) > 0   
		AND MovNota0.StatusID in(2)  
		AND MovFina0.DtEmissao <=  @Data
		AND (@Chave IS NULL OR MovNota0.Chave=@Chave OR MovNota0.Chave=@Chave2 OR MovNota0.Chave=@Chave3)
	group by CadDocu0.Documento
		

		
	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	group by BlocoID, Bloco 
	--having COUNT(*) >1 (Comentado ,pois não estava fazendo calculo correto no bloco 5 quando no bloco 4 constava apenas uma linha)
end

	--Provisionamenrto 
	begin
	Select @BlocoID=@BlocoID+1, @Bloco='Provisionamentos'
 	
	Insert Into #T (BlocoID, Bloco, Historico, Valor)
	Select 
		@BlocoID,
		@Bloco,
		M.Descricao,
		SUM(M.Valor)
	from @MovimentosEstoque M
	Where ID in(3, 4, 5) 
		AND Estoque < 0
	Group BY ID, M.Descricao 		
	ORDER BY ID

	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
	Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
	from #T 
	Where BlocoID=@BlocoID
	group by BlocoID, Bloco 
		
	end

	--Passivos
	begin
		Set @BlocoIni=@BlocoFin+2
		Set @BlocoFin=@BlocoID
		Select @BlocoID=@BlocoID+1, @Bloco='Passivos'

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, Bloco, Valor 
		from #T 
		Where BlocoID between @BlocoIni AND @BlocoFin
		  AND Soma=1
 		

		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, 'Total', SUM(Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		group by BlocoID, Bloco 
	end

	--Saldo Atual 
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='Saldo Atual'

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, Bloco, IIF( BlocoID=9, Valor * -1, Valor)
		from #T 
		Where BlocoID in(6, 9)
		  AND Soma=1
  		

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, 'Patrimonio Liquido', - Saldo 
		from  DRE 
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=DRE.UnidadeID
        Where Competencia = @Data-DAY(@Data)+1

		
		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, 'Saldo', SUM(Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		group by BlocoID, Bloco 
 
	 end


	--11 Receitas 
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='1-Receitas'
		;With CTE AS (
		  Select 1 ID, 'Faturamento' Descricao Union
		  Select 2 ID, ' [ - ] Devolução' Descricao Union
		  Select 3 ID, ' [ - ] CMV' Descricao Union
		  Select 4 ID, ' [ - ] Comissão' Descricao Union
		  Select 5 ID, ' [ - ] ICMS' Descricao Union
		  Select 6 ID, ' [ - ] IPI' Descricao Union
		  Select 7 ID, ' [ - ] PIS' Descricao Union
		  Select 8 ID, ' [ - ] COFFINS' Descricao
		)

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select 
			@BlocoID, 
			@Bloco,   	
			cte.Descricao,
			SUM(CASE
					When ID=1 AND M.TipoID IN (7,8,9,10) then T.VL_Total
					When ID=2 AND M.TipoID IN (13) then T.VL_Total * -1
					When ID=3 then T.VL_CustoMedio * -1
					When ID=4 then T.VL_Comissao * -1
					When ID=7 then T.Vl_PIS * -1
					When ID=8 then T.Vl_COFINS * -1
				end) valor
		from  MovNota0 M
			CROSS JOIN CTE
			JOIN VWS_Movimento_Totais T on T.Chave=M.Chave
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=M.UnidadeID
		Where M.StatusID=2
		  AND M.DtMovimento>=@DtIni
		  AND M.DtMovimento<=@Data    
		  AND (@Chave IS NULL OR M.Chave=@Chave OR M.Chave=@Chave2)
		  AND M.TipoID in (7,8,9, 10, 13)
		Group by ID, cte.Descricao
					
		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, 
		  '[+]Descontos de fornecedor', 
		  SUM(MovFina1.ValorDesconto ) 
		from MovFina1
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovFina1.UnidadeID
		  JOIN MovFina2
			 ON MovFina2.OperacaoID=MovFina1.OperacaoID
			AND MovFina2.MovimentoID=MovFina1.MovimentoID 
		Where  MovFina2.StatusID=3  
		  AND MovFina2.DtConciliacao>=@DtIni
		  AND MovFina2.DtConciliacao<=@Data 
		  AND MovFina2.OperacaoID=0   

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, 
		  '[+]Juros cobrado a cliente', 
		  SUM(MovFina1.ValorEncargos) 
		from MovFina1
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovFina1.UnidadeID
		  JOIN MovFina2
			 ON MovFina2.OperacaoID=MovFina1.OperacaoID
			AND MovFina2.MovimentoID=MovFina1.MovimentoID 
		Where MovFina2.StatusID=3  
		  AND MovFina2.DtConciliacao>=@DtIni
		  AND MovFina2.DtConciliacao<=@Data 
		  AND MovFina2.OperacaoID=1  

		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, 'Total', SUM(Valor) , 1 
		from #T 
		Where BlocoID=@BlocoID
	end

	--12 Despesas 
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='2-Despesas'

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select 
		   @BlocoID, 
		   @Bloco, 
		   CadOrca0.Orcamento, IsNull(Sum(MovFina1.ValorLiquido * MovOrca0.Rateio / 100),0)
		from MovNota0
		  JOIN MovOrca0 ON MovNota0.Chave=MovOrca0.Chave			
		  JOIN MovFina0 ON MovNota0.Chave=MovFina0.Chave	 
		  JOIN MovFina1 ON MovFina1.ChaveTitulo=MovFina0.ChaveTitulo
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovNota0.UnidadeID
		  JOIN MovFina2 
			 ON MovFina1.OperacaoID=MovFina2.OperacaoID
			AND MovFina1.MovimentoID=MovFina2.MovimentoID    
		  JOIN dbo.VWS_Orcamento CadOrca0 ON CadOrca0.OrcamentoID=MovOrca0.OrcamentoID
		  JOIN CadOrca0 PO ON PO.OrcamentoID=CadOrca0.ParenteOrcamentoID  
		  join LkpNota0    on LkpNota0.TipoID=MovNota0.TipoID
		Where MovFina2.DtConciliacao>=@DtIni
		  AND MovFina2.DtConciliacao<=@Data   
		  AND MovNota0.StatusID=2  
		  and Financeiro=-1
		  AND CadOrca0.Codigo  LIKE @GradeOrcamentariaDespesas
		  AND (@Chave IS NULL OR MovNota0.Chave=@Chave OR MovNota0.Chave=@Chave2)
		Group by CadOrca0.Orcamento, CadOrca0.Codigo  

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, 
		  '[-]Juros pagos a fornecedor', 
		  SUM(MovFina1.ValorEncargos ) 
		from MovFina1
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovFina1.UnidadeID
		  JOIN MovFina2
			 ON MovFina2.OperacaoID=MovFina1.OperacaoID
			AND MovFina2.MovimentoID=MovFina1.MovimentoID 
		Where  MovFina2.StatusID=3  
		  AND MovFina2.DtConciliacao>=@DtIni
		  AND MovFina2.DtConciliacao<=@Data 
		  AND MovFina2.OperacaoID=0   

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, 
		  '[-]Descontos concedidos a cliente', 
		  SUM(MovFina1.ValorDesconto) 
		from MovFina1
		  JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=MovFina1.UnidadeID
		  JOIN MovFina2
			 ON MovFina2.OperacaoID=MovFina1.OperacaoID
			AND MovFina2.MovimentoID=MovFina1.MovimentoID 
		Where MovFina1.UnidadeID=@UnidadeID
		  AND MovFina2.StatusID=3  
		  AND MovFina2.DtConciliacao>=@DtIni
		  AND MovFina2.DtConciliacao<=@Data 
		  AND MovFina2.OperacaoID=1  

	 	Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select BlocoID, Bloco, 'Total=>'+Bloco, SUM(Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		group by BlocoID, Bloco 
		having COUNT(*) >1   
	end

	--13 Apuração de lucro
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='Apuração de lucro'

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, Bloco, SUM(IIF(BlocoID=@BlocoID-2, 1, -1) *  Valor)
		from #T 
		Where BlocoID between @BlocoID-2 AND @BlocoID-1
		  AND Soma=1
		group by BlocoID, Bloco 

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select 
			@BlocoID, @Bloco, '[+/-] Tranferencia entre filiais',       			
			Sum(MovFina2.Valor*Multiplicador)Valor
		from MovFina2
			JOIN LkpBaix1 on LkpBaix1.OperacaoID=MovFina2.OperacaoID
			JOIN UnidCont0 ON UnidCont0.ContaID=MovFina2.ContaID
			JOIN #CadUnid0 CadUnid0 on CadUnid0.UnidadeID=UnidCont0.UnidadeID
		Where DtConciliacao between @DtIni AND @Data
			and MovFina2.OperacaoID >1

	
		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID, @Bloco, IIF(SUM(Valor)>=0, 'Lucro','Prejuizo'), SUM(Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		group by BlocoID, Bloco 
		having COUNT(*) >1   
	end

	--14 Tem que Zerar
	begin
		Select @BlocoID=@BlocoID+1, @Bloco='Conferência'

		Insert Into #T (BlocoID,Bloco, Historico, Valor)
		Select @BlocoID, @Bloco, iif(BlocoID=10, '[ - ] ', '')+Bloco, SUM(Valor)*iif(BlocoID=10, -1, 1)
		from #T 
		Where BlocoID in (13, 10)
		  AND Soma=0
		group by BlocoID, Bloco 
		

		Insert Into #T (BlocoID,Bloco, Historico, Valor, Soma)
		Select @BlocoID,@Bloco, 'Resultado', SUM( Valor), 1 
		from #T 
		Where BlocoID=@BlocoID
		  AND Soma=0
		group by BlocoID, Bloco 

		update #T set Bloco=UPPER(bloco), Historico=UPPER(Historico)

		 delete from #T where Soma=0 and Valor=0		
	end

	delete #T where Valor =0 or Valor is null

	update RPT_Balanco set Ultima=0 where Dia=@Data

	Insert into  RPT_Balanco
	Select	
	   1 Ultima,
	   @Data Dia,
	   GETDATE() DataHora,
	   BlocoID,
	   Bloco,
	   ID,
	   Historico,
	   Valor + (coalesce((select sum(t.ValorCupom) from #T t where t.Historico = #T.Historico ), 0)) valor,
	   Soma
	from  #T 
	where ValorCupom is null
	
	Select * from RPT_Balanco where Dia=@Data AND ultima=1


end


GO
