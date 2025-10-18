SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[SPS_Emit_QNAB]
  @Acao ChaR(1)='I',
  @ConvenioID Int = 1,
  @Chave char(14) = NULL,
  @ChaveTitulo char(18) = NULL,
  @ModeloID int = NULL,
  @NF int = NULL,
  @Serie int = NULL
as
/*
Açoes 
E-Emitir
I-Imprimir
C-Cancelar
R-Gerar Remessa
B-Baixar Titulo
*/




if @Acao='E' begin

Declare @NossoNumero int

Select @NossoNumero = IsNull(max( NossoNumero), 0) +1
from FIN_CBR_Titulo 
where ConvenioID=@ConvenioID

Insert Into FIN_CBR_Titulo
Select 
  C.ConvenioID,
  DENSE_RANK () over (Order by F.ChaveTitulo)+C.NossoNumero NossoNumero,
  F.ChaveTitulo,
  C.Carteira,
  C.Especie,
  C.Aceite,
  GetDate() DtLancamento,
  F.DtVencimento,
  F.Aberto Valor,
  0.00 Desconto,
  0.00 Acrecimo,
  0.00 Juros,
  0.00 Multas,
  C.LocalPagamento,
  C.INSTRUCAO_1,
  C.INSTRUCAO_2,
  NULL DtMoraJuros,
  NULL DtDesconto,
  NULL DtAbatimento,
  NULL DtProtesto,
  NULL DtBaixa,
  NULL Remessa
from VWS_Movimento_Titulos F
  CROSS JOIN FIN_CBR_CAD C
  LEFT JOIN FIN_CBR_Titulo T ON T.ChaveTitulo= F.ChaveTitulo
  LEFT JOIN MovFisc0 N ON N.Chave=F.Chave
  LEFT JOIN LkpFisc0 on LkpFisc0.ModeloID=N.ModeloID
where T.NossoNumero is NULL
  AND C.ConvenioID=@ConvenioID
  AND Aberto>0
  AND (@Chave is NULL OR F.Chave=@Chave)  
  AND (@ChaveTitulo is NULL OR F.ChaveTitulo=@ChaveTitulo)  
  AND (@ModeloID+@NF+@Serie is NULL OR LkpFisc0.Sigla=@ModeloID)  
  AND (@ModeloID + @NF + @Serie is NULL OR N.NF=@NF)  
  AND (@ModeloID+@NF+@Serie is NULL OR N.Serie=@Serie)  

update FIN_CBR_CAD set NossoNumero = @NossoNumero where ConvenioID=@ConvenioID
end

if @Acao = 'R' begin

declare @Remessa int
Select @Remessa= IsNull(Max(T.Remessa),0)
from FIN_CBR_Titulo T
  JOIN FIN_CBR_CAD C on C.ConvenioID=T.ConvenioID
  JOIN MovFina0 F ON F.ChaveTitulo=T.ChaveTitulo  
where T.ConvenioID=@ConvenioID
  AND T.Remessa is NULL
update FIN_CBR_CAD set Remessa=@Remessa+1 where ConvenioID=@ConvenioID

update T set Remessa=C.Remessa
from FIN_CBR_Titulo T
  JOIN FIN_CBR_CAD C on C.ConvenioID=T.ConvenioID
  JOIN MovFina0 F ON F.ChaveTitulo=T.ChaveTitulo  
  LEFT JOIN MovFisc0 N ON N.Chave=F.Chave
  LEFT JOIN LkpFisc0 on LkpFisc0.ModeloID=N.ModeloID
where T.ConvenioID=@ConvenioID
  AND (@Chave is NULL OR F.Chave=@Chave)  
  AND (@ChaveTitulo is NULL OR F.ChaveTitulo=@ChaveTitulo)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR LkpFisc0.Sigla=@ModeloID)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR N.NF=@NF)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR N.Serie=@Serie)
  AND T.Remessa is NULL
end


select 
  T.ConvenioID,
  M.Chave,
  T.ChaveTitulo,
  LkpFisc0.Sigla Modelo,
  N.NF,
  N.Serie,
  T.NossoNumero,
  F.Parcela,
  F.Fatura,
  T.DtLancamento,
  M.DtMovimento,
  T.DtVencimento,
  T.Especie,
  T.Carteira,
  T.Valor,
  0.00 ValorAbatimento,
  T.DtAbatimento,
  T.LocalPagamento,
  T.INSTRUCAO_1,
  T.INSTRUCAO_2,
  --Sacado
  P.Nome Sacado_Nome,
  P.Documento Sacado_Documento,
  P.Tel Sacado_Tel,
  P.EMail Sacado_Email,
  P.CEP Sacado_CEP,
  P.Endereco Sacado_Logradouto,
  P.Numero Sacado_Numero,
  P.Complemento Sacado_Complemento,
  P.Bairro Sacado_Bairro,
  P.Cidade Sacado_Cidade,
  P.UF Sacado_UF,
  T.Remessa
from MovNota0 M
  JOIN VWS_Movimento_Titulos F ON F.Chave=M.Chave
  JOIN VWS_Pessoas P ON P.PessoaID=M.PessoaID
  JOIN FIN_CBR_Titulo T ON T.ChaveTitulo= F.ChaveTitulo
  JOIN FIN_CBR_CAD C on C.ConvenioID=T.ConvenioID
  JOIN dbo.VWS_Conta CF ON CF.ContaID=C.ContaID
  LEFT JOIN MovFisc0 N ON N.Chave=M.Chave
  LEFT JOIN LkpFisc0 on LkpFisc0.ModeloID=N.ModeloID
where (@Chave is NULL OR F.Chave=@Chave)  
  AND (@ChaveTitulo is NULL OR F.ChaveTitulo=@ChaveTitulo)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR LkpFisc0.Sigla=@ModeloID)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR N.NF=@NF)  
  AND (isNull( @ModeloID,0)+ isNull( @NF,0)+isNull( @Serie,0) =0 OR N.Serie=@Serie)
  AND 1= Case 
          when @Acao In( 'I', 'E') then 1 
		  when @Acao In( 'C') AND T.Remessa is NULL then 1 
		  when @Acao In( 'R') AND T.Remessa = C.Remessa then 1 
	      else 0 
	     end

if @Acao = 'C'
Delete T
from VWS_Movimento_Titulos F
  CROSS JOIN FIN_CBR_CAD C
  LEFT JOIN FIN_CBR_Titulo T ON T.ChaveTitulo= F.ChaveTitulo
  LEFT JOIN MovFisc0 N ON N.Chave=F.Chave
  LEFT JOIN LkpFisc0 on LkpFisc0.ModeloID=N.ModeloID
where Aberto>0
  AND (@Chave is NULL OR F.Chave=@Chave)  
  AND (@ChaveTitulo is NULL OR F.ChaveTitulo=@ChaveTitulo)  
  AND (@ModeloID+@NF+@Serie is NULL OR LkpFisc0.Sigla=@ModeloID)  
  AND (@ModeloID + @NF + @Serie is NULL OR N.NF=@NF)  
  AND (@ModeloID+@NF+@Serie is NULL OR N.Serie=@Serie)
  AND T.Remessa is NUll

GO
