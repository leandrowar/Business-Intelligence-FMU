#Selecionando o diretorio de trabalho
setwd("C:/Users/Leandro/Google Drive/FMU")

#Instalando e carregado a biblioteca RODBC
install.packages("RODBC")
library(RODBC)

#Abrindo uma conexao com o banco
minha_conexao <-odbcConnect("FMU", uid="LEANDROWAR/Leandro", pwd="")

#Escrevendo as consultas
#Conhecendo quem são os vendedores
vendedores <- sqlQuery(minha_conexao,
        "
        SELECT DISTINCT(Sales_Person) AS VENDEDORES
        FROM SALES_DATA
        ")

#Conhecendo quais são os estados com maior volume de venda
maior_venda <- sqlQuery(minha_conexao,
        "
        SELECT Customer_Province, SUM(Total_Profit) AS LUCRO_TOTAL
        FROM SALES_DATA
        GROUP BY Customer_Province
        ORDER BY LUCRO_TOTAL DESC
        ")


#Conhecendo o histórico de vendas por ano
#dos tres maiores estados
california <- sqlQuery(minha_conexao,
        "
        SELECT YEAR(OrderDate) AS ANO, COUNT(Product_Name) AS QTDE 
        FROM SALES_DATA
        WHERE Customer_Province = 'California'
        GROUP BY YEAR(OrderDate), Customer_Province
        ORDER BY ANO
        ")

washington <- sqlQuery(minha_conexao,
                       "
        SELECT YEAR(OrderDate) AS ANO, COUNT(Product_Name) AS QTDE 
        FROM SALES_DATA
        WHERE Customer_Province = 'Washington'
        GROUP BY YEAR(OrderDate), Customer_Province
        ORDER BY ANO
        ")

texas <- sqlQuery(minha_conexao,
                       "
        SELECT YEAR(OrderDate) AS ANO, COUNT(Product_Name) AS QTDE 
        FROM SALES_DATA
        WHERE Customer_Province = 'Texas'
        GROUP BY YEAR(OrderDate)
        ORDER BY ANO
        ")

#Conhecendo o lucro médio da empresa por ano
lucro_medio <-sqlQuery(minha_conexao,
        "
        SELECT YEAR(OrderDate) AS ANO, AVG(Total_Profit) AS LUCRO_MEDIO
        FROM SALES_DATA
        WHERE OrderDate >= '2005-07-01 00:00:00.000'
        GROUP BY YEAR(OrderDate)
        ORDER BY ANO
        ")

#Entendendo a participação de cada categoria de produto nas vendas brutas
participacao <-sqlQuery(minha_conexao,
        "
        SELECT Product_Category, SUM(UnitPrice*OrderQty) as RECEITA_BRUTA
        FROM SALES_DATA
        WHERE Product_Category IS NOT NULL
        GROUP BY Product_Category
        ")

#Fechando a conexão
close(minha_conexao)

vendedores
maior_venda #Três Maiores - California, Washington, Texas
california
lucro_medio
participacao$RECEITA_BRUTA <- as.numeric(as.character(participacao$RECEITA_BRUTA))
participacao$RECEITA_BRUTA

#Algumas visualizações simples
barplot(participacao$RECEITA_BRUTA,main="Receita Bruta\npor Categoria de Produto", 
        xlab="Ano",ylab="Receita",col=c("red"),names.arg=participacao$Product_Category)
barplot(lucro_medio$LUCRO_MEDIO,main="Lucro Médio\nAnual", 
        xlab="Ano",ylab="Quantidade",col=c("green"),names.arg=lucro_medio$ANO)
barplot(california$QTDE,main="Unidades vendidas\nCalifórnia", 
        xlab="Ano",ylab="Quantidade",col=c("darkblue"),names.arg=california$ANO)
barplot(washington$QTDE,main="Unidades vendidas\nwashington", 
        xlab="Ano",ylab="Quantidade",col=c("darkblue"),names.arg=washington$ANO)
barplot(texas$QTDE,main="Unidades vendidas\nTexas", 
        xlab="Ano",ylab="Quantidade",col=c("darkblue"),names.arg=texas$ANO)

