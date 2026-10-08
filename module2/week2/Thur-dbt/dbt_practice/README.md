# Olist dbt Practice

This project is a classroom-friendly dbt practice case inspired by the Olist e-commerce dataset.
It uses PostgreSQL + dbt Core via the `dbt-postgres` adapter.

## Practice Goal

Build an analytics layer from raw e-commerce tables:

```text
raw CSV seeds
   -> sources
   -> staging models
   -> intermediate models
   -> mart models
   -> tests + docs
```

## Tables

Raw seed tables:

- `raw_customers`: one row per customer
- `raw_orders`: one row per order
- `raw_order_items`: one row per item inside an order
- `raw_products`: one row per product
- `raw_payments`: one row per payment record
- `raw_reviews`: one row per review

Main mart outputs:

- `analytics.mart_orders`
- `analytics.mart_monthly_revenue`
- `analytics.mart_category_performance`
- `analytics.mart_delivery_performance`
- `analytics.mart_review_delivery_analysis`
- `analytics.mart_payment_summary`
- `analytics.mart_state_monthly_kpi`

## Requirements

Students should already have:

- Python
- PostgreSQL
- VS Code
- PowerShell on Windows

## 1. Create PostgreSQL database and schemas

Connect to the default `postgres` database and run:

```sql
CREATE DATABASE sql_transform_practice;
```

Then connect to the `sql_transform_practice` database and run:

```sql
CREATE SCHEMA IF NOT EXISTS raw;
CREATE SCHEMA IF NOT EXISTS analytics;
```

The same SQL is available in:

- `scripts/init_database.sql`
- `scripts/init_schemas.sql`

## 2. Setup dbt environment

Open PowerShell in this project folder and run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\setup_dbt_postgres.ps1
```

If your PostgreSQL password is not `postgres`, run:

```powershell
.\scripts\setup_dbt_postgres.ps1 `
  -PgUser "postgres" `
  -PgPassword "your_password" `
  -PgDatabase "sql_transform_practice"
```

## 3. Run the full dbt pipeline

```powershell
.\scripts\run_dbt.ps1
```

This runs:

```bash
dbt debug
dbt seed --full-refresh
dbt compile
dbt run
dbt test
dbt docs generate
```

## 4. Run selected models manually

After activating the virtual environment:

```powershell
.\.venv\Scripts\Activate.ps1
```

You can run individual models:

```bash
dbt run --select stg_orders
dbt run --select int_orders_enriched
dbt run --select mart_monthly_revenue
dbt run --select mart_category_performance
dbt test --select mart_monthly_revenue
```

## 5. Run the business reconciliation test

The project includes a singular dbt test in:

```text
tests/assert_order_payment_reconciliation.sql
```

Business rule:

```text
total_payment_value = order_revenue + freight_value
```

Run only this test with:

```bash
dbt test --select assert_order_payment_reconciliation
```

The test passes when the SQL query returns **0 rows**. Any returned row is an order whose payment does not reconcile with item revenue plus freight.


## 6. Check output in PostgreSQL

```sql
SELECT * FROM analytics.mart_monthly_revenue;
SELECT * FROM analytics.mart_category_performance;
SELECT * FROM analytics.mart_delivery_performance;
SELECT * FROM analytics.mart_review_delivery_analysis;
SELECT * FROM analytics.mart_payment_summary;
SELECT * FROM analytics.mart_state_monthly_kpi;
```

## 7. Troubleshooting

| Problem | Likely reason | Fix |
|---|---|---|
| `dbt` command not found | Virtual environment is not activated | Run `.\.venv\Scripts\Activate.ps1` |
| `password authentication failed` | Wrong PostgreSQL password | Re-run setup script with `-PgPassword` |
| `database does not exist` | Database was not created | Run `scripts/init_database.sql` |
| `relation does not exist` | Seeds or models were not built | Run `dbt seed` then `dbt run` |
| Raw tables are not in `raw` schema | Schema macro missing or project changed | Check `macros/generate_schema_name.sql` |

## Teaching Notes

This project is designed for a guided practice section. Suggested flow:

1. `dbt seed` to load raw tables
2. inspect raw tables in PostgreSQL
3. build staging models
4. build intermediate models
5. build marts
6. run generic tests from `schema.yml`
7. run the singular payment reconciliation test from `tests/`
8. generate docs
9. review the final solution models/tests and compare outputs in PostgreSQL or dbt Docs
