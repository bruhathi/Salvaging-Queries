-- sample on customer, part and supplier
WITH CustView (c_custkey) AS 
        (Select c_custkey
        From Customer 
        Where c_acctbal <= 10001),
		
PartView (p_partkey, p_name) AS
		(Select p_partkey, p_name
		 From Part
		 Where p_partkey <= 20000000),

SuppView (s_suppkey, s_nationkey) AS
		(Select s_suppkey, s_nationkey
		 From Supplier
		 Where s_suppkey <= 20000000),
		
D1 (p_partkey, c_custkey, amount) AS 
        (Select p_partkey, c_custkey, SUM((l_extendedprice * ( 1 - l_discount)) - ps_supplycost * l_quantity) / probability_supp as amount 
        From CustView, PartView, Orders, Partsupp, SuppView, Lineitem, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and c_custkey = o_custkey
		and p_name like '%green%'
        Group By p_partkey, c_custkey),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(amount) as s, COUNT(*) as c
--        From D1),
		
--CustCount (count_cust) AS
--       (Select COUNT(*)  as c
--        From CustView),

PartCount (count_part) AS
	(Select COUNT(*) as c
	From PartView)

--SuppCount (count_supp) AS
--	(Select COUNT(*) as c
--	From SuppView)
		
Select SUM(cluster_estimate / probability_part) as estimate_value,
	SUM((1 - probability_part) * 
	(cluster_estimate / probability_part) * 
	(cluster_estimate / probability_part)) as stage_1_variance, 
	SUM(cluster_variance / probability_part) as stage_2_variance
From (Select p_partkey, SUM(amount / probability_cust) as cluster_estimate, 
	SUM((1 - probability_cust) * (amount / probability_cust) * (amount / probability_cust)) as cluster_variance
	From D1
	Group BY p_partkey
	) main, PartCount;

