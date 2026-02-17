{{
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='date_id',
        merge_exclude_columns=['insert_date'],
        pre_hook=[
            copy_department_csv(),
            copy_fact_data_csv(),
            copy_store_stage_csv()
        ],
        schema='SILVER'
    )
}}

with base as (

    -- Pull distinct dates from Department Stage
    select distinct
        s.SALES_DATE as store_date,
        case when s.IS_HOLIDAY = TRUE then 'Y' else 'N' end as is_holiday
    from {{ source('bronze', 'work_department_stage') }} s

    union distinct

    -- Pull distinct dates from Fact Data
    select distinct
        f.SALES_DATE as store_date,
        case when f.ISHOLIDAY = TRUE then 'Y' else 'N' end as is_holiday
    from {{ source('bronze', 'fact_data') }} f
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
from with_ids w

{% if is_incremental() %}
  where not exists (
        select 1
        from {{ this }} t
        where t.store_date = w.store_date
          and t.is_holiday = w.is_holiday
  )
{% endif %}
