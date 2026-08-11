# Business Requirement — Hospital Management Analytics

## Overview
This is a **portfolio/demo project** simulating a hospital analytics platform. 
The goal is to demonstrate an end-to-end data engineering and BI solution 
using Microsoft Fabric and Power BI, built on synthetic (non-real) hospital data.

## Business Context
A hospital network wants a centralized analytics platform to track:
- Patient admissions and discharges
- Doctor and department performance
- Billing and revenue trends
- Bed occupancy and length of stay

## Business Questions to Answer
1. What is the monthly admission trend by department?
2. Which departments generate the highest revenue?
3. What is the average length of stay per department?
4. Which doctors have the highest patient load?
5. What is the bed occupancy rate over time?
6. What is the revenue breakdown by billing category?

## Source Systems (Simulated)
| System | Data | Format |
|---|---|---|
| Patient Registration System | Patient demographics | CSV |
| Admission System | Admission/discharge records | CSV |
| HR System | Doctor details | CSV |
| Hospital Directory | Department details | CSV |
| Billing System | Billing/invoice records | CSV |

## Scope
- Build Bronze → Silver → Gold Medallion Architecture in Microsoft Fabric
- Model data using Star Schema
- Build Power BI dashboard with KPIs
- Implement data quality checks and basic performance optimization

## Out of Scope
- Real patient data (HIPAA/PII) — all data is synthetic
- Real-time streaming (batch-only for this demo)

## Note
⭐ This is a self-built portfolio project using synthetic/demo data to 
demonstrate enterprise-grade Data Engineering and BI practices. It does not 
represent real client or employer work.
