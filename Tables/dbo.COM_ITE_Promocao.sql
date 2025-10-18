CREATE TABLE [dbo].[COM_ITE_Promocao]
(
[PromocaoID] [int] NOT NULL,
[UnidadeID] [tinyint] NOT NULL,
[ItemID] [int] NOT NULL,
[Unitario] [dbo].[Dinheiro] NOT NULL,
[Desconto] [decimal] (6, 4) NOT NULL,
[Comissao] [decimal] (6, 4) NOT NULL
)
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE TRIGGER [dbo].[Block_Promocao]
   ON [dbo].[COM_ITE_Promocao]
     FOR Update, INSERT
AS 

  IF 	(SELECT COUNT(*)
				FROM COM_ITE_Promocao
				  INNER Join Inserted I
					--ON I.PromocaoID = COM_ITE_Promocao.PromocaoID
				   on I.ItemID     = COM_ITE_Promocao.ItemID
				   AND I.UnidadeID = COM_ITE_Promocao.UnidadeID
				Where 
				  I.PromocaoID in 
				    ( Select   COM_Promocao2.PromocaoID
						--,COM_Promocao2.PromocaoID
						From COM_Promocao
						  Inner Join COM_Promocao COM_Promocao2
							On COM_Promocao2.PromocaoID <> COM_Promocao.PromocaoID 
						   And COM_Promocao2. PrecoID = COM_Promocao.PrecoID
						where COM_Promocao2.DtInicio between   COM_Promocao.DtInicio and  COM_Promocao.DtTermino
						  or  COM_Promocao.DtInicio between   COM_Promocao2.DtInicio and  COM_Promocao2.DtTermino
				  		  group by  COM_Promocao2.PromocaoID
			        	having 	COUNT(*)>1)	  
				     				  
				  )> 1 
  BEGIN
	RAISERROR ('Não é possivel inserir promoção com o mesmo preço e item dentro do mesmo período ', 16, 1)
	Rollback
  END
GO
ALTER TABLE [dbo].[COM_ITE_Promocao] ADD CONSTRAINT [PK_EstProIte] PRIMARY KEY CLUSTERED ([PromocaoID], [UnidadeID], [ItemID])
GO
ALTER TABLE [dbo].[COM_ITE_Promocao] ADD CONSTRAINT [FK_COM_ITE_Promocao_COM_ITE_UND] FOREIGN KEY ([UnidadeID], [ItemID]) REFERENCES [dbo].[COM_ITE_UND] ([UnidadeID], [ItemID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[COM_ITE_Promocao] ADD CONSTRAINT [FK_EstProIte_EstPrdPro] FOREIGN KEY ([PromocaoID]) REFERENCES [dbo].[COM_Promocao] ([PromocaoID]) ON DELETE CASCADE ON UPDATE CASCADE
GO
EXEC sp_bindefault N'[dbo].[DF_Zero]', N'[dbo].[COM_ITE_Promocao].[Unitario]'
GO
