-- sample on customer.
WITH CustView (c_custkey, c_mktsegment) AS 
        (Select c_custkey, c_mktsegment
        From Customer 
        Where c_acctbal <= 10001),
		
D1 (c_custkey, revenue) AS 
        (Select c_custkey, SUM(l_extendedprice * (1 - l_discount)) as revenue 
        From CustView, Orders, Lineitem 
        Where c_mktsegment = 'BUILDING'
			and c_custkey = o_custkey
			and l_orderkey = o_orderkey
			and o_orderdate < date '1995-03-15'
			and l_shipdate > date '1995-03-15'
        Group By c_custkey),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_v1) AS
        (Select COUNT(*)  as c
        From CustView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 15000000 / V4.count_v1) as a 
      From D1, V4) main;
