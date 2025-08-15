{% macro macros_copy_csv(table_nm) %} 

 

delete from {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }};

 

COPY INTO {{var ('rawhist_db') }}.{{var ('wrk_schema')}}.{{ table_nm }} 

FROM 

(

SELECT

    $1 AS Store,

    $2 AS Dept,

    $3 AS Date1,

    $4 AS Weekly_Sales,

    $5 AS IsHoliday,
    
    CURRENT_TIMESTAMP() AS INSERT_DTS,

    CURRENT_TIMESTAMP() AS UPDATE_DTS,

    metadata$filename AS SOURCE_FILE_NAME,

    metadata$file_row_number AS SOURCE_FILE_ROW_NUMBER

FROM @{{ var('stage_name') }}

)

FILE_FORMAT = {{var ('file_format_csv') }}

PURGE={{ var('purge_status') }}

FORCE = TRUE

;

 

{% endmacro %}