R & BUSINESS INTELLIGENCE
========================================================
author: leandro.guerra@artedosdados.com.br
date:

Simples Relatorio de Vendas
========================================================

Nesta aula mostramos como

* Criar uma conexao ODBC
* Realizar consultas no R
* Utilizar o R Presentation

Quais os recursos do R utilziados
========================================================
Alem do R Presentation, estudamos a implantacao de um 
codigo que utiliza a library RODBC para estabelecer
a conexao com um banco MS SQL

```r
library(RODBC)
```

Nossa base de vendas
========================================================
Neste slide, trazemos a receita bruta por produto
![plot of chunk unnamed-chunk-2](ADV-figure/unnamed-chunk-2.png) 

O codigo que executa isto
========================================================
Apenas um exemplo para mostrar o codigo

```r
barplot(participacao$RECEITA_BRUTA,
        main="Receita Bruta\npor Categoria de Produto", 
        xlab="Ano",ylab="Receita",col=c("red"),
        names.arg=participacao$Product_Category)
```
Vendas por Estado
========================================================
Avaliando a venda nos tres maiores estados
![plot of chunk unnamed-chunk-4](ADV-figure/unnamed-chunk-4.png) 
