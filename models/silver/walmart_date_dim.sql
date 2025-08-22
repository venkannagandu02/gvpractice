{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='date_id',
        merge_exclude_columns=['insert_date'],
        pre_hook=macros_copy_csv('WORK_DEPARTMENT_STAGE'),
        schema='SILVER'
    )
}}

with base as (

    -- Pull distinct dates from Department Stage
    select distinct
        s.sales_date as store_date,
        case when s.is_holiday = TRUE then 'Y' else 'N' end as is_holiday
    from {{ source('DEPT','WORK_DEPARTMENT_STAGE') }} s

    union distinct

    -- Pull distinct dates from Fact Data
    select distinct
        f.sales_date as store_date,
        case when f.isHoliday = TRUE then 'Y' else 'N' end as is_holiday
    from {{ source('FACT','FACT_DATA') }} f
),

with_ids as (
    select
        row_number() over (order by store_date) as date_id,
        store_date,
        is_holiday,
        current_timestamp() as insert_date,
        current_timestamp() as update_date
    from base
)

select *
from with_ids

{% if is_incremental() %}
  where not exists (
        select 1
        from {{ this }} t
        where t.store_date = with_ids.store_date
          and t.is_holiday = with_ids.is_holiday
  )
{% endif %}
