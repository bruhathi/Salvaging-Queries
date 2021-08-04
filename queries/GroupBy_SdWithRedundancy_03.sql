-- sample on lineitem.
WITH LineitemView (l_orderkey, l_shipdate, l_extendedprice, l_discount) AS 
        (Select l_orderkey, l_shipdate, l_extendedprice, l_discount
        From Lineitem
        Where l_extendedprice <= 104950)
		
        Select l_orderkey, o_orderdate, o_shippriority, SUM(l_extendedprice * (1 - l_discount)) as revenue 
        From Customer, Orders, LineitemView 
        Where c_mktsegment = 'BUILDING'
			and c_custkey = o_custkey
			and l_orderkey = o_orderkey
			and o_orderdate < date '1995-03-15'
			and l_shipdate > date '1995-03-15'
	Group by 
          l_orderkey,
	  o_orderdate,
	  o_shippriority
Order by
  revenue desc,
  o_orderdate
limit 10
;
