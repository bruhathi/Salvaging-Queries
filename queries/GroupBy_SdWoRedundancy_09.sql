-- sample on customer and part.
WITH CustView (c_custkey) AS 
        (Select c_custkey
        From Customer 
        Where c_acctbal <= 10001),
		
PartView (p_partkey, p_name) AS
		(Select p_partkey, p_name
		 From Part
		 Where p_partkey <= 20000000)
		
        Select n_name, extract(year from o_orderdate) as o_year, SUM((l_extendedprice * ( 1 - l_discount)) - ps_supplycost * l_quantity) as amount 
        From CustView, PartView, Orders, Partsupp, supplier, Lineitem, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and c_custkey = o_custkey
		and p_name like '%green%'
        Group by 
              n_name,
              o_year
         order by
              n_name,
              o_year desc
;
