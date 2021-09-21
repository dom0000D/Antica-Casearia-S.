alter session set "_ORACLE_SCRIPT"=true;  
set linesize 300;

@@DROP_UTENTI.sql
@@CREA_UTENTI.sql

CL SCR;

PROMPT Creazione Utenti completata. Accedere come utente 'caseificio' (pwd: 123)