# Google Merchandise Shop Analytics Project

## Overview

This repository contains files and resources for the Google Merchandise Shop analytics project. The project involves analyzing data from the Google Merchandise Shop and presenting key insights through a comprehensive Looker Studio dashboard. The main tools used in this project are Looker Studio and BigQuery.

## Contents

- [Google Merchandise Shop Dashboard in Looker Studio](https://lookerstudio.google.com/reporting/eb43d778-7198-4499-8024-a6f1971c7a5b): An interactive dashboard created in Looker Studio that provides charts and numbers showcasing the analysis.
- `PA_SQL_Queries.sql`: A collection of SQL queries used to retrieve data for the analysis.
- `Google Merchandise Shop Dashboard - December.pdf`: A PDF version of the dashboard for December.
- `Google Merchandise Shop Dashboard - Whole Period.pdf`: A PDF version of the dashboard covering the entire analysis period.
- `raw_events_preview.csv`: A preview of the raw events data used in the analysis.
- `raw_events_schema.csv`: The schema of the raw events data.
- [raw_events_distinct_column_values](https://docs.google.com/spreadsheets/d/1D45k0bMtuBluu9OPN0YbvjzH2cJSXQGaJgKoR53afDE/edit?usp=sharing): A Google Sheets file exploring the distinct values available in the raw events table columns.

## Files

### Google Merchandise Shop Dashboard in Looker Studio

The Looker Studio dashboard provides interactive visualisations of the data analysed in this project. The dashboard includes various charts and graphs that offer insights into user behaviour, revenue trends, and conversion metrics.

The main areas covered in the dashboard include:
- Summary of total revenue, orders count, unique users, event count, and conversion rates.
- Insights into user engagement metrics such as average session duration and traffic sources, including organic search, direct visits, and campaign performance.
- Detailed view of the conversion funnel, from session starts to complete purchases, with segmentation by browser versions on Apple devices.
- Analysis of user interactions by device category (desktop, mobile, tablet) and geographical distribution of traffic.

### PA_SQL_Queries.sql

This file contains the SQL queries used to extract and process data from the raw_events dataset. Key queries include:
- Verifying Event Timestamp vs. User First Touch Timestamp
- Checking MIN and MAX Event Timestamp
- Selecting Necessary Data
- DCalculating Average Session Duration
- Validating Session Duration for a User
- Partial Check of Session Duration Count
- Calculating the Average Time to Purchase
- Validating Conversion Rate
- Browser Version Funnel Analysis
- Total Unique Events Funnel Analysis
- Checking Campaigns Time

### raw_events_distinct_column_values

A Google Sheets file listing the distinct values available in the raw events data. Exploring this data structure helps prepare for detailed analysis.

## Getting Started

To view and interact with the resources, follow these steps:

1. Access the [Google Merchandise Shop Dashboard in Looker Studio](https://lookerstudio.google.com/reporting/eb43d778-7198-4499-8024-a6f1971c7a5b) using the provided link to explore the interactive visualizations.
2. Review the PDF versions of the dashboard for December and the whole period to see static representations of the analysis.
3. Use the SQL queries in `PA_SQL_Queries.sql` to replicate the data retrieval and analysis process.
4. Refer to `raw_events_preview.csv` and `raw_events_schema.csv` to understand the structure of the raw events data.
5. Explore [raw_events_distinct_column_values](https://docs.google.com/spreadsheets/d/1D45k0bMtuBluu9OPN0YbvjzH2cJSXQGaJgKoR53afDE/edit?usp=sharing) to understand the distinct values in the raw events data.

---

By following these guidelines and utilising the provided resources, you can gain comprehensive insights into the Google Merchandise Shop's performance and devise strategies for improvement.
