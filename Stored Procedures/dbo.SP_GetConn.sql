SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
create PROCEDURE [dbo].[SP_GetConn]

AS
--BEGIN

	--SET NOCOUNT ON;

	--DECLARE @old int
	--DECLARE @new int
	--DECLARE @synced int
	--DECLARE @doc char(14)

	--create table #cnn (
	--	mes tinyint,
	--	ano smallint,
	--	nomePC char(20),
	--	doc char(14),
	--	ip varchar(17),
	--	dbuser varchar(50),
	--	conn tinyint,
	--	sync tinyint
	--	)

	--Select TOP 1 @doc = Doc
	--from PAF_Retaguarda.dbo.App

	--insert into #cnn
	--SELECT	datepart(month,getdate()),
	--				datepart(year,getdate()),
	--				es.[host_name],
	--				@doc,
	--				ec.client_net_address,
	--				es.login_name,
	--				COUNT(*)Conexoes,
	--				0
	--FROM sys.dm_exec_sessions AS es
	--	INNER JOIN sys.dm_exec_connections AS ec
	--		ON es.session_id = ec.session_id
	--where  es.[program_name]  = 'Kares Empresarial'
	--Group by
	--	 ec.client_net_address,
	--	 es.[host_name],
	--	 es.login_name,
	--	 es.[program_name]
	--ORDER BY ec.client_net_address

	--SELECT @old = COUNT(*)
	--from master.dbo.cnn
	--where mes = datepart(month,getdate())
	--	and	ano = datepart(year,getdate())

	--SELECT @synced = COUNT(*)
	--from master.dbo.cnn
	--where mes = datepart(month,getdate())
	--	and	ano = datepart(year,getdate())
	--	and sync = 0
		
	--SELECT @new = COUNT(*)
	--FROM #cnn

	--if (@new > @old)
	--	begin
		
	--	delete master.dbo.cnn
	--	where mes = datepart(month,getdate())
	--		and	ano = datepart(year,getdate())
		
	--	insert into master.dbo.cnn
	--	select *
	--	from #cnn
		
	--	update master.dbo.cnn
	--	set sync = 1
	--	where mes = datepart(month,getdate())
	--		and	ano = datepart(year,getdate())
					
	--end
--end
GO
