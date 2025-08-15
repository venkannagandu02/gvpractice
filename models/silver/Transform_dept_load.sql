{{ config(materialized='table') }}

SELECT
    STORE_ID,
    DEPT_ID,
    SALES_DATE,
    WEEKLY_SALES,
    IS_HOLIDAY 
FROM {{ source('source', 'WORK_DEPARTMENT_STAGE') }};