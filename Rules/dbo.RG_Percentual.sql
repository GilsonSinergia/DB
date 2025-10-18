/****** Object:  Rule [dbo].[RG_Percentual]    Script Date: 12/24/2015 11:35:30 ******/
CREATE RULE [dbo].[RG_Percentual]
AS 
@range>= $0 AND @range <$100;
GO
