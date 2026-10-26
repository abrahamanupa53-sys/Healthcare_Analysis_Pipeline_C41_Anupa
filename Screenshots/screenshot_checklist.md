# Screenshot checklist

✅ = included · ⬜ = still to take (save with this exact name)

## Step 1: Source profiling and Azure setup
✅ Step_1_Screenshot_1 Architecture diagram
✅ Step_1_Screenshot_2 VM deployment complete
✅ Step_1_Screenshot_3 SHIR node registered
✅ Step_1_Screenshot_4 SHIR status Running
✅ Step_1_Screenshot_5 Storage account deployed
✅ Step_1_Screenshot_6 Containers landing and staging
✅ Step_1_Screenshot_7 Key Vault deployed
✅ Step_1_Screenshot_8 Key Vault role assignments
✅ Step_1_Screenshot_9 Secret vm-password
✅ Step_1_Screenshot_10 Storage role assignment
✅ Step_1_Screenshot_11 Linked services

## Step 2: Landing ingestion
✅ Step_2_Screenshot_1 pl_ingest_landing canvas (ForEach + Copy)
✅ Step_2_Screenshot_2 pl_ingest_landing run Succeeded (4 copies)
✅ Step_2_Screenshot_3 landing container folders

## Step 3: Staging validation
✅ Step_3_Screenshot_1 to 19 (datasets, patient flow, schema, rules, dedup, Parquet output, hospital/diagnosis/visit flows, pl_staging Succeeded)
✅ Step_3_Screenshot_20 staging container folders

## Step 4: SQL load and SCD Type 1
✅ Step_4_Screenshot_1 to 11 (SQL DB, secrets, ls_sql, CREATE TABLE, copy mapping, pl_load_sql Succeeded, counts 5/5/5/8)
✅ Step_4_Screenshot_13 SCD1 AFTER: 6 rows, P001 city Pune, P006 added
✅ Step_4_Screenshot_15 Audit columns filled; P001 back to Mumbai, P006 kept (not deleted)

## Step 5: Orchestration and alerts
✅ Step_5_Screenshot_1 pl_master all Succeeded
✅ Step_5_Screenshot_2 Alert rule condition
✅ Step_5_Screenshot_3 Action group email
✅ Step_5_Screenshot_4 Alert enabled
✅ Step_5_Screenshot_5 Parameterized pl_master run Succeeded
