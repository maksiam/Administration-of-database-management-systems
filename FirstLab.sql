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





CREATE OR REPLACE FUNCTION table_info(name varchar(50))
    RETURNS TABLE
            (
                position_    information_schema.cardinal_number,
                column_name_ information_schema.sql_identifier,
                arguments    text
            )
AS
$$
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
                 where c.table_name = name;
END;
$$
    LANGUAGE 'plpgsql';


select *
from table_info('н_характеристики_видов_работ');
