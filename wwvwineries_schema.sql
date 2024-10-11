DROP SCHEMA IF EXISTS wwvwineries_schema;

CREATE SCHEMA wwvwineries_schema;
USE wwvwineries_schema; 

CREATE TABLE Region (
Region_ID TINYINT UNSIGNED,
Name VARCHAR(30),
PRIMARY KEY (Region_ID)
);

CREATE TABLE Winery (
Winery_Region_ID TINYINT UNSIGNED,
Winery_ID TINYINT UNSIGNED,
Address VARCHAR(200),
Name VARCHAR(100),
Email VARCHAR(50),
Phone_Number VARCHAR(15),
PRIMARY KEY (Winery_ID)
);

CREATE TABLE Operating_Hours (
Winery_ID TINYINT UNSIGNED,
Days_Of_Week SET('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'),
Open TIME,
Close TIME
);

ALTER TABLE wwvwineries_schema.Operating_Hours
MODIFY COLUMN Days_Of_Week VARCHAR(100);


CREATE TABLE Wines (
Winery_ID TINYINT UNSIGNED,
Name VARCHAR(100),
Category_Type VARCHAR(100),
Varietal VARCHAR(100),
Alcohol_Percentage DECIMAL(4,2),
Vintage YEAR,
Price DECIMAL(5,2)
);