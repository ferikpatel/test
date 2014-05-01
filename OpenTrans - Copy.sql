SELECT DB_NAME(DT.database_id) As DBName,
	TranType = Case DT.database_transaction_type
		When 1 Then 'Read/write transaction'
		When 2 Then 'Read-only transaction'
		When 3 Then 'System transaction'
	End,
	TranState = Case database_transaction_state
		When 1 Then 'Transaction has not been initialized'
		When 3 Then 'Transaction has been initialized but has not generated any log records'
		When 4 Then 'Transaction has generated log records'
		When 5 Then 'Transaction has been prepared'
		When 10 Then 'Transaction has been committed'
		When 11 Then 'Transaction has been rolled back'
		When 12 Then 'Transaction is being committed. In this state the log record is being generated, but it has not been materialized or persisted'
	End,
	*
FROM sys.dm_tran_database_transactions DT
Left Join sys.dm_tran_session_transactions ST ON ST.transaction_id = DT.transaction_id
Left Join sys.dm_exec_sessions S On S.session_id = ST.session_ID
