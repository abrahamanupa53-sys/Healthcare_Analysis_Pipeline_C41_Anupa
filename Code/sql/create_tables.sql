-- =============================================================
-- create_tables.sql
-- Healthcare Data Pipeline: Azure SQL target tables
-- Database: sqldb-healthcare (Azure SQL Database, Basic tier)
--
-- Run this once in Azure Portal > SQL database > Query editor,
-- BEFORE running pl_load_sql or pl_master.
--
-- Load order (because of the foreign keys on visit):
--   1. patient, hospital, diagnosis  (any order, can run in parallel)
--   2. visit                         (only after the three above succeed)
--
-- SCD Type 1: ADF Copy activity sink uses "Upsert" on the primary key.
--   New key      -> row inserted
--   Existing key -> attributes overwritten with the new values
--   Key missing from a later file -> row left as it is (never deleted)
--
-- batch_id     = the ADF pipeline run id that last wrote the row
-- last_updated = created date: filled by the DEFAULT when the row is first inserted
--                (not mapped in the Copy activity, so updates do not change it)
-- updated_date = set by ADF on every insert AND update (Copy source additional column @utcnow())
-- updated_by   = set by ADF on every insert AND update: '<pipeline name> - <run id>'
-- =============================================================

-- Drop in reverse dependency order (only if you need a clean rebuild)
-- DROP TABLE IF EXISTS dbo.visit;
-- DROP TABLE IF EXISTS dbo.patient;
-- DROP TABLE IF EXISTS dbo.hospital;
-- DROP TABLE IF EXISTS dbo.diagnosis;

CREATE TABLE dbo.patient (
    patient_id    VARCHAR(20)  NOT NULL PRIMARY KEY,
    first_name    VARCHAR(50),
    last_name     VARCHAR(50),
    gender        VARCHAR(10),
    dob           DATE,
    city          VARCHAR(50),
    batch_id      VARCHAR(50),
    last_updated  DATETIME2    DEFAULT SYSUTCDATETIME(),
    updated_date  DATETIME2,
    updated_by    VARCHAR(100)
);

CREATE TABLE dbo.hospital (
    hospital_id   VARCHAR(20)  NOT NULL PRIMARY KEY,
    hospital_name VARCHAR(100),
    city          VARCHAR(50),
    bed_count     INT,
    batch_id      VARCHAR(50),
    last_updated  DATETIME2    DEFAULT SYSUTCDATETIME(),
    updated_date  DATETIME2,
    updated_by    VARCHAR(100)
);

CREATE TABLE dbo.diagnosis (
    diagnosis_code VARCHAR(20)  NOT NULL PRIMARY KEY,
    diagnosis_desc VARCHAR(100),
    batch_id       VARCHAR(50),
    last_updated   DATETIME2    DEFAULT SYSUTCDATETIME(),
    updated_date   DATETIME2,
    updated_by     VARCHAR(100)
);

CREATE TABLE dbo.visit (
    visit_id        VARCHAR(20)   NOT NULL PRIMARY KEY,
    patient_id      VARCHAR(20)   NOT NULL,
    hospital_id     VARCHAR(20)   NOT NULL,
    admission_date  DATE,
    discharge_date  DATE,          -- NULL = patient still admitted (open visit)
    diagnosis_code  VARCHAR(20)   NOT NULL,
    cost            DECIMAL(12,2),
    batch_id        VARCHAR(50),
    last_updated    DATETIME2     DEFAULT SYSUTCDATETIME(),
    updated_date    DATETIME2,
    updated_by      VARCHAR(100),
    CONSTRAINT fk_visit_patient   FOREIGN KEY (patient_id)     REFERENCES dbo.patient(patient_id),
    CONSTRAINT fk_visit_hospital  FOREIGN KEY (hospital_id)    REFERENCES dbo.hospital(hospital_id),
    CONSTRAINT fk_visit_diagnosis FOREIGN KEY (diagnosis_code) REFERENCES dbo.diagnosis(diagnosis_code)
);
