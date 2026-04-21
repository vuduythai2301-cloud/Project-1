-- TOP 5 khách hàng chi tiêu nhiều nhất
SELECT TOP 5 c.CustomerID,
SUM(s.TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c ON
s.CustomerID = c.CustomerID
GROUP BY c.CustomerID
ORDER BY TotalSpent DESC;

-- 2.TOP 100 khách hàng chi tiêu ít nhất
SELECT TOP 100 c.CustomerID,
COUNT(s.SalesOrderID) AS
OrderCount
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader s
ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID
ORDER BY OrderCount ASC;

-- 3.TOP 5 sản phẩm bán chạy nhất
SELECT TOP 5 p.Name,
SUM(so.OrderQty) AS TotalSold
FROM Sales.SalesOrderDetail so
JOIN Production.Product p ON
so.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY TotalSold DESC;

-- 4.Doanh số theo vùng
SELECT st.Name AS Territory,
SUM(s.TotalDue) AS Revenue
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesTerritory st ON
s.TerritoryID = st.TerritoryID
GROUP BY st.Name
ORDER BY Revenue DESC;

-- 5.Số lượng khách hàng mới mỗi năm
SELECT YEAR(MinOrderDate) AS
Year,
 COUNT(CustomerID) AS
NewCustomers
FROM (
 SELECT CustomerID,
MIN(OrderDate) AS MinOrderDate
 FROM Sales.SalesOrderHeader
 GROUP BY CustomerID
) AS FirstOrders
GROUP BY YEAR(MinOrderDate)
ORDER BY Year;

-- 6.Tồn kho hiện tại của từng sản phẩm
SELECT p.Name, SUM(pi.Quantity)
AS StockQty
FROM Production.ProductInventory pi
JOIN Production.Product p ON
pi.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY StockQty ASC;

-- 7.TOP 5 sản phẩm có lợi nhuận cao nhất
SELECT TOP 5 p.Name,
SUM(so.LineTotal - (p.StandardCost *
so.OrderQty)) AS Profit
FROM Sales.SalesOrderDetail so
JOIN Production.Product p ON
so.ProductID = p.ProductID
GROUP BY p.Name
ORDER BY Profit DESC;

-- 8.Tháng nào trong năm có doanh số cao nhất
SELECT MONTH(OrderDate) AS
Month, SUM(TotalDue) AS Revenue
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate)
ORDER BY Revenue DESC;

-- Tính toán một số chỉ số KPI cho công ty
-- Doanh thu theo từng năm
SELECT YEAR(OrderDate)
AS Nam,
 SUM(TotalDue) AS
DoanhThu
FROM
Sales.SalesOrderHeader
GROUP BY
YEAR(OrderDate)
ORDER BY Nam;

-- Tỷ lệ khách hàng mới theo năm
SELECT YEAR(OrderDate)
AS Nam, COUNT(DISTINCT
CustomerID) AS
KhachHangMoi
FROM
Sales.SalesOrderHeader SOH
WHERE CustomerID IN (
SELECT CustomerID
FROM
Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING
MIN(YEAR(OrderDate)) =
YEAR(SOH.OrderDate)
)
GROUP BY
YEAR(OrderDate)

-- Doanh thu theo vùng địa lý
SELECT T.Name AS Vung,
SUM(SOH.TotalDue) AS
DoanhThu
FROM
Sales.SalesOrderHeader SOH
JOIN Sales.SalesTerritory T
ON SOH.TerritoryID =
T.TerritoryID
GROUP BY T.Name

-- Lợi nhuận theo dòng sản phẩm
SELECT 
    PC.Name AS DanhMuc,
    SUM(SOD.LineTotal - (P.StandardCost * SOD.OrderQty)) AS LoiNhuan
FROM Sales.SalesOrderDetail AS SOD
JOIN Production.Product AS P 
    ON SOD.ProductID = P.ProductID
JOIN Production.ProductSubcategory AS PSC 
    ON P.ProductSubcategoryID = PSC.ProductSubcategoryID
JOIN Production.ProductCategory AS PC 
    ON PSC.ProductCategoryID = PC.ProductCategoryID
GROUP BY PC.Name
ORDER BY LoiNhuan DESC;

-- Lợi nhuận gộp
SELECT
YEAR(SOH.OrderDate) AS
Nam,
 SUM(OD.LineTotal -
(P.StandardCost *
OD.OrderQty)) AS
LoiNhuanGop
FROM
Sales.SalesOrderHeader SOH
JOIN Sales.SalesOrderDetail
OD ON SOH.SalesOrderID =
OD.SalesOrderID
JOIN Production.Product P
ON OD.ProductID =
P.ProductID
GROUP BY
YEAR(SOH.OrderDate)
ORDER BY Nam;
