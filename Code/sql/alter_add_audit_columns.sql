-- =============================================================
-- alter_add_audit_columns.sql
-- Adds the audit columns requested by the professor to tables that
-- already exist (run once in Query editor). New installs can use
-- create_tables.sql, which already contains these columns.
--   updated_date = when the row was last inserted/updated by ADF
--   updated_by   = which pipeline run did it ('<pipeline> - <run id>')
-- =============================================================
ALTER TABLE dbo.patient   ADD updated_date DATETIME2, updated_by VARCHAR(100);
ALTER TABLE dbo.hospital  ADD updated_date DATETIME2, updated_by VARCHAR(100);
ALTER TABLE dbo.diagnosis ADD updated_date DATETIME2, updated_by VARCHAR(100);
ALTER TABLE dbo.visit     ADD updated_date DATETIME2, updated_by VARCHAR(100);
