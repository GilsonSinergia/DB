SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_SYS_COLUMNS]AS
select       
    C.object_id TABLE_ID,
	Object_Name( C.object_id) TABLE_NAME,    
	C.column_id COLUMN_ID,
	convert(sysname,c.name) COLUMN_NAME,
 	Convert(Bit, IIF(PKC.column_id is null, 0, 1)) PRIMARY_KEY,
	c.is_nullable NULLABLE,
	c.is_computed COMPUTED
from sys.tables T
  JOIN sys.all_columns C ON C.object_id=T.object_id   
  JOIN sys.indexes PK 
    ON PK.object_id = c.object_id  
   AND PK.is_primary_key=1
  LEFT JOIN sys.index_columns PKC 
    ON PKC.object_id=PK.object_id
   and PKC.index_id= pk.index_id
   and PKC.column_id=C.column_id 
--where T.object_id = 266496774	  	
GO
