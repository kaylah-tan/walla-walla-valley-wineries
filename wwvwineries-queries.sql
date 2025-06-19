-- Mateus Conaway and Kaylah Tan
-- 05/05/24
-- CS302: Databases 

-- WWV Wineries

-- Queries below that answer questions in our project proposal 

-- What are the names of wines that have an alcohol percentage of less than 13.5%?
SELECT Name, Alcohol_Percentage
FROM Wines
WHERE Alcohol_Percentage < 13.5;

-- How many wineries are in each region?
SELECT Region.Name, COUNT(Winery.Winery_ID) AS number_of_wineries
FROM Region
LEFT JOIN Winery ON Region.Region_ID = Winery.Region_ID
GROUP BY Region.Name;

-- Which wineries offer Rose wines?
SELECT Winery.Name, Category_Type
FROM Winery
INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
WHERE Category_Type = 'Rose'
GROUP BY Winery.Winery_ID, Winery.Name;

-- Which wineries offer Sparkling wines?
SELECT Winery.Name, Category_Type
FROM Winery
INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
WHERE Category_Type = 'Sparkling'
GROUP BY Winery.Winery_ID, Winery.Name;

-- Which wineries have wines with a vintage from 2022? How many of these wines do each of these wineries have?
SELECT Winery.Name, COUNT(*)
FROM Winery
INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
WHERE Vintage = 2022
GROUP BY Winery.Winery_ID, Winery.Name
ORDER BY COUNT(*) DESC;

-- Which winery has the most amount of white wines?
SELECT Winery.Name, COUNT(*)
FROM Winery
INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
WHERE Category_Type = "White"
GROUP BY Winery.Winery_ID, Winery.Name
ORDER BY COUNT(*) DESC
LIMIT 1;

-- Which wines are less than $50? Start with the cheapest wines.
SELECT Wines.Name, Wines.Price
FROM Wines
WHERE Price < 50
ORDER BY Wines.Price;

-- What wineries offer White wines and are open on wednesdays? When do these wineries open and close?
SELECT DISTINCT Winery.Name, Operating_Hours.Open, Operating_Hours.Close
FROM Winery
INNER JOIN Operating_Hours ON Winery.Winery_ID = Operating_Hours.Winery_ID
INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
WHERE Category_Type = 'White' 
  AND Operating_Hours.Days_Of_Week LIKE '%Wednesday%'
  AND Operating_Hours.Open IS NOT NULL
  AND Operating_Hours.Close IS NOT NULL;


-- What are the names and addresses of all wineries on Main Street?
SELECT Winery.Name, Winery.Address
FROM Winery
WHERE Winery.Address LIKE '%Main%';

-- Stored Procedures: 

-- Takes in a range of alcohol percents of min and max
-- Returns the winery name, wine name, cateogory, and alc percent
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AlcoholPercentage`(IN min_percent VARCHAR(10), max_percent VARCHAR(10))
BEGIN
SELECT Winery.Name AS Winery_Name, Wines.Name AS Wine_Name, Wines.Category_Type, Wines.Alcohol_Percentage
FROM Wines
INNER JOIN Winery ON Wines.Winery_ID = Winery.Winery_ID
WHERE Wines.Alcohol_Percentage BETWEEN min_percent AND max_percent
ORDER BY Wines.Alcohol_Percentage ASC;
END$$
DELIMITER ;

-- Takes in a day of the week, a desired open time, and close time
-- Returns the wineries name along with the desired range of hours
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `AvailableWineryHours`(IN day_of_week VARCHAR(20), open_time TIME, close_time TIME)
BEGIN
    SELECT Winery.Name AS Winery_Name, Operating_Hours.Open, Operating_Hours.Close
    FROM Operating_Hours
    INNER JOIN Winery ON Operating_Hours.Winery_ID = Winery.Winery_ID
    WHERE Operating_Hours.Days_Of_Week LIKE CONCAT('%', day_of_week, '%')
    AND Operating_Hours.Open >= open_time
    AND Operating_Hours.Close <= close_time;
END$$
DELIMITER ;

-- Takes in a wine type (i.e., red, white, sparkling, rose) and a certain amount of the desired wine
-- Returns the count, winery name, and address
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `CertainAmount`(IN WineType VARCHAR(10), IN Num INT)
BEGIN
	SELECT COUNT(*) AS WineCount, Winery.Name, Winery.Address
    FROM Winery
    INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID
    WHERE Category_Type = WineType
    GROUP BY Winery.Winery_ID, Winery.Name, Winery.Address
    HAVING WineCount >= Num
    ORDER BY WineCount DESC;
END$$
DELIMITER ;

-- Takes in a category of wine (i.e., red, white, sparkling, rose) 
-- Returns the winery name and the count of the desired wine category 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `ListOfWineriesThatSell`(IN category_type VARCHAR(20))
BEGIN
	SELECT Winery.Name AS Winery_Name, COUNT(*) AS COUNT 
	FROM Winery
	INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID 
	WHERE Category_Type = category_type
	GROUP BY Winery.Name;
END$$
DELIMITER ;

-- Takes in a range of prices, a min price and max price
-- Returns the winery name, wine name, and the prices of the wines
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `PriceRange`(min_price INT, max_price INT)
BEGIN
	SELECT Winery.Name AS Winery_Name, Wines.Name AS Wine_Name, Wines.Price
    FROM Wines
    INNER JOIN Winery ON Wines.Winery_ID = Winery.Winery_ID
    WHERE Wines.Price >= min_price 
    AND Wines.Price <= max_price
    ORDER BY Wines.Price ASC;
END$$
DELIMITER ;

-- Takes in the varietal name (e.g. merlot, syrah, chardonnay, rose, etc.)
-- Returns the winery name and wine name
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Varietals`(IN wine_varietal VARCHAR(50))
BEGIN
	SELECT Winery.Name AS Winery_Name, Wines.Name AS Wine_Name
    FROM Winery
    INNER JOIN Wines ON Winery.Winery_ID = Wines.Winery_ID
    WHERE Wines.Varietal = wine_varietal;
END$$
DELIMITER ;

-- Takes in the winery region name (i.e., airport district, oregon valley, downtown walla walla)
-- Returns the count of wineries in the desired region
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `WineriesinRegion`(region_name VARCHAR(100))
BEGIN
	SELECT Region.Name, COUNT(Winery.Winery_ID) AS number_of_wineries
	FROM Region
	LEFT JOIN Winery ON Region.Region_ID = Winery.Region_ID
    WHERE Region.Name = region_name
	GROUP BY Region.Name;
END$$
DELIMITER ;

-- Takes in the winery region name (i.e., airport district, oregon valley, downtown walla walla)
-- Returns the winery names, address, and phone number
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `WineryNamesinRegion`(region_name VARCHAR(100))
BEGIN
    SELECT Winery.Name AS Winery_Name, Winery.Address, Winery.Phone_Number
    FROM Region
    LEFT JOIN Winery ON Region.Region_ID = Winery.Region_ID
    WHERE Region.Name = region_name;
END$$
DELIMITER ;

-- View: 
-- Created a view that converts null operating hours to say closed. 
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `closed_operating_hours` AS select distinct `winery`.`Name` AS `Name`,ifnull(`operating_hours`.`Open`,'Closed') AS `Open`,ifnull(`operating_hours`.`Close`,'Closed') AS `Close` from (`winery` join `operating_hours` on((`winery`.`Winery_ID` = `operating_hours`.`Winery_ID`)));

-- Function
-- A function that returns a $ within a range of $-$$$ for prices. Includes the name of the winery. 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `price_amenities`(price DECIMAL(5,2)) RETURNS varchar(7) CHARSET utf8mb4
    DETERMINISTIC
BEGIN
DECLARE price_range VARCHAR(7);
    IF price >= 15 AND price <= 40 THEN
        SET price_range = '$';
    ELSEIF price >= 41 AND price <= 100 THEN
        SET price_range = '$$';
    ELSEIF price > 101 THEN
        SET price_range = '$$$';
	ELSE
        SET price_range = 'Unknown';
    END IF;
    RETURN price_range;
END$$
DELIMITER ;