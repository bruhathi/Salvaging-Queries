--There are two possible versions for answering this query. It depends on which hierarchy is chosen while answering the query.

--Sample Customer; sample the following view. 1%, 2%, 5%, 10%, 20%, 50%
-- WITH CustView (c_custkey) AS 
--         (Select c_custkey
--         From Customer 
--         Where c_acctbal <= 12345),
-- 		
-- D1 (c_custkey, revenue) AS 
--         (Select c_custkey, SUM(l_extendedprice * (l_discount)) as revenue 
--         From CustView, Orders, Lineitem 
--         Where o_orderkey = l_orderkey and c_custkey = o_custkey
-- and  l_shipdate >= date '1994-01-01' 
-- and l_shipdate < date '1994-01-01' + interval '1' year 
-- and l_discount between 0.05 and 0.07
-- and l_quantity < 24
--         Group By c_custkey),
-- 		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
-- 		
-- V4 (count_v1) AS
--         (Select COUNT(*)  as c
--        From CustView)
-- 		
-- Select SUM(a) as estimate_value
-- From (Select SUM(revenue * 15000000 / V4.count_v1) as a
-- 	From D1, V4
-- 	 ) main;
-- 
--Sample Part; sample the following view. 1%, 2%, 5%, 10%, 20%, 50%
WITH PartView (p_partkey) AS 
        (Select p_partkey
        From Part 
        Where p_partkey <= 20000005),
		
D1 (revenue) AS 
        (Select SUM(l_extendedprice * l_discount) as revenue 
        From PartView, Lineitem 
        Where p_partkey = l_partkey 
        and l_shipdate < date '1996-02-18'),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
V4 (count_v1) AS
        (Select COUNT(*)  as c
        From PartView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 20000000 / V4.count_v1) as a
	From D1, V4
	 ) main;
