/* ============================================================
   GOLD LAYER — Business-Ready Star Schema
   Purpose: Dimension + Fact tables optimized for Power BI
   reporting (Direct Lake / Import mode).
   ============================================================ */

/* ============================================================
   DIMENSION TABLES
   ============================================================ */

-- DimPatient
CREATE TABLE gold.DimPatient AS
SELECT
    PatientID,
    PatientName,
    Gender,
    DOB,
    DATEDIFF(YEAR, DOB, GETDATE())          AS Age,
    City,
    InsuranceProvider
FROM silver.patients;

-- DimDoctor
CREATE TABLE gold.DimDoctor AS
SELECT
    d.DoctorID,
    d.DoctorName,
    d.DepartmentID,
    dept.DepartmentName,
    d.Specialization,
    d.Experience_Years,
    d.JoiningDate
FROM silver.doctors d
LEFT JOIN silver.departments dept ON d.DepartmentID = dept.DepartmentID;

-- DimDepartment
CREATE TABLE gold.DimDepartment AS
SELECT
    DepartmentID,
    DepartmentName,
    Location,
    HeadDoctorID
FROM silver.departments;

-- DimDate (standard date dimension, 2024-2026 range)
CREATE TABLE gold.DimDate AS
WITH DateSeries AS (
    SELECT CAST('2024-01-01' AS DATE) AS CalendarDate
    UNION ALL
    SELECT DATEADD(DAY, 1, CalendarDate)
    FROM DateSeries
    WHERE CalendarDate < '2026-12-31'
)
SELECT
    CalendarDate                             AS DateKey,
    YEAR(CalendarDate)                       AS Year,
    MONTH(CalendarDate)                      AS MonthNumber,
    FORMAT(CalendarDate, 'MMMM')             AS MonthName,
    DATEPART(QUARTER, CalendarDate)          AS Quarter,
    DATENAME(WEEKDAY, CalendarDate)          AS DayName,
    CASE WHEN DATEPART(WEEKDAY, CalendarDate) IN (1,7)
         THEN 1 ELSE 0 END                   AS IsWeekend
FROM DateSeries
OPTION (MAXRECURSION 0);

/* ============================================================
   FACT TABLES
   ============================================================ */

-- FactAdmissions
CREATE TABLE gold.FactAdmissions AS
SELECT
    a.AdmissionID,
    a.PatientID,
    a.DoctorID,
    a.DepartmentID,
    a.AdmissionDate,
    a.DischargeDate,
    a.AdmissionType,
    a.BedNumber,
    a.LengthOfStay_Days
FROM silver.admissions a;

-- FactBilling
CREATE TABLE gold.FactBilling AS
SELECT
    b.BillingID,
    b.AdmissionID,
    a.PatientID,
    a.DepartmentID,
    b.BillingCategory,
    b.Amount,
    b.PaymentStatus,
    b.PaymentDate
FROM silver.billing b
LEFT JOIN silver.admissions a ON b.AdmissionID = a.AdmissionID;

/* ============================================================
   GOLD LAYER — Business KPI Validation Queries
   (These map directly to Power BI DAX measures later)
   ============================================================ */

-- Total Revenue
SELECT SUM(Amount) AS TotalRevenue FROM gold.FactBilling WHERE PaymentStatus = 'Paid';

-- Average Length of Stay by Department
SELECT
    dept.DepartmentName,
    AVG(f.LengthOfStay_Days) AS AvgLengthOfStay
FROM gold.FactAdmissions f
JOIN gold.DimDepartment dept ON f.DepartmentID = dept.DepartmentID
GROUP BY dept.DepartmentName
ORDER BY
