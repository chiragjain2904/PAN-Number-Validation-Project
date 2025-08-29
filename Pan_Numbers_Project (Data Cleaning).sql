CREATE DATABASE pan_db;
USE pan_db;

SELECT * FROM pan_number_data;

-- Identify and handle missing data
SELECT * FROM pan_number_data WHERE Pan_Numbers IS NULL;

--CHECK FOR DUPLICATES
SELECT Pan_Numbers, COUNT(*)
FROM pan_number_data
GROUP BY Pan_Numbers
HAVING COUNT(*) > 1;

-- Handling leading/ trailing spaces
SELECT * FROM pan_number_data
WHERE Pan_Numbers != TRIM(pan_numbers);

--correct letter cases
SELECT * FROM pan_number_data
WHERE Pan_Numbers != UPPER(pan_numbers);

-- Cleaned Pan Numbers
SELECT DISTINCT UPPER(TRIM(Pan_Numbers)) AS pan_number
FROM pan_number_data
WHERE Pan_Numbers IS NOT NULL
AND TRIM(pan_numbers) != '';

-- Function to check if adjacent characters are the same
CREATE OR ALTER FUNCTION dbo.fn_check_adjacent_repetition (@p_str NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @len INT = LEN(@p_str);

    WHILE @i < @len
    BEGIN
        IF SUBSTRING(@p_str, @i, 1) = SUBSTRING(@p_str, @i + 1, 1)
            RETURN 1; -- TRUE

        SET @i += 1;
    END

    RETURN 0; -- FALSE
END;

SELECT dbo.fn_check_adjacent_repetition('ZZVOC');

-- OR THROUGH REGEX-LIKE SOLUTION

CREATE OR ALTER FUNCTION dbo.fn_check_adjacent_repetition (@p_str NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    -- PATINDEX searches for any letter/digit/symbol repeated twice in a row
    -- [] contains all possible characters to check
    IF PATINDEX('%[A-Za-z0-9!@#$%^&*()_+=\[\]{};:'',.<>/?`~\- ]\1%', @p_str) > 0
        RETURN 1;
    RETURN 0;
END;

-- Function to check if sequencial characters are used

CREATE OR ALTER FUNCTION dbo.fn_check_sequence (@p_str NVARCHAR(MAX))
RETURNS BIT
AS
BEGIN
    DECLARE @i INT = 1;
    DECLARE @len INT = LEN(@p_str);

    WHILE @i < @len
    BEGIN
        IF ASCII(SUBSTRING(@p_str, @i + 1, 1)) - ASCII(SUBSTRING(@p_str, @i, 1)) <> 1
            RETURN 0; -- FALSE

        SET @i += 1;
    END

    RETURN 1; -- TRUE
END;


SELECT dbo.fn_check_sequence('XVD');

-- OR USING CTE

;WITH Numbers AS (
    -- Generate positions from 1 to LEN(string)-1
    SELECT n = 1
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < LEN(@p_str) - 1
),
Diffs AS (
    SELECT 
        n,
        Diff = ASCII(SUBSTRING(@p_str, n + 1, 1)) 
             - ASCII(SUBSTRING(@p_str, n, 1))
    FROM Numbers
)
SELECT CASE WHEN COUNT(*) = SUM(CASE WHEN Diff = 1 THEN 1 ELSE 0 END) 
            THEN 1 ELSE 0 END AS IsSequential
FROM Diffs
OPTION (MAXRECURSION 0);

-- If you want to check every row in a table column:

;WITH Strings AS (
    SELECT ID, YourColumn
    FROM YourTable
),
Numbers AS (
    SELECT ID, n = 1
    FROM Strings
    UNION ALL
    SELECT s.ID, n + 1
    FROM Numbers n
    JOIN Strings s ON n.ID = s.ID
    WHERE n.n < LEN(s.YourColumn) - 1
),
Diffs AS (
    SELECT 
        s.ID,
        Diff = ASCII(SUBSTRING(s.YourColumn, n.n + 1, 1)) 
             - ASCII(SUBSTRING(s.YourColumn, n.n, 1))
    FROM Numbers n
    JOIN Strings s ON n.ID = s.ID
)
SELECT ID, 
       CASE WHEN COUNT(*) = SUM(CASE WHEN Diff = 1 THEN 1 ELSE 0 END) 
            THEN 1 ELSE 0 END AS IsSequential
FROM Diffs
GROUP BY ID;

-- Regular expression to validate the pattern or structure of PAN no's 
SELECT * FROM pan_number_data
WHERE Pan_Numbers ~ '^[A-Z]{5}[0-9]{4}[A-Z]$'
-- First 5 characters must be alphabet, next 4 should be no from 0-9 & then the last characters should be alphabet


-- Valid & Invalid Pan Categories 
CREATE VIEW valid_invalid_pans AS 
WITH cte_cleaned_pan AS (
    SELECT DISTINCT UPPER(TRIM(Pan_Numbers)) AS pan_number
    FROM pan_number_data
    WHERE Pan_Numbers IS NOT NULL
    AND LTRIM(RTRIM(Pan_Numbers)) != ''
),cte_valid_pans AS 
	(SELECT *
	FROM cte_cleaned_pan
	WHERE dbo.fn_check_adjacent_repetition(pan_number) = 0
	AND dbo.fn_check_sequence(SUBSTRING(pan_number, 1, 5)) = 0
	AND dbo.fn_check_sequence(SUBSTRING(pan_number, 6, 4)) = 0
	AND pan_number LIKE '[A-Z][A-Z][A-Z][A-Z][A-Z][0-9][0-9][0-9][0-9][A-Z]')
SELECT cln.pan_number,
CASE WHEN vld.pan_number IS NOT NULL THEN 'Valid PAN'
	 ELSE 'Invalid PAN'
END AS status
FROM cte_cleaned_pan cln
LEFT JOIN cte_valid_pans vld
ON vld.pan_number = cln.pan_number;

SELECT * FROM valid_invalid_pans;

-- Summary Report
CREATE VIEW summary_pan_numbers_report AS 
WITH cte_info AS 
	(SELECT 
		(SELECT COUNT(*) FROM pan_number_data) AS total_processed_records,
		SUM(CASE WHEN status = 'Valid PAN' THEN 1 ELSE 0 END) AS total_valid_pans,
		SUM(CASE WHEN status = 'Invalid PAN' THEN 1 ELSE 0 END) AS total_invalid_pans
	FROM valid_invalid_pans)
SELECT total_processed_records, total_valid_pans, total_invalid_pans,
(total_processed_records - (total_valid_pans + total_invalid_pans)) AS total_missing_pans
FROM cte_info;

SELECT * FROM summary_pan_numbers_report;



