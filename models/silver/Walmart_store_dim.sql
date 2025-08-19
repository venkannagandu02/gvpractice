{{ 
    config(
        materialized='incremental',
        incremental_strategy='merge',
        unique_key='STORE_ID',
        merge_exclude_columns=['INSERT_DTS']
    ) 
}}

with WORK_DEPARTMENT_STAGE as (

    select
        S.STORE_ID,
        S.DEPT_ID as DEPARTMENT_ID,
        D.STORE_TYPE,
        D.STORE_SIZE,
        current_timestamp() as INSERT_DTS,
        current_timestamp() as UPDATE_DTS
    from {{ source('DEPT','WORK_DEPARTMENT_STAGE') }} S
    left join {{ source('STORE','STORE_STAGE') }} D
        on S.STORE_ID = D.STORE_ID
)

select *
from WORK_DEPARTMENT_STAGE
{% if is_incremental() %}
  -- only update changed records (SCD1)
  where WORK_DEPARTMENT_STAGE.STORE_ID not in (
        select STORE_ID
        from {{ this }}
        where DEPARTMENT_ID      = WORK_DEPARTMENT_STAGE.DEPARTMENT_ID
          and STORE_TYPE         = WORK_DEPARTMENT_STAGE.STORE_TYPE
          and STORE_SIZE         = WORK_DEPARTMENT_STAGE.STORE_SIZE
  )
{% endif %}
