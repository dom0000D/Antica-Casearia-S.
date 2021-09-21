	BEGIN 
	DBMS_SCHEDULER.DROP_JOB( 
		job_name  => 'TL_delete_data', 
		force => TRUE 
	); 
END;
/