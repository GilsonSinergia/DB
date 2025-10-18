/****** Object:  Rule [dbo].[RG_Naturais]    Script Date: 12/24/2015 11:35:27 ******/
--select * from com_ite_prc

--begin tran
--Update
--com_ite_prc 
-- set Valor=-1
--where ItemID = 16280
--select * from com_ite_prc
--where ItemID = 16280

--go
--rollback

CREATE RULE [dbo].[RG_Naturais]
AS 
@range>= 0
GO
