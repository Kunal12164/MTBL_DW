/*
===============================
Create database and Schema
===============================

Script Purpose:
    This script creates a new database named 'MTBL' after checking if it alreay exists.
    If the database exists, it dropped & recreated and also this scripts sets up three schema within the database: 'Bronze','Silver','Gold'.

WARNING:
    It will drop & recreate the database if database already exists.
*/


use master;
GO

--- Drop and recreate the 'MTBL' database
If Exists (Select 1 from sys.databases where name = 'MTBL')
Begin
	print('Already has this MTBL database in our system')
End;
GO
Create database MTBL


--- Drop and recreate the 'Bronze' schema
GO
Use MTBL

If Exists (Select 1 from sys.schemas where name = 'Bronze')
Begin
	print('Already has this Bronze Schema in our MTBL database')
End;

GO
create schema Bronze;


--- Drop and recreate the 'Silver' schema
GO
If Exists (Select 1 from sys.schemas where name = 'Silver')
Begin
	print('Already has this Silver Schema in our MTBL database')
End;

GO
create schema Silver;


--- Drop and recreate the 'Gold' schema
GO
If Exists (Select 1 from sys.schemas where name = 'Gold')
Begin
	print('Already has this Gold Schema in our MTBL database')
End;

GO
create schema Gold;

