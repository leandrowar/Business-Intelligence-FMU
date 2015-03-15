
-- Conhecendo quem são os vendedores
SELECT DISTINCT(Sales_Person) AS VENDEDORES
FROM SALES_DATA

-- Conhecendo quais são os estados com maior volume de venda
SELECT Customer_Province, SUM(Total_Profit) AS LUCRO_TOTAL
FROM SALES_DATA
GROUP BY Customer_Province
ORDER BY LUCRO_TOTAL DESC


-- Conhecendo o histórico de vendas por ano
-- dos tres maiores estados
SELECT YEAR(OrderDate) AS ANO, COUNT(Product_Name) AS QTDE 
FROM SALES_DATA
WHERE Customer_Province = 'California'
GROUP BY YEAR(OrderDate)
ORDER BY ANO


-- Conhecendo o lucro médio da empresa por ano
SELECT YEAR(OrderDate) AS ANO, AVG(Total_Profit) AS LUCRO_MEDIO
FROM SALES_DATA
WHERE OrderDate >= '2005-07-01 00:00:00.000'
GROUP BY YEAR(OrderDate)
ORDER BY ANO

--Entendendo a participação de cada categoria de produto nas vendas brutas
SELECT Product_Category, SUM(UnitPrice*OrderQty) as RECEITA_BRUTA
FROM SALES_DATA
WHERE Product_Category IS NOT NULL
GROUP BY Product_Category

SELECT * FROM SALES_DATA