"""
===============================================================================
ETL Script: Load Bronze Layer (PostgreSQL)
===============================================================================

Script Purpose:
    This script performs automated ingestion of raw source data into the
    PostgreSQL 'bronze' schema as part of a data warehouse pipeline.

    It implements a truncate-and-load strategy for all bronze tables by:
      - Truncating existing data in each bronze table
      - Loading CSV files from source CRM and ERP directories using PostgreSQL COPY
      - Recording per-table ETL execution metrics (duration, row counts)
        into the audit.etl_log table for observability

Source Systems:
    - CRM source files (datasets/source_crm)
    - ERP source files (datasets/source_erp)
    
Execution:
    - Designed to be run repeatedly (manual or scheduled)
    - Safe to rerun due to truncate-and-load behavior
    - Intended to be automated via OS scheduler or orchestration too

===============================================================================
"""

from datetime import datetime 
import psycopg2
import os

# ---------- DATABASE CONFIG ----------
DB_CONFIG = {
    "dbname": "datawarehouse",
    "user": "postgres",
    "password": "sam35",
    "host": "localhost",
    "port": 5432
}

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

CRM_PATH = os.path.join(PROJECT_ROOT, "datasets", "source_crm")
ERP_PATH = os.path.join(PROJECT_ROOT, "datasets", "source_erp")

# ---------- FILE → TABLE MAPPING ----------
CRM_FILES = {
    "cust_info.csv": "bronze.crm_cust_info",
    "prd_info.csv": "bronze.crm_prd_info",
    "sales_details.csv": "bronze.crm_sales_details"
}

ERP_FILES = {
    "cust_az12.csv": "bronze.erp_cust_az12",
    "loc_a101.csv": "bronze.erp_loc_a101",
    "px_cat_g1v2.csv": "bronze.erp_px_cat_g1v2"
}

def log_etl (cur, table, phase, start, end, rows):
    cur.execute("""
        INSERT INTO audit.etl_log
        (table_name, phase, start_time, end_time, duration_seconds, rows_loaded)
        VALUES (%s,%s,%s,%s,%s,%s)
    """,(
        table,
        phase,
        start,
        end,
        (end-start).total_seconds(),
        rows
    ))

print(f"🔄 Loading Bronze Layer\n")

def load_files(cur, base_path, mapping):
    for file, table in mapping.items():
        file_path = os.path.join(base_path, file)

        # ---------- TRUNCATE ----------
        print(f">> Truncating Table :  {table}")
        t_start = datetime.now()
        cur.execute(f"TRUNCATE TABLE {table}")
        t_end = datetime.now()

        log_etl(cur,table,"TRUNCATE",t_start,t_end,0)

        # ---------- LOAD ----------
        print(f">> Inserting Data into :  {table}")
        l_start = datetime.now()
        with open(file_path, "r", encoding="utf-8") as f:
            cur.copy_expert(
                f"COPY {table} FROM STDIN WITH CSV HEADER",
                f
            )
        l_end = datetime.now()

        # ---------- ROW COUNT ----------
        cur.execute(f"SELECT COUNT(*) FROM {table}")
        rows = cur.fetchone()[0]

        log_etl(cur,table,"LOAD",l_start,l_end,rows)

        print(
            f"({rows}) rows affected \n"
            f">> Truncate Duration={(t_end - t_start).total_seconds():.2f}s \n"
            f">> Load Duration={(l_end - l_start).total_seconds():.2f}s\n"
        )

def load_bronze():
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()

    load_files(cur, CRM_PATH, CRM_FILES)
    load_files(cur, ERP_PATH, ERP_FILES)

    conn.commit()
    cur.close()
    conn.close()

    print("Bronze ETL completed")

if __name__ == "__main__":
    load_bronze()

