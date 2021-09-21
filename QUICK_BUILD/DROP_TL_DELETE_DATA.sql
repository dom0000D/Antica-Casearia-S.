	BEGIN 
	DBMS_SCHEDULER.DROP_JOB( 
		job_name  => 'TL_DELETE_DATA', 
		force => TRUE 
	); 
END;
/