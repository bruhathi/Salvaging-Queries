-- sample on part.
WITH PartView (p_partkey, p_name) AS
		(Select p_partkey, p_name
		 From Part
		 Where p_partkey <= 20000005),
		
D1 (amount) AS 
        (Select SUM((l_extendedprice * ( 1 - l_discount)) - ps_supplycost * l_quantity) as amount 
        From PartView, Orders, Partsupp, supplier, Lineitem, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and p_name like '%green%'),
		
PartCount (count_part) AS
	(Select COUNT(*) as c
	From PartView)
		
Select SUM(a) as estimate_value
From (Select SUM(amount * 20000000/PartCount.count_part) as a
	From D1, PartCount
	) main;

