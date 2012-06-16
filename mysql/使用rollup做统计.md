###rollup和order by不能同用,limit需要放在rollup后面
	SELECT year, country, product, SUM(profit) FROM sales 
		GROUP BY year, country, product 
		WITH ROLLUP 
		LIMIT 5;


###完整的示例
	create table sales
	(
		year int not null,
		country varchar(20) not null,
		product varchar(32) not null,
		profit int
	);

	select year, sum(profit) from sales group by year;
	select year, sum(profit) from sales group by year with rollup;
	select year, country, product, sum(profit) from sales
	group by year, country, product;
	select year, country, product, sum(profit) from sales group by year, country, product with rollup;

	insert into sales values(2004,'china','tnt2004',2001);
	insert into sales values(2004,'china','tnt2004',2002);
	insert into sales values(2004,'china','tnt2004',2003);
	insert into sales values(2005,'china','tnt2005',2004);
	insert into sales values(2005,'china','tnt2005',2005);
	insert into sales values(2005,'china','tnt2005',2006);
	insert into sales values(2005,'china','tnt2005',2007);
	insert into sales values(2005,'china','tnt2005',2008);
	insert into sales values(2005,'china','tnt2005',2009);
	insert into sales values(2006,'china','tnt2006',2010);
	insert into sales values(2006,'china','tnt2006',2011);
	insert into sales values(2006,'china','tnt2006',2012);

	select year, country, product, sum(profit) from sales group by year, country, product;
	select year, country, product, sum(profit) from sales group by year, country, product with rollup;
