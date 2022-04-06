Create Database ParetoParameter;
USE ParetoParameter;

-- group by customer ID
DROP TABLE IF EXISTS Input_new;
CREATE TABLE IF NOT EXISTS Input_new 
AS 
SELECT `customer ID`, `First name`, `Surname`, SUM(Sales) AS Sales FROM
    input
GROUP BY `customer ID`
ORDER BY Sales DESC;

-- add %_of_Total column
ALTER TABLE Input_new ADD Percentage_of_Total FLOAT;
-- ALTER TABLE Input_new MODIFY Percentage_of_Total FLOAT;

SET @S=(SELECT SUM(Sales) FROM Input_new);
-- SELECT @S
UPDATE Input_new
SET
Percentage_of_Total=Sales/@S*100;

-- add Cumulative_Percentage_of_Total column
DROP TABLE IF EXISTS output_pareto;
CREATE TABLE IF NOT EXISTS output_pareto
AS
SELECT *, ROUND(sum(Percentage_of_Total) over (ORDER by Sales DESC), 2) AS Cumulative_Percentage_of_Total
FROM Input_new;

-- SET PARETO PARAMETER 
SET @P=80;
SELECT *
FROM output_pareto
WHERE Cumulative_Percentage_of_Total<=@P