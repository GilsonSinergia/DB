SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[VWS_SYS_TABLES]AS
select       
    T.object_id TABLE_ID,
	Object_Name( T.object_id) TABLE_NAME
from sys.tables T

	
GO
