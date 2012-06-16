###rollup和order by不能同用,limit需要放在rollup后面
	SELECT year, country, product, SUM(profit) FROM sales 
		GROUP BY year, country, product 
		WITH ROLLUP 
		LIMIT 5;
