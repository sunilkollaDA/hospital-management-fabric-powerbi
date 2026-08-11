# 🏥 Hospital Management Analytics — Microsoft Fabric + Power BI

> ⭐ **Portfolio/demo project** built with synthetic data to demonstrate an 
> end-to-end Data Engineering + BI solution, modeled on a real-world 
> Azure Data Factory → Microsoft Fabric migration pattern for healthcare analytics.

---

## 1. Project Title
**Hospital Management Analytics — ADF to Microsoft Fabric Migration & Power BI Reporting**

## 2. Business Problem
A hospital network relies on fragmented source systems (EMR/HIS, Lab, 
Pharmacy, Billing, HR) and an aging Azure Data Factory ETL setup. Leadership 
lacks a single, governed platform to track admissions, revenue, bed 
occupancy, and doctor performance in near real time.

## 3. Objective
Design and build a modern Lakehouse analytics platform on **Microsoft 
Fabric**, migrating existing ADF pipelines, applying **Medallion 
Architecture** (Bronze/Silver/Gold), modeling a **Star Schema**, and 
delivering **Power BI dashboards** for executive, clinical, and financial 
decision-making.

## 4. Architecture
Full architecture with Mermaid diagrams: [`docs/architecture.md`](docs/architecture.md)

Hospital Source Systems → Azure Data Factory (existing) → Migration Assessment
→ Microsoft Fabric Data Factory → OneLake → Lakehouse (Bronze → Silver → Gold)
→ Fabric Data Warehouse (Star Schema) → Power BI Semantic Model → Dashboards

## 5. Technologies Used
| Category | Tools |
|---|---|
| Data Platform | Microsoft Fabric, OneLake, Lakehouse, Fabric Warehouse |
| Cloud (legacy) | Azure Data Factory, ADLS Gen2 |
| Languages | SQL, Python, PySpark |
| BI | Power BI Desktop, Power BI Service, Power Query, DAX |
| Version Control | Git, GitHub |

## 6. Dataset
Synthetic hospital data (5 CSV files) simulating: Patients, Doctors, 
Departments, Admissions, Billing → [`data/raw/`](data/raw/)

## 7. Data Flow
1. Raw CSVs ingested into **Bronze** (as-is)
2. **Silver**: cleaned, deduplicated, validated, type-cast
3. **Gold**: modeled into Star Schema (Fact + Dimension tables)
4. Power BI connects to Gold layer via semantic model

## 8. Implementation
| Layer | Script |
|---|---|
| Bronze | [`sql/bronze/bronze_layer_scripts.sql`](sql/bronze/bronze_layer_scripts.sql) |
| Silver | [`sql/silver/silver_layer_scripts.sql`](sql/silver/silver_layer_scripts.sql) |
| Gold | [`sql/gold/gold_layer_scripts.sql`](sql/gold/gold_layer_scripts.sql) |
| DAX / Power BI | [`powerbi/dax-measures.md`](powerbi/dax-measures.md) |

## 9. Data Model
**Star Schema** — `DimPatient`, `DimDoctor`, `DimDepartment`, `DimDate` 
(dimensions) + `FactAdmissions`, `FactBilling` (facts). 
Full ER diagram in [`powerbi/dax-measures.md`](powerbi/dax-measures.md).

## 10. SQL / Python / PySpark
See [`sql/`](sql/) folder for Bronze/Silver/Gold transformation scripts 
covering deduplication, NULL handling, type casting, and referential 
integrity checks.

## 11. Power BI
Dashboard pages designed:
- **Executive** — Total Patients, Revenue, Occupancy, Profit
- **Patient** — Admissions, Discharges, Length of Stay, Readmissions
- **Clinical** — Diagnosis Trends, Lab Results
- **Finance** — Revenue, Claims, Outstanding Payments
- **Operations** — Bed Utilization, Doctor Performance

DAX measures: [`powerbi/dax-measures.md`](powerbi/dax-measures.md)

## 12. Business KPIs
Total Patients · Total Revenue · Avg Length of Stay · Bed Occupancy % · 
Emergency Admission % · Revenue Growth % (MoM) · Outstanding Payments

## 13. Challenges
- Handling inconsistent date formats and NULLs across simulated source systems
- Designing a star schema that supports both clinical and financial reporting without excessive relationship complexity
- Mapping legacy ADF components to their Fabric equivalents

## 14. Solutions
- Used `TRY_CAST` + `COALESCE` in Silver layer for safe type conversion and default handling
- Adopted conformed dimensions (`DimDepartment` shared across Fact tables) to avoid duplicate logic
- Documented ADF → Fabric component mapping table (see architecture doc)

## 15. Performance Optimization
- Star schema (not snowflake) to reduce relationship hops
- Marked `DimDate` as official Date Table for Time Intelligence
- Used DAX measures over calculated columns where possible
- `DIVIDE()` used throughout to avoid divide-by-zero errors

## 16. Security
- Row-Level Security (RLS) scoped by department head (`USERPRINCIPALNAME()`)
- Referential integrity enforced in Silver layer

## 17. Results
A fully governed, layered analytics pipeline — from raw synthetic hospital 
data to an executive-ready Power BI reporting layer — demonstrating the 
same architecture pattern used in real ADF-to-Fabric healthcare migrations.

## 18. Interview Explanation

**30-second version:**
"I built an end-to-end hospital analytics platform on Microsoft Fabric, 
migrating from a legacy Azure Data Factory setup. I implemented Medallion 
Architecture — Bronze, Silver, Gold — modeled a star schema, and built 
Power BI dashboards with DAX measures covering revenue, occupancy, and 
patient KPIs."

**1-minute version:**
Adds: source systems simulated (EMR, Lab, Billing, Pharmacy), ADF→Fabric 
component mapping, Silver layer data quality logic (dedup, NULL handling, 
referential integrity).

**3-minute version:**
Adds: full data model relationships, RLS implementation, Time Intelligence 
DAX (MTD/YTD/growth), performance optimization decisions, and governance 
considerations (Purview, RBAC).

**5-minute version:**
Walks through each layer live with actual SQL, explains grain of each fact 
table, discusses trade-offs (why star over snowflake), and connects it to 
real production concerns (incremental refresh, monitoring, deployment pipelines).

## 19. Future Improvements
- Add PySpark notebook for Bronze→Silver transformation (Fabric Notebooks)
- Implement incremental load using watermark columns
- Add Direct Lake mode Power BI connection
- Expand synthetic dataset to 500+ records via Python Faker library
- Add automated data quality tests (Great Expectations)

---

## 📁 Repository Structure

hospital-management-fabric-powerbi/
├── docs/
│ ├── business-requirement.md
│ └── architecture.md
├── data/raw/
│ ├── patients.csv
│ ├── doctors.csv
│ ├── departments.csv
│ ├── admissions.csv
│ └── billing.csv
├── sql/
│ ├── bronze/bronze_layer_scripts.sql
│ ├── silver/silver_layer_scripts.sql
│ └── gold/gold_layer_scripts.sql
└── powerbi/
└── dax-measures.md

---

⭐ *This is a self-built portfolio project using synthetic data, created to 
demonstrate enterprise-grade Data Engineering and Power BI practices. It 
does not represent real client, employer, or patient data.*
