{% macro copy_department_csv() %}
COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.WORK_DEPARTMENT_STAGE 
FROM (
    SELECT
        $1::INT AS STORE_ID,
        $2::INT AS DEPT_ID,
        $3::DATE AS SALES_DATE,
        $4::NUMBER(10,2) AS WEEKLY_SALES,
        $5::BOOLEAN AS IS_HOLIDAY
    FROM @{{ var('stage_name') }}
)
FILE_FORMAT = (FORMAT_NAME = {{ var('file_format_csv') }})
PATTERN = 'department.csv'
PURGE = {{ var('purge_status') }}
FORCE = TRUE;
{% endmacro %}

{% macro copy_fact_data_csv() %}
COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.FACT_DATA 
FROM (
    SELECT
        $1::INT AS STORE_ID,
        $2::DATE AS SALES_DATE,
        $3::FLOAT AS TEMPERATURE,
        $4::FLOAT AS FUEL_PRICE,
        $5::FLOAT AS MARKDOWN1,
        $6::FLOAT AS MARKDOWN2,
        $7::FLOAT AS MARKDOWN3,
        $8::FLOAT AS MARKDOWN4,
        $9::FLOAT AS MARKDOWN5,
        $10::FLOAT AS CPI,
        $11::FLOAT AS UNEMPLOYMENT,
        $12::BOOLEAN AS ISHOLIDAY
    FROM @{{ var('stage_name') }}
)
FILE_FORMAT = (FORMAT_NAME = {{ var('file_format_csv') }})
PATTERN = 'fact_data.csv'
PURGE = {{ var('purge_status') }}
FORCE = TRUE;
{% endmacro %}


{% macro copy_store_stage_csv() %}
COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.STORE_STAGE 
FROM (
    SELECT
        $1::INT AS STORE_ID,
        $2::VARCHAR AS STORE_TYPE,
        $3::INT AS STORE_SIZE
    FROM @{{ var('stage_name') }}
)
FILE_FORMAT = (FORMAT_NAME = {{ var('file_format_csv') }})
PATTERN = 'store_stage.csv'
PURGE = {{ var('purge_status') }}
FORCE = TRUE;
{% endmacro %}
