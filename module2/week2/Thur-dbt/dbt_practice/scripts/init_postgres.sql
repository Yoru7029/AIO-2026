-- PostgreSQL initialization guide.
-- Step 1: connect to the default postgres database and run:
CREATE DATABASE sql_transform_practice;

-- Step 2: connect to the sql_transform_practice database and run:
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;
