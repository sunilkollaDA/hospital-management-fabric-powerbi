# Architecture — Hospital Management Analytics (ADF → Microsoft Fabric Migration)

> ⭐ Portfolio/demo project simulating a real-world ADF-to-Fabric migration 
> pattern for a hospital analytics platform. Built with synthetic data.

## End-to-End Flow

```mermaid
flowchart TD
    A[Hospital Source Systems<br/>EMR/HIS, LIS, RIS, Pharmacy, Billing, HR, IoT] --> B[Azure Data Factory<br/>Existing ETL]
    B --> C[Migration Assessment<br/>& Planning]
    C --> D[Microsoft Fabric<br/>Data Factory Pipelines]
    D --> E[OneLake<br/>Central Storage]
    E --> F[Lakehouse<br/>Bronze Layer]
    F --> G[Lakehouse<br/>Silver Layer]
    G --> H[Lakehouse<br/>Gold Layer]
    H --> I[Fabric Data Warehouse<br/>Star Schema]
    I --> J[Power BI<br/>Semantic Model]
    J --> K[Power BI Dashboards]
    K --> L[Hospital Management<br/>Decision Making]
```

## Source Systems (Simulated)
- Electronic Medical Records (EMR/HIS)
- Patient Registration
- Laboratory Information System (LIS)
- Radiology System (RIS)
- Pharmacy Management
- Billing & Insurance
- HR & Payroll
- Appointment Scheduling

## ADF → Fabric Component Mapping

| Azure Data Factory | Microsoft Fabric |
|---|---|
| Pipeline | Fabric Data Factory Pipeline |
| Copy Activity | Copy Activity |
| Mapping Data Flow | Dataflow Gen2 |
| Dataset | OneLake / Lakehouse |
| Linked Service | Fabric Connection |
| Integration Runtime | Managed Gateway |
| Trigger | Schedule / Event Trigger |
| Monitoring | Fabric Monitoring Hub |

## Medallion Architecture (Lakehouse)

**Bronze Layer** — Raw data as-is
- patients.csv, admissions.csv, billing.csv, lab.csv, doctors.csv

**Silver Layer** — Cleaned & validated
- Remove duplicates
- Handle NULL values
- Standardize date/ID formats
- Validate patient IDs

**Gold Layer** — Business-ready, star schema
- `FactPatientVisits`, `FactBilling`, `FactPharmacySales`
- `DimPatient`, `DimDoctor`, `DimDepartment`, `DimDate`

## Data Warehouse — Star Schema

**Fact Tables**: FactAdmissions, FactBilling, FactLabTests, FactPharmacy, FactAppointments
**Dimension Tables**: DimPatient, DimDoctor, DimDepartment, DimDate, DimDiagnosis, DimInsurance

## Semantic Model — Key Measures
- Total Patients
- Revenue
- Bed Occupancy %
- Average Length of Stay
- Readmission Rate
- Pharmacy Revenue

Security: **Row-Level Security (RLS)**, **Incremental Refresh**

## Power BI Dashboards
| Dashboard | KPIs |
|---|---|
| Executive | Total Patients, Revenue, Occupancy, Profit |
| Patient | Admissions, Discharges, Length of Stay, Readmissions |
| Clinical | Diagnosis Trends, Lab Results, Infection Rate |
| Finance | Revenue, Claims, Outstanding Payments |
| Operations | Bed Utilization, Doctor Performance, OT Usage |

## Deployment Flow
```mermaid
flowchart LR
    Dev[Development] --> Test[Test] --> Prod[Production]
```
Configured with: Scheduled Refresh, Deployment Pipelines, Monitoring, Alerts

## Governance & Monitoring
- Microsoft Fabric Monitoring Hub — pipeline runs, refresh failures, capacity usage
- Microsoft Purview — data lineage, sensitivity labels
- RBAC (Role-Based Access Control)

---
⭐ *This architecture mirrors a real-world ADF-to-Fabric migration pattern for 
hospital analytics, built here as a self-contained portfolio project using 
synthetic data — not real client/employer data.*
