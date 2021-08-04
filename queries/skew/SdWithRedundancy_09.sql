-- sample on lineitem.
WITH LineitemView (l_orderkey, l_suppkey, l_partkey, l_extendedprice, l_discount, l_quantity) AS 
        (Select l_orderkey, l_suppkey, l_partkey, l_extendedprice, l_discount, l_quantity
        From Lineitem 
        Where l_extendedprice <= 104950),
		
D1 (amount) AS 
        (Select SUM((l_extendedprice * (1 - l_discount)) - ps_supplycost * l_quantity) as amount 
        From Part, Orders, Partsupp, supplier, LineitemView, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and p_name like '%green%'),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(amount) as s, COUNT(*) as c
--        From D1),
		
LineitemCount (count_lineitem) AS
        (Select COUNT(*)  as c
        From LineitemView)

Select SUM(a) as estimate_value
From (Select SUM(amount * 600000003 / LineitemCount.count_lineitem) as a
	From D1, LineitemCount
	) main;

