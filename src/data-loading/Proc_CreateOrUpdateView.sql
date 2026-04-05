-- USE creditrisk_gold;

CREATE OR ALTER PROCEDURE CreateOrUpdateView
    @tableName NVARCHAR(100)
AS
BEGIN
    DECLARE @sql NVARCHAR(MAX);
    
    SET @sql = N'CREATE OR ALTER VIEW ' + @tableName + ' AS
    SELECT * FROM OPENROWSET(
        BULK ''' + @tableName + '/'',
        DATA_SOURCE = ''creditrisk_gold_storage'',
        FORMAT = ''DELTA''
    ) AS result';
    
    EXEC sp_executesql @sql;
END;