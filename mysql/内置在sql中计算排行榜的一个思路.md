###创建排行的视图
```
CREATE VIEW alliance_rank_view AS 
	SELECT id,alliance_name,score
	FROM alliances 
	ORDER BY score DESC, created_at ASC 
```

###查询排行榜列表
```
SET @rownum := 0;
SELECT * FROM (
	SELECT @rownum := @rownum+1 AS rank, id, alliance_name, score 
	FROM alliance_rank_view
) AS alliance_ranks LIMIT 1000; 
```

###查询第10名是哪个
```
SET @rownum := 0;
SELECT * FROM (
	SELECT @rownum := @rownum+1 AS rank, id, score 
	FROM alliance_rank_view
) AS alliance_ranks WHERE rank=10; 
```

###查询某个联盟的排行
```
SET @rownum := 0;
SELECT * FROM (
	SELECT @rownum := @rownum+1 AS rank, id, score, alliance_name
	FROM alliance_rank_view
) AS alliance_ranks WHERE alliance_name='星河联盟'; 
```
