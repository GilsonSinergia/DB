SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [dbo].[VWS_SYS_VIEWS]
as
Select 
  object_id VIEW_ID, 
  name VIEW_NAME
from sys.views
Where name like 'VWS_%'
GO
