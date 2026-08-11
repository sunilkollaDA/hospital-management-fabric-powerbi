/* ============================================================
   BRONZE LAYER — Raw Data Ingestion
   Purpose: Load source CSV files as-is into Bronze tables.
   No transformation, no cleaning — mirrors source exactly.
   ============================================================ */

-- Drop and recreate Bronze schema objects (Fabric Lakehouse / SQL DW style)

CREATE TABLE bronze.patients (
    PatientID           VARCHAR(20),
    PatientName          VARCHAR(100),
    Gender              VARCHAR(10),
    DOB                 VARCHAR(20),   -- kept as text in Bronze; parsed in Silver
    City                VARCHAR(100),
    InsuranceProvider    VARCHAR(100)
);

CREATE TABLE bronze.doctors (
    DoctorID            VARCHAR(20),
    DoctorName           VARCHAR(100),
    DepartmentID         VARCHAR(20),
    Specialization       VARCHAR(100),
    Experience_Years     VARCHAR(10),
    JoiningDate          VARCHAR(20)
);

CREATE TABLE bronze.departments (
    DepartmentID         VARCHAR(20),
    DepartmentName       VARCHAR(100),
    Location             VARCHAR(100),
    HeadDoctorID          VARCHAR(20)
);

CREATE TABLE bronze.admissions (
    AdmissionID          VARCHAR(20),
    PatientID            VARCHAR(20),
    DoctorID             VARCHAR(20),
    DepartmentID         VARCHAR(20),
    AdmissionDate        VARCHAR(20),
    DischargeDate        VARCHAR(20),
    AdmissionType        VARCHAR(20),
    BedNumber            VARCHAR(20)
);

CREATE TABLE bronze.billing (
    BillingID            VARCHAR(20),
    AdmissionID          VARCHAR(20),
    BillingCategory      VARCHAR(100),
    Amount               VARCHAR(20),   -- text in Bronze; cast to numeric in Silver
    PaymentStatus        VARCHAR(20),
    PaymentDate          VARCHAR(20)
);

/* ============================================================
   Load Bronze tables from CSV (Fabric Lakehouse example using
   COPY INTO — adapt path to your OneLake location)
   ============================================================ */

COPY INTO bronze.patients
FROM 'Files/raw/patients.csv'
WITH (FILE_TYPE = 'CSV', FIRSTROW = 2);

COPY INTO bronze.doctors
FROM 'Files/raw/doctors.csv'
WITH (FILE_TYPE = 'CSV', FIRSTROW = 2);

COPY INTO bronze.departments
FROM 'Files/raw/departments.csv'
WITH (FILE_TYPE = 'CSV', FIRSTROW = 2);

COPY INTO bronze.admissions
FROM 'Files/raw/admissions.csv'
WITH (FILE_TYPE = 'CSV', FIRSTROW = 2);

COPY INTO bronze.billing
FROM 'Files/raw/billing.csv'
WITH (FILE_TYPE = 'CSV', FIRSTROW = 2);

/* ============================================================
   Basic row count validation (Data Quality Check #1)
   ============================================================ */
SELECT 'bronze.patients' AS TableName, COUNT(*) AS RowCount FROM bronze.patients
UNION ALL
SELECT 'bronze.doctors', COUNT(*) FROM bronze.doctors
UNION ALL
SELECT 'bronze.departments', COUNT(*) FROM bronze.departments
UNION ALL
SELECT 'bronze.admissions', COUNT(*) FROM bronze.admissions
UNION ALL
SELECT 'bronze.billing', COUNT(*) FROM bronze.billing;
