SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
Create   View [dbo].[VWS_Estoque_Operacao] as
Select 1 ÓperacaoID,  'Compras' Operacao
Union
Select 2,  'Devoção de compra'
Union
Select 3,  'Venda'
Union
Select 4,  'Devoção de Venda'
Union
Select 5,  'Entrada por Tranferencia'
Union
Select 6,  'Saida por Tranferencia'
Union
Select 7,  'Outras Entradas'
Union
Select 8,  'Outras Saidaa'

GO
