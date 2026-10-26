-- =============================================================
-- validation_queries.sql
-- Queries used as evidence after each load (run in Query editor)
-- =============================================================

-- 1. Row counts per table (batch 1 result: patient 5, hospital 5, diagnosis 5, visit 8)
SELECT 'patient'   AS tbl, COUNT(*) AS cnt FROM dbo.patient
UNION ALL SELECT 'hospital',  COUNT(*) FROM dbo.hospital
UNION ALL SELECT 'diagnosis', COUNT(*) FROM dbo.diagnosis
UNION ALL SELECT 'visit',     COUNT(*) FROM dbo.visit;

-- 2. Rerun check: no key should appear more than once (expect 0 rows)
SELECT patient_id, COUNT(*) FROM dbo.patient GROUP BY patient_id HAVING COUNT(*) > 1;
SELECT visit_id,   COUNT(*) FROM dbo.visit   GROUP BY visit_id   HAVING COUNT(*) > 1;

-- 3. Rows per batch (shows which pipeline run last wrote each row)
SELECT 'patient' AS tbl, batch_id, COUNT(*) AS cnt FROM dbo.patient GROUP BY batch_id
UNION ALL SELECT 'visit', batch_id, COUNT(*) FROM dbo.visit GROUP BY batch_id;

-- 4. SCD Type 1 demo: run BEFORE and AFTER editing patient_raw.csv on the VM and rerunning pl_master
--    Before: 5 rows, P001 city = Mumbai
--    After:  6 rows, P001 city = Pune (overwritten), P006 Ananya Singh inserted,
--            updated_date / updated_by show the new pl_load_sql run on P001 and P006
SELECT patient_id, first_name, last_name, city, last_updated AS created_date, updated_date, updated_by FROM dbo.patient ORDER BY patient_id;
SELECT hospital_id, hospital_name, bed_count, batch_id FROM dbo.hospital ORDER BY hospital_id;
SELECT diagnosis_code, diagnosis_desc, batch_id FROM dbo.diagnosis ORDER BY diagnosis_code;
SELECT visit_id, patient_id, cost, discharge_date, batch_id FROM dbo.visit ORDER BY visit_id;

-- 5. Relationship check: every visit points to an existing parent (expect 0 rows)
SELECT v.visit_id
FROM dbo.visit v
LEFT JOIN dbo.patient   p ON p.patient_id     = v.patient_id
LEFT JOIN dbo.hospital  h ON h.hospital_id    = v.hospital_id
LEFT JOIN dbo.diagnosis d ON d.diagnosis_code = v.diagnosis_code
WHERE p.patient_id IS NULL OR h.hospital_id IS NULL OR d.diagnosis_code IS NULL;
