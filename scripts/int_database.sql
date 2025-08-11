/*
============================
Create Database and Schemas
============================

Script Purpose:
       This script creates a database called "datawarehouse" additionally the script creates schemas 
       called "bronze","silver" and "gold".
*/


       
-- Create database Datawarehouse
create database datawarehouse;

-- Create Schemas bronze, silver and gold
use datawarehouse;

create schema bronze;
create schema silver;
