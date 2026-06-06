/* 
	Shows details of the orders, including the Unit Price and Quantity multiplied
    together to retrieve the line total.

	(NOTE: This data does already exist in AdventureWorks, but this is a
    demonstration of how we would calculate it if it did not.)

	Also shown here is how we would calculate what orders are to be delivered
    first through a DENSE_RANK() window function. This query shows all of the
    orders and their lines with a ranking number seen under the
    'DeliveryPriorityRank' column.
*/

SELECT s1.*
,	   SUM(s1.LineTotal) OVER (PARTITION BY s1.SalesOrderID) AS OrderTotal
,	   DENSE_RANK() OVER (ORDER BY s1.DueDate) AS DeliveryPriorityRank
FROM (SELECT soh.SalesOrderID
      ,	     soh.SalesOrderNumber
	  ,		 soh.PurchaseOrderNumber
	  ,      CONVERT(DATE, soh.OrderDate) AS OrderDate
	  ,      CONVERT(DATE, soh.DueDate) AS DueDate
	  ,	     sod.UnitPrice
	  ,	     sod.OrderQty
	  ,	     sod.UnitPrice * sod.OrderQty AS LineTotal
	  FROM [AdventureWorks2022].[Sales].[SalesOrderHeader] soh
	  INNER JOIN [AdventureWorks2022].[Sales].[SalesOrderDetail] sod
	    ON sod.SalesOrderID = soh.SalesOrderID) s1;