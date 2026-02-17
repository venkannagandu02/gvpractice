
{% snapshot walmart_fact_table %}

{{
    config(
        strategy='check',
        unique_key=['date_id','store_id','dept_id'],
        check_cols=[
            'DATE_ID',
            'STORE_ID',
            'DEPT_ID',
            'STORE_SIZE',
            'STORE_WEEKLY_SALES',
            'FUEL_PRICE',
            'TEMPERATURE',
            'UNEMPLOYMENT',
            'CPI',
            'MARKDOWN1',
            'MARKDOWN2',
            'MARKDOWN3',
            'MARKDOWN4',
            'MARKDOWN5'
        ],
        target_schema='SILVER' 
    )
}}

with fact as (

    select
        F.SALES_DATE as DATE_ID, 
        S.STORE_ID, 
        D.DEPT_ID,
        S.STORE_SIZE,
        D.WEEKLY_SALES as STORE_WEEKLY_SALES,
        F.FUEL_PRICE,
        F.TEMPERATURE,
        F.UNEMPLOYMENT,
        F.CPI,
        F.MARKDOWN1,
        F.MARKDOWN2,
        F.MARKDOWN3,
        F.MARKDOWN4,
        F.MARKDOWN5,
        current_timestamp() as INSERT_DTS
    from {{ source('FACT','FACT_DATA') }} F
    left join {{ source('DEPT','WORK_DEPARTMENT_STAGE') }} D
        on F.STORE_ID = D.STORE_ID
    left join {{ source('STORE','STORE_STAGE') }} S
        on S.STORE_ID = F.STORE_ID

)

select * from fact

{% endsnapshot %}