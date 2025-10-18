SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VWS_SYS_FK]
AS
select     
	C.object_id TABLE_ID,    
    OBJECT_NAME( FKC.parent_object_id)TABLE_NAME,
	OBJECT_NAME(FKC.referenced_object_id)REFERENCIA_TABLE,
    FKC.parent_column_id COLUMN_ID,	
	c.name COLUMN_NAME,
	r.column_id COLUM_REFERENCIA_ID,
	r.name COLUM_REFERENCIA_NAME
from sys.foreign_key_columns FKC
  JOIN  sys.all_columns c   on FKC.parent_object_id=C.object_id and FKC.parent_column_id=C.column_id  
  JOIN  sys.all_columns r   on FKC.parent_object_id=r.object_id and FKC.parent_column_id=r.column_id  
 
GO
