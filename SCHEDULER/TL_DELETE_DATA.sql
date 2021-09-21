	BEGIN
	DBMS_SCHEDULER.CREATE_JOB (
		job_name => 'TL_DELETE_DATA',
		job_type => 'PLSQL_BLOCK',
		job_action => 
		'BEGIN
		 DELETE FROM TurnoLavorativo
		 WHERE Data_Ora < SYSDATE-90;
		
		END;',
		
		start_date => TO_DATE('01-GEN-2021','DD-MON-YYYY') ,
		repeat_interval => 'FREQ=MONTHLY; INTERVAL=3;',
		enabled => TRUE ,
		comments => 'Cancellazione delle date inerenti ai turni lavorativi vecchi 
		di 3 mesi.') ;
	END;
/