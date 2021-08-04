-- sample on part.
WITH PartView (p_partkey, p_brand, p_container) AS 
        (Select p_partkey, p_brand, p_container
        From Part 
        Where p_partkey <= 20000005),
		
D1 (p_partkey, revenue) AS 
        (Select p_partkey, SUM(l_extendedprice) as revenue 
        From PartView, PartSupp, Lineitem 
        Where p_partkey = l_partkey
	 	and p_partkey = ps_partkey
	 	and ps_suppkey = l_suppkey
		and p_brand = 'Brand#23'
		and p_container = 'MED BOX'
		and l_quantity < (
			select 0.2 * avg(l_quantity)
			from lineitem
			where l_partkey = p_partkey)
        Group By p_partkey),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_v1) AS
        (Select COUNT(*)  as c
        From PartView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 20000000 / (7.0 * V4.count_v1)) as a 
      From D1, V4) main;
