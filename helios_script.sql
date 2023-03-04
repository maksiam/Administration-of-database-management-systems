\prompt 'enter some text: ' psqlvar
\o /dev/null
select set_config('psql.psqlvar', :'psqlvar', false);
\o
select * from table_info('123');
