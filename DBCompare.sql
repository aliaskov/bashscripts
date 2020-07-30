SELECT
table_schema 'Database',
SUM(data_length + index_length) AS 'DBSize',
SUM(TABLE_ROWS) AS DBRows,
SUM(AUTO_INCREMENT) AS DBAutoIncCount
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'mysql', 'performance_schema')
GROUP BY table_schema;
