-- sample on lineitem.
WITH LineitemView (l_orderkey, l_suppkey, l_partkey, l_extendedprice, l_discount, l_quantity) AS 
        (Select l_orderkey, l_suppkey, l_partkey, l_extendedprice, l_discount, l_quantity
        From Lineitem 
        Where l_extendedprice <= 104950)
		
        Select n_name, extract(year from o_orderdate) as o_year, SUM((l_extendedprice * (1 - l_discount)) - ps_supplycost * l_quantity) as amount 
        From Part, Orders, Partsupp, supplier, LineitemView, Nation 
        Where s_suppkey = l_suppkey
		and ps_suppkey = l_suppkey
		and ps_partkey = l_partkey
		and p_partkey = l_partkey
		and o_orderkey = l_orderkey
		and s_nationkey = n_nationkey
		and p_name like '%green%'
        Group by 
              n_name,
              o_year
         order by
              n_name,
              o_year desc
;
