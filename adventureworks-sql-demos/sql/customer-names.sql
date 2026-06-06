/*
    Shows customer names, whether the customer is a store customer,
    or an individual person if a store is not tied to the customer.

    For demonstration purposes, this query assumes every customer has a
    populated PersonID. This allows us to use an INNER JOIN to Person.Person
    to retrieve the point of contact for store customers.

    For non-store customers, 'PointOfContact' remains NULL.
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
  ON p.BusinessEntityID = c.PersonID;