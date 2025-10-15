# Hevo Assessment I

## Overview
This repository contains deliverables for the Hevo Assessment I, demonstrating a data pipeline from PostgreSQL to Snowflake with transformations for orders and customers.

## Steps to Reproduce
1. **Snowflake Signup**:
   - Created a free trial account at [snowflake.com](https://www.snowflake.com) on AWS US East.
2. **Hevo Signup**:
   - Activated Hevo trial via Snowflake Partner Connect.
3. **Postgres Setup**:
   - Installed PostgreSQL using Docker (`docker run -d --name postgres-hevo -p 5432:5432 -e POSTGRES_PASSWORD=your_password postgres:latest`).
   - Configured logical replication by setting `wal_level=logical`, `max_replication_slots=4`, and `max_wal_senders=4` in `postgresql.conf`.
   - Exposed the local DB to Hevo using ngrok (`./ngrok tcp 5432`) with a dynamic URL (e.g., `tcp://0.tcp.ngrok.io:12345`).
4. **Table Creation & Data Load**:
   - Created tables `customers`, `orders`, and `feedback` in PostgreSQL (see `sql/create_tables.sql`).
   - Loaded data from CSVs using `\copy` command (see `data/`).
5. **Hevo Pipeline**:
   - Set up pipeline: Source=PostgreSQL, Destination=Snowflake, Mode=Logical Replication.
   - Pipeline ID: 1.
6. **Transformations**:
   - Created Hevo Model 2 to generate `order_events` table from `orders` status.
   - Added `username` column to existing `customers` table using `ALTER TABLE` and `UPDATE` in Snowflake, validated via Hevo Model.
7. **Verification**:
   - Validated transformed data in Snowflake (see `sql/validation.sql`).

## Assumptions
- `status` in `orders` is a varchar with values: 'placed', 'shipped', 'delivered', 'cancelled'.
- Emails in `customers` are valid (contain '@') for `username` derivation.
- Added `event_timestamp` to `order_events` for analytics purposes.

## How Postgres Was Connected to Hevo
- Used ngrok to expose the local PostgreSQL instance (running on port 5432) to the internet.
- Configured Hevo pipeline with ngrok host (e.g., `0.tcp.ngrok.io`) and port (e.g., `12345`), along with PostgreSQL credentials (stored securely outside repo).

## Choices Made for Transformations
- Chose to add `username` to the existing `customers` table instead of creating a new table, using `ALTER TABLE` and `UPDATE` for efficiency.
- Created `order_events` as a separate table to map `status` to `event_type` for event-based analytics.
- Used `CURRENT_TIMESTAMP()` for `event_timestamp` to track event creation time.

## Issues/Workarounds During Setup
- **Ngrok URL Changes**: The free ngrok tier regenerates URLs; manually updated the Hevo pipeline source configuration when the URL changed.
- **Snowflake DDL Restriction**: Hevo Model rejected `CREATE OR REPLACE TABLE`; used `SELECT` for transformation logic and manual `ALTER TABLE`/`UPDATE` for `customers`.
- **Initial Sync Delay**: Waited for Hevo to complete the initial data sync before applying transformations.

## Hevo Details
- Name: Sasidharan_M
- Pipeline ID: 1
- Model Number: 2 & 3

## Loom Video
https://www.loom.com/share/ba0b0a9d71ba4a2786af43b44b99b0c3?sid=c8efcbee-3b32-402c-8767-40faf01120f8

## Files
- `sql/create_tables.sql`: PostgreSQL DDL for table creation.
- `sql/transformations.sql`: Hevo Model transformation scripts.
- `sql/validation.sql`: Snowflake validation queries.
- `data/customers.csv`, `data/orders.csv`, `data/feedback.csv`: Sample CSV data (or link to provided repo).
- `screenshots/`: Optional screenshots of Hevo UI (e.g., pipeline setup, model execution).