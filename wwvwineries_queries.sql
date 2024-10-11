-- Mateus Conaway and Kaylah Tan
-- 05/05/24
-- CS302: Databases 

-- WWV Wineries

-- Examples that call our stored procedures below:
-- What are the wineries that sell alcohol within the range of 13.0% and 15%? Includes the alcohol name and category.
CALL AlcoholPercentage('13.0', '15.0');

-- What wineries are available of on Monday from 12:00:00 - 6:00:00?
CALL AvailableWineryHours('Monday', '12:00:00', '6:00:00');

-- What wineries sell red wines and have at least 20? Includes the count, name of the winery, and the address.
CALL CertainAmount('Red', 20);

-- What wineries sell rose wine? Include the name of the winery.
CALL ListofWineriesThatSell('Rose');

-- What wines are priced within $75 through $150? Includes the name of the winery and the category.
CALL PriceRange('75', '150');

-- What wineries sell merlot wines? Include the winery name and wine name. 
CALL Varietals('Merlot');

-- How many wineries are in airport district? 
CALL WineriesinRegion('Airport District');

-- What are the name of the wineries in airport district? Include the address. 
CALL WineryNameInRegion('Airport District');

-- Example of function below:

-- A function that returns a $ within a range of $-$$$ for prices. Includes the name of the winery. 
SELECT Winery.Name, price_amenities(100) AS Price_Amenities
FROM Winery;

-- Example of view below:
-- Created a view that converts null operating hours to say closed. 
SELECT * FROM closed_operating_hours;