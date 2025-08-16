{{ config(
    materialized='table',
    transient=true,
    alias='WORK_DEPARTMENT_TRANSFORM',
    schema='BRONZE',
    pre_hook=macros_copy_csv('WORK_DEPARTMENT_STAGE')
) }}

with WORK_DEPARTMENT_STAGE as (
    select 
        STORE_ID,
        DEPT_ID,
        SALES_DATE,
        WEEKLY_SALES,
        IS_HOLIDAY
    from {{ source('source', 'WORK_DEPARTMENT_STAGE') }}
)

select * 
from WORK_DEPARTMENT_STAGE