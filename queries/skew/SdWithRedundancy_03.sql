-- sample on lineitem.
WITH LineitemView (l_orderkey, l_shipdate, l_extendedprice, l_discount) AS 
        (Select l_orderkey, l_shipdate, l_extendedprice, l_discount
        From Lineitem
        Where l_extendedprice <= 104950),
		
D1 (revenue) AS 
        (Select SUM(l_extendedprice * (1 - l_discount)) as revenue 
        From Customer, Orders, LineitemView 
        Where c_mktsegment = 'BUILDING'
			and c_custkey = o_custkey
			and l_orderkey = o_orderkey
			and o_orderdate < date '1995-03-15'
			and l_shipdate > date '1995-03-15'),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_lineitem) AS
        (Select COUNT(*)  as c
        From LineitemView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 600000003 / V4.count_lineitem) as a 
      From D1, V4) main;

