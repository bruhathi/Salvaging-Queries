-- sample on customer.
WITH CustView (c_custkey, c_mktsegment) AS 
        (Select c_custkey, c_mktsegment
        From Customer 
        Where c_acctbal <= 10001)
		
        Select l_orderkey, o_orderdate, o_shippriority, SUM(l_extendedprice * (1 - l_discount)) as revenue 
        From CustView, Orders, Lineitem 
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
