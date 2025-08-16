{% macro macros_copy_csv(table_nm) %} 

delete from {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }};

COPY INTO {{ var('rawhist_db') }}.{{ var('wrk_schema') }}.{{ table_nm }} 
FROM (
    SELECT
        $1::INT    AS STORE_ID,
        $2::INT    AS DEPT_ID,
        $3::DATE   AS SALES_DATE,
        $4::NUMBER(10,2) AS WEEKLY_SALES,
        $5::BOOLEAN AS IS_HOLIDAY
    FROM @{{ var('stage_name') }}
)
FILE_FORMAT = (FORMAT_NAME = {{ var('file_format_csv') }})
PATTERN = 'department.csv' 
PURGE = {{ var('purge_status') }}
FORCE = TRUE;

{% endmacro %}