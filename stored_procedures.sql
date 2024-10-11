CREATE DEFINER=`root`@`localhost` PROCEDURE `FindAlcPercent`(Alc_Percent DECIMAL (4,2))
BEGIN
	SELECT Name, Alcohol_Percentage
	FROM Wines
	WHERE Alcohol_Percentage > Alc_Percent;
END