/*
    Extension of CustomerNames.sql to include CROSS APPLY against
    SalesOrderHeader in order to show each customer's most recent order.

    For demonstration purposes, this query assumes every customer has a
    populated PersonID. This allows us to use an INNER JOIN to Person.Person
    to retrieve the point of contact for store customers.

    For non-store customers, PointOfContact remains NULL.
*/

SELECT c.CustomerID
,      c.StoreID
,      c.PersonID
,      n.[Name] AS CustomerName
,      CASE
         WHEN c.StoreID IS NULL
           THEN NULL
         ELSE CONCAT(p.FirstName, ' ', p.LastName)
       END AS PointOfContact
,      CONVERT(DATE, soh.OrderDate) AS MostRecentOrderDate
FROM [AdventureWorks2022].[Sales].[Customer] c
INNER JOIN (SELECT BusinessEntityID
            ,      [Name]
            FROM [AdventureWorks2022].[Sales].[Store]
            UNION ALL
            SELECT BusinessEntityID
            ,      CONCAT(FirstName, ' ', LastName)
            FROM [AdventureWorks2022].[Person].[Person]) n
  ON n.BusinessEntityID = COALESCE(c.StoreID, c.PersonID)
INNER JOIN [AdventureWorks2022].[Person].[Person] p
  ON p.BusinessEntityID = c.PersonID
CROSS APPLY (SELECT TOP 1 soh.OrderDate
             FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] soh
             WHERE soh.CustomerID = c.CustomerID
             ORDER BY soh.OrderDate DESC) soh;