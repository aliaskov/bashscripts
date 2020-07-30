SELECT
table_schema 'Database',
SUM(data_length + index_length) AS 'DBSize',
SUM(TABLE_ROWS) AS DBRows,
SUM(AUTO_INCREMENT) AS DBAutoIncCount
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'mysql', 'performance_schema')
GROUP BY table_schema;


SELECT s.schema_name, t.table_name 
FROM INFORMATION_SCHEMA.schemata AS s 
  LEFT JOIN INFORMATION_SCHEMA.tables AS t 
    ON t.table_schema = s.schema_name 
-- optional, to hide system databases and tables
-- WHERE s.schema_name NOT IN ('information_schema', 'mysql', 'performance_schema')
ORDER BY schema_name, table_name ;

SET @db = '';
SELECT db,tb FROM
(SELECT @tb := IF(@db=table_schema,table_name,'') tb,
IF(@db=table_schema,'',table_schema) db,
(@db := table_schema) unused FROM information_schema.tables) A;

##The following query produces a(nother) query that will get the value of count(*) for every table, from every schema, listed in information_schema.tables. The entire result of the query shown here - all rows taken together - comprise a valid SQL statement ending in a semicolon - no dangling 'union'. The dangling union is avoided by use of a union in the query below.
select concat('select "', table_schema, '.', table_name, '" as `schema.table`,
                          count(*)
                 from ', table_schema, '.', table_name, ' union ') as 'Query Row'
  from information_schema.tables
 union
 select '(select null, null limit 0);';
 
 ##https://www.dbsolo.com/help/compare.html
