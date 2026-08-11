/* ============================================================
   SILVER LAYER — Cleaned & Validated Data
   Purpose: Remove duplicates, handle NULLs, standardize formats,
   cast correct data types, validate foreign keys.
   ============================================================ */

/* ---------- PATIENTS ---------- */
CREATE TABLE silver.patients AS
SELECT
    PatientID,
    TRIM(PatientName)                       AS PatientName,
    UPPER(Gender)                           AS Gender,
    TRY_CAST(DOB AS DATE)                   AS DOB,
    TRIM(City)                              AS City,
    COALESCE(NULLIF(TRIM(InsuranceProvider), ''), 'Self-Pay') AS InsuranceProvider
FROM bronze.patients
WHERE PatientID IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY PatientID ORDER BY PatientID) = 1;  -- de-duplication

/* ---------- DOCTORS ---------- */
CREATE TABLE silver.doctors AS
SELECT
    DoctorID,
    TRIM(DoctorName)                        AS DoctorName,
    DepartmentID,
    TRIM(Specialization)                    AS Specialization,
    TRY_CAST(Experience_Years AS INT)       AS Experience_Years,
    TRY_CAST(JoiningDate AS DATE)           AS JoiningDate
FROM bronze.doctors
WHERE DoctorID IS NOT NULL
QUALIFY ROW_NUMBER() OVER (PARTITION BY DoctorID ORDER BY DoctorID) = 1;

/* ---------- DEPARTMENTS ---------- */
CREATE TABLE silver.departments AS
SELECT DISTINCT
    DepartmentID,
    TRIM(DepartmentName)                    AS DepartmentName,
    TRIM(Location)                          AS Location,
    HeadDoctorID
FROM bronze.departments
WHERE DepartmentID IS NOT NULL;

/* ---------- ADMISSIONS ---------- */
CREATE TABLE silver.admissions AS
SELECT
    a.AdmissionID,
    a.PatientID,
    a.DoctorID,
    a.DepartmentID,
    TRY_CAST(a.AdmissionDate AS DATE)       AS AdmissionDate,
    TRY_CAST(a.DischargeDate AS DATE)       AS DischargeDate,
    TRIM(a.AdmissionType)                   AS AdmissionType,
    TRIM(a.BedNumber)                       AS BedNumber,
    DATEDIFF(
        DAY,
        TRY_CAST(a.AdmissionDate AS DATE),
        TRY_CAST(a.DischargeDate AS DATE)
    )                                       AS LengthOfStay_Days
FROM bronze.admissions a
WHERE a.AdmissionID IS NOT NULL
  -- referential integrity check: only keep admissions with valid patient/doctor
  AND EXISTS (SELECT 1 FROM silver.patients p WHERE p.PatientID = a.PatientID)
  AND EXISTS (SELECT 1 FROM silver.doctors  d WHERE d.DoctorID  = a.DoctorID)
QUALIFY ROW_NUMBER() OVER (PARTITION BY a.AdmissionID ORDER BY a.AdmissionID) = 1;

/* ---------- BILLING ---------- */
CREATE TABLE silver.billing AS
SELECT
    BillingID,
    AdmissionID,
    TRIM(BillingCategory)                   AS BillingCategory,
    TRY_CAST(Amount AS DECIMAL(12,2))       AS Amount,
    COALESCE(NULLIF(TRIM(PaymentStatus), ''), 'Unknown') AS PaymentStatus,
    TRY_CAST(NULLIF(PaymentDate, '') AS DATE) AS PaymentDate
FROM bronze.billing
WHERE BillingID IS NOT NULL
  AND TRY_CAST(Amount AS DECIMAL(12,2)) IS NOT NULL   -- drop rows with invalid amounts
QUALIFY ROW_NUMBER() OVER (PARTITION BY BillingID ORDER BY BillingID) = 1;

/* ============================================================
   Data Quality Check — Silver Layer
   ============================================================ */
SELECT 'silver.patients' AS TableName, COUNT(*) AS RowCount FROM silver.patients
UNION ALL
SELECT 'silver.doctors', COUNT(*) FROM silver.doctors
UNION ALL
SELECT 'silver.departments', COUNT(*) FROM silver.departments
UNION ALL
SELECT 'silver.admissions', COUNT(*) FROM silver.admissions
UNION ALL
SELECT 'silver.billing', COUNT(*) FROM silver.billing;

-- Check for orphaned billing records (billing without matching admission)
SELECT b.*
FROM silver.billing b
LEFT JOIN silver.admissions a ON b.AdmissionID = a.AdmissionID
WHERE a.AdmissionID IS NULL;
