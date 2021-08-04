--Sample Customer; sample the following view. 1%, 2%, 5%, 10%, 20%, 50%
WITH CustView (c_custkey) AS 
        (Select c_custkey
        From Customer 
        Where c_acctbal <= 12345),
		
D1 (c_custkey, revenue) AS 
        (Select c_custkey, SUM(l_extendedprice * l_discount) as revenue 
        From CustView, Orders, Lineitem 
        Where o_orderkey = l_orderkey and c_custkey = o_custkey
	and l_shipdate < date '1992-03-21'
        Group By c_custkey),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_v1) AS
        (Select COUNT(*)  as c
        From CustView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 15000000 / V4.count_v1) as a
	From D1, V4
	 ) main;
