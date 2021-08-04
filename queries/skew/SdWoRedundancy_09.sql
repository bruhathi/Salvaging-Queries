-- sample on customer and part.
WITH CustView (c_custkey) AS 
        (Select c_custkey
        From Customer 
        Where c_acctbal <= 10001),
		
PartView (p_partkey, p_name) AS
		(Select p_partkey, p_name
		 From Part
		 Where p_partkey <= 20000000),
		
D1 (c_custkey, p_partkey, amount) AS 
        (Select c_custkey, p_partkey, SUM((l_extendedprice * ( 1 - l_discount)) - ps_supplycost * l_quantity) as amount 
        From CustView, PartView, Orders, Partsupp, supplier, Lineitem, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and c_custkey = o_custkey
		and p_name like '%green%'
        Group By c_custkey, p_partkey),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(amount) as s, COUNT(*) as c
--        From D1),
		
CustCount (count_cust) AS
        (Select COUNT(*)  as c
        From CustView),

PartCount (count_part) AS
	(Select COUNT(*) as c
	From PartView)
		
Select SUM(a) as estimate_value
From (Select SUM(amount * 15000000 / CustCount.count_cust * 20000000/PartCount.count_part) as a
	From D1, CustCount, PartCount
	) main;

