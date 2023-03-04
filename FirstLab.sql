drop table н_характеристики_видов_работ;

DROP FUNCTION table_info(character varying);

create table н_свойства_вр
(
    ид numeric(9) primary key
);

create table н_виды_работ
(
    ид numeric(9) primary key
);

create table н_характеристики_видов_работ
(
    свр_ид        numeric(9)
        CONSTRAINT хвр_свр_fk references н_свойства_вр (ид),
    вр_ид         numeric(9)
        CONSTRAINT хвр_вр_fk references н_виды_работ (ид),
    кто_создал    date,
    когда_создал  date,
    кто_изменил   date,
    когда_изменил date
);

create table тестовая_таблица
(
    тест_ид   numeric(9)
        CONSTRAINT внешний_ключ_тест references н_свойства_вр (ид),
    колонка_1 date,
    колонка_2 varchar,
    колонка_3 int
);



CREATE OR REPLACE FUNCTION table_info(name varchar(50))
    RETURNS TABLE
            (
                position_    information_schema.cardinal_number,
                column_name_ information_schema.sql_identifier,
                arguments    text
            )
AS
$$
DECLARE
    var text = current_setting('psql.psqlvar');
BEGIN
    return query SELECT c.ordinal_position,
                        c.column_name,
                        ('Type: ' || data_type || E'\n' ||
                         COALESCE('Constr: ' || kcu.constraint_name || ' References ' || ccu.table_name || '(' ||
                                  ccu.column_name || ')', '')) as Argument
                 FROM information_schema.columns c
                          left join information_schema.key_column_usage kcu
                                    on c.column_name = kcu.column_name
                          left join information_schema.constraint_column_usage AS ccu
                                    on ccu.constraint_name = kcu.constraint_name
                 where c.table_name = var;
END;
$$
    LANGUAGE 'plpgsql';


select *
from table_info('н_характеристики_видов_работ');

select *
from s311745.н_характеристики_видов_работ;

show search_path;

create or replace function get_info_about_table_by_name(table_name varchar)
    returns table
            (
                №             bigint,
                "Имя столбца" name,
                "Аттрибуты"   text
            )
    language plpgsql
as
$$
BEGIN
    return query select row_number() over () as №,
                        columns.attname      as "Имя столбца",
                        concat('Type ', ': ', pt.typname, ' ', E'\n', 'Comment', ': ', pd.description, E'\n',
                               'Constr ', ': ', (case constraints.consrc
                                                     when null then 'Empty'
                                                     else constraints.consrc end),E'\n') as &quot;
    Аттрибуты&quot;
    FROM pg_attribute columns
        inner join pg_class tables
        ON columns.
    attrelid = tables.oid inner join pg_type pt
on columns.
    atttypid = pt.oid left join pg_namespace n on n.
    oid =
            tables.relnamespace left join pg_tablespace t on t.
    oid =
            tables.reltablespace left join pg_description pd on (pd.objoid = tables.oid
and pd.objsubid = columns.attnum)
LEFT JOIN pg_constraint constraints
ON constraints.
    conrelid = columns.attrelid
                   AND
               columns.attnum = ANY (constraints.conkey)
               where tables.relname = table_name
                 and columns.attnum & gt;
    0
and constraints.
    contype = 'c';
end;
$$;


--

-- SELECT c.ordinal_position,
--        c.column_name,
--        data_type,
--        kcu.constraint_name,
--        ccu.table_name,
--        ccu.column_name
-- FROM information_schema.columns c
--          left join information_schema.key_column_usage kcu
--                    on c.column_name = kcu.column_name
--          left join information_schema.constraint_column_usage AS ccu
--                    on ccu.constraint_name = kcu.constraint_name
-- where c.table_name = 'н_характеристики_видов_работ';

-- select table_name from information_schema.constraint_column_usage;
--
-- SELECT con.*
--        FROM pg_catalog.pg_constraint con
--             INNER JOIN pg_catalog.pg_class rel
--                        ON rel.oid = con.conrelid
--             INNER JOIN pg_catalog.pg_namespace nsp
--                        ON nsp.oid = connamespace
--        WHERE nsp.nspname = 's311745'
--              AND rel.relname = 'н_характеристики_видов_работ';

-- SELECT tc.table_schema,
--        tc.constraint_name,
--        tc.table_name,
--        kcu.column_name,
--        ccu.table_schema AS foreign_table_schema,
--        ccu.table_name   AS foreign_table_name,
--        ccu.column_name  AS foreign_column_name
-- FROM information_schema.table_constraints AS tc
--          JOIN information_schema.key_column_usage AS kcu
--               ON tc.constraint_name = kcu.constraint_name
--                   AND tc.table_schema = kcu.table_schema
--          JOIN information_schema.constraint_column_usage AS ccu
--               ON ccu.constraint_name = tc.constraint_name
--                   AND ccu.table_schema = tc.table_schema
-- WHERE tc.constraint_type = 'FOREIGN KEY'
--   AND tc.table_name = 'н_характеристики_видов_работ';
--
-- select count(c.column_name)
-- FROM information_schema.columns c
--          left join information_schema.key_column_usage kcu
--                    on c.column_name = kcu.column_name
--          left join information_schema.constraint_column_usage AS ccu
--                    on ccu.constraint_name = kcu.constraint_name
-- where c.table_name = 'н_характеристики_видов_работ'
--   and kcu.constraint_catalog is not NULL;
--
-- SELECT c.ordinal_position,
--        c.column_name,
--        ('Type: ' || data_type || E'\n' ||
--         COALESCE('Constr: ' || kcu.constraint_name || ' References ' || ccu.table_name || '(' ||
--                  ccu.column_name || ')', '')) as Argument
-- FROM information_schema.columns c
--          left join information_schema.key_column_usage kcu
--                    on c.column_name = kcu.column_name
--          left join information_schema.constraint_column_usage AS ccu
--                    on ccu.constraint_name = kcu.constraint_name
-- where c.table_name = 'н_характеристики_видов_работ';
