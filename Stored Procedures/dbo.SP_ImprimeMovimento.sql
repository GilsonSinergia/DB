SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE    PROCEDURE [dbo].[SP_ImprimeMovimento]
  @UnidadeID INT =1,
  @TipoID    INT=7,
  @Nota      INT=71836,
  @Index INT =1
AS 

If @Index =0
  Select 4 Tabelas

If @Index =1
Select 
  --Dados da UnidADE
  VWS_Unidades.UnidadeID,
  VWS_Unidades.Nome UND_Razao,
  VWS_Unidades.Reduzido UND_Fantazia,
  VWS_Unidades.Documento UND_CNPJ,
  VWS_Unidades.Endereco UND_Endereco,
  VWS_Unidades.Numero UND_Numero,
  VWS_Unidades.Bairro UMD_Bairro,
  VWS_Unidades.Cidade UND_Cidade,
  VWS_Unidades.UF UND_UF,
  VWS_Unidades.CEP UND_CEP,
  VWS_Unidades.Tel UND_Tel,
  VWS_Unidades.Celular UND_Cel,
  VWS_Unidades.Logo UND_Logo,
  VWS_Unidades.EMail UND_EMail,  
  --Dados Movimento
  MovNota0.Chave,
  LkpNota0.Sigla,
  LkpNota0.Tipo, 
  MovNota0.Nota, 
  Case LkpNota1.StatusID 
    when 0 then 'Orçamento'
    when 1 then 'Reserva'
    when 2 then 'Pedido'
    Else 'Cancelado'
  end Status_Venda,  
  LkpNota1.Status AS NOTA_Status, 
  MovNota0.DtMovimento,
  MovNota0.OBS,
  --Dados do Cliente
  VWS_Pessoas.PessoaID, 
  VWS_Pessoas.Documento,
  VWS_Pessoas.Inscricao,
  VWS_Pessoas.Nome, 
  VWS_Pessoas.Reduzido,
  VWS_Pessoas.Numero,  
  VWS_Pessoas.Endereco,
  VWS_Pessoas.Complemento Proximidade,  
  VWS_Pessoas.Bairro,
  VWS_Pessoas.Cep,
  VWS_Pessoas.Cidade, 
  VWS_Pessoas.UF,
  VWS_Pessoas.Tel Telefone,  
  VWS_Pessoas.Celular Telefone_Celular,  
  VWS_Pessoas.Fax Telefone_Fax,  
  --Dados Vendedor
  CadPess0Vendedor.PessoaID VendedorPessoaID, 
  CadPess0Vendedor.Reduzido VendedorReduzido, 
  ----Dados de Item
  VWS_Movimento_Item.Seq,
  VWS_Movimento_Item.ItemID, 
  I.Item,
  REF.Referencia, 
  COM_ITE_MED.UN UM, 
  VWS_Movimento_Item.Quantidade,
  VWS_Movimento_Item.Ps_LIquido,
  VWS_Movimento_Item.Ps_Bruto,
  VWS_Movimento_Item.Volume,
  VWS_Movimento_Item.VL_Item / VWS_Movimento_Item.Quantidade VL_Unitario, 
  VWS_Movimento_Item.VL_Item VL_Brto,  
  VWS_Movimento_Item.VL_Liquido,  
  VWS_Movimento_Item.Desconto,
  VWS_Movimento_Item.VL_Desconto,
  --Totais
  SUM(VWS_Movimento_Item.VL_Item) over ( PARTITION by MovNota0.Chave)  SubTotal,  
  SUM(VWS_Movimento_Item.VL_FRete) over ( PARTITION by MovNota0.Chave) Total_Frete,
  SUM(VWS_Movimento_Item.VL_Seguro) over ( PARTITION by MovNota0.Chave) Total_Seguro,
  SUM(VWS_Movimento_Item.VL_Outro) over ( PARTITION by MovNota0.Chave) Total_Outro,
  SUM(VWS_Movimento_Item.VL_Outro+VWS_Movimento_Item.VL_Frete+VWS_Movimento_Item.VL_Seguro) over ( PARTITION by MovNota0.Chave) Total_Acressimo,
  SUM(VWS_Movimento_Item.VL_Desconto) over ( PARTITION by MovNota0.Chave)  Total_Desconto,
  SUM(VWS_Movimento_Item.VL_Total) over ( PARTITION by MovNota0.Chave) Total,
  
  --Transporte
  SUM(VWS_Movimento_Item.Ps_LIquido) over ( PARTITION by MovNota0.Chave)Peso,
  MovTran0.Nome Transportador,  
  MovTran0.VeiculoPlaca Placa
FROM MovNota0  
  JOIN VWS_Unidades ON VWS_Unidades.UnidadeID=MovNota0.UnidadeID
  JOIN LkpNota0 ON LkpNota0.TipoID=MovNota0.TipoID
  JOIN LkpNota1 ON LkpNota1.StatusID=MovNota0.StatusID
  JOIN VWS_Pessoas  ON VWS_Pessoas.PessoaID=MovNota0.PessoaID
  JOIN VWS_Movimento_Item ON VWS_Movimento_Item.Chave=MovNota0.Chave  
  JOIN dbo.COM_ITE_CAD I ON I.ItemID = VWS_Movimento_Item.ItemID
  JOIN dbo.COM_ITE_PRD PRD ON PRD.ItemID = I.ItemID
  JOIN dbo.COM_ITE_MED ON COM_ITE_MED.MedidaID = PRD.MedidaID
  LEFT JOIN dbo.COM_ITE_Referencia REF ON REF.ItemID = I.ItemID AND REF.ReferenciaID=1
  
  LEFT JOIN MovVend0 ON MovVend0.Chave = MovNota0.Chave 
  LEFT JOIN CadPess0 CadPess0Vendedor   ON CadPess0Vendedor.PessoaID = MovVend0.PessoaID 
  LEFT JOIN MovTran0 ON MovTran0.Chave = MovNota0.Chave
  LEFT JOIN PesClie0 ON VWS_Pessoas.PessoaID = PesClie0.PessoaID
  LEFT JOIN CadArea0 ON CadArea0.AreaID = PesClie0.AreaID

WHERE MovNota0.UnidadeID=@UnidadeID
  AND MovNota0.TipoID   = @TipoID
  AND MovNota0.Nota     = @Nota
ORDER BY VWS_Movimento_Item.Seq

IF @Index =2
--Financeiro
SELECT 
  Financeiro.Pagamento, 
  MovFina0.Reneg, 
  MovFina0.Parcela, 
  MovFina0.Fatura,
  CadDocu0.Documento,
  MovFina0.DtVencimento Vencimento,
  MovFina0.Valor
FROM MovNota0
  INNER JOIN Financeiro
     ON Financeiro.UnidadeID=MovNota0.UnidadeID
    AND Financeiro.TipoID=MovNota0.TipoID
    AND Financeiro.Nota=MovNota0.Nota 
  INNER JOIN MovFina0
     ON MovFina0.UnidadeID=MovNota0.UnidadeID
    AND MovFina0.TipoID=MovNota0.TipoID
    AND MovFina0.Nota=MovNota0.Nota 
  JOIN CadDocu0
    ON CadDocu0.DocumentoID=MovFina0.DocumentoID  
WHERE MovNota0.UnidadeID=@UnidadeID
  AND MovNota0.TipoID   = @TipoID
  AND MovNota0.Nota     = @Nota
  
  
IF @Index =3
--Serviços
SELECT 
  --Identifica;áo de Veiculo
  SRV_OS_Veiculo.Placa,
  SRV_Veiculo_Marca.Marca,
  SRV_Veiculo_Modelo.Modelo,
  SRV_Veiculo.ANO,
  SRV_OS_Veiculo.KM,
  SRV_OS_Veiculo.Tanque,
  SRV_OS_Veiculo.Sintoma,
  SRV_OS_Veiculo.Avarias,
  SRV_OS_Veiculo.Objetos,
  --Servi;os
  SRV_OS_ITE.ServicoID,
  VWS_Pessoas.Reduzido Tecnico,
  SRV_ITE_CAD.Servico,
  SRV_OS_ITE.Quantidade,
  SRV_OS_ITE.Unitario,
  SRV_OS_ITE.Desconto,
  SRV_OS_ITE.Quantidade * SRV_OS_ITE.Unitario *SRV_OS_ITE.Desconto /100 Total_Desconto,
  SRV_OS_ITE.Quantidade * SRV_OS_ITE.Unitario *(100 - SRV_OS_ITE.Desconto) /100 Total
FROM MovNota0    
  LEFT JOIN SRV_OS_ITE
    ON SRV_OS_ITE.UnidadeID=MovNota0.UnidadeID
   AND SRV_OS_ITE.TipoID=MovNota0.TipoID
   AND SRV_OS_ITE.Nota=MovNota0.Nota   
  JOIN SRV_ITE_CAD ON SRV_ITE_CAD.ServicoID=SRV_OS_ITE.ServicoID
  JOIN VWS_Pessoas ON VWS_Pessoas.PessoaID=SRV_OS_ITE.PessoaID 
  LEFT JOIN SRV_OS_Veiculo
     ON SRV_OS_Veiculo.UnidadeID=MovNota0.UnidadeID
    AND SRV_OS_Veiculo.TipoID=MovNota0.TipoID
    AND SRV_OS_Veiculo.Nota=MovNota0.Nota   
  LEFT JOIN SRV_Veiculo ON SRV_Veiculo.Placa=SRV_OS_Veiculo.Placa
  LEFT JOIN SRV_Veiculo_Marca ON SRV_Veiculo.MarcaID=SRV_Veiculo_Marca.MarcaID
  LEFT JOIN SRV_Veiculo_Modelo ON SRV_Veiculo.ModeloID=SRV_Veiculo_Modelo.ModeloID
WHERE SRV_OS_ITE.UnidadeID=@UnidadeID
  AND SRV_OS_ITE.TipoID   = @TipoID
  AND SRV_OS_ITE.Nota     = @Nota
 
 
IF @Index =4
-- Veiculos
SELECT
  Chave,
  'Tara'Tipo, Placa, UF, Peso
FROM dbo.TMS_Transp_Veiculo
WHERE UnidadeID = @UnidadeID AND TipoID = @TipoID AND Nota = @Nota
UNION ALL
SELECT 
  Chave,
  'Liquido', NULL, NULL,SUM(Quantidade * PsLiquido) Peso
FROM dbo.COM_ITE_MOV
  JOIN dbo.COM_ITE_PRD ON COM_ITE_PRD.ItemID = COM_ITE_MOV.ItemID
WHERE PsLiquido> 0
  AND COM_ITE_MOV.UnidadeID = @UnidadeID AND COM_ITE_MOV.TipoID = @TipoID AND COM_ITE_MOV.Nota = @Nota
GROUP BY Chave
GO
