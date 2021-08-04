--Sample Lineitem; sample the following view. 1%, 2%, 5%, 10%, 20%, 50%
WITH LineitemView (l_orderkey, l_extendedprice, l_discount, l_shipdate, l_quantity) AS 
        (Select l_orderkey, l_extendedprice, l_discount, l_shipdate, l_quantity
        From Lineitem 
        Where l_extendedprice <= 104950),
		
D1 (revenue) AS 
        (Select SUM(l_extendedprice * (l_discount)) as revenue 
        From LineitemView
        Where 
	  l_shipdate < date '1996-03-14'
     	),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_lineitem) AS
        (Select COUNT(*)  as c
        From LineitemView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 600000003 / V4.count_lineitem) as a
	From D1, V4
	 ) main;
