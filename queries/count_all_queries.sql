select
   	count(*)	
from
	customer,
	orders,
	lineitem
where
	c_mktsegment = 'BUILDING'
	and c_custkey = o_custkey
	and l_orderkey = o_orderkey
	and o_orderdate < date '1995-03-15'
	and l_shipdate > date '1995-03-15'
;

select
 	count(*)	
from
	lineitem
where
	l_shipdate >= date '1994-01-01'
	and l_shipdate < date '1994-01-01' + interval '1' year
	and l_discount between 0.05 and 0.07
	and l_quantity < 24;
select
 	count(*)	
from
	(
		select
			n_name as nation,
			extract(year from o_orderdate) as o_year,
			l_extendedprice * (1 - l_discount) - ps_supplycost * l_quantity as amount
		from
			part,
			supplier,
			lineitem,
			partsupp,
			orders,
			nation
		where
			s_suppkey = l_suppkey
			and ps_suppkey = l_suppkey
			and ps_partkey = l_partkey
			and p_partkey = l_partkey
			and o_orderkey = l_orderkey
			and s_nationkey = n_nationkey
			and p_name like '%green%'
	) as profit
;
select
 	count(*)	
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and p_brand = 'Brand#23'
	and p_container = 'MED BOX'
	and l_quantity < (
		select
			0.2 * avg(l_quantity)
		from
			lineitem
		where
			l_partkey = p_partkey
	);
select
 	count(*)	
from
	lineitem,
	part
where
	p_partkey = l_partkey
	and (l_shipmode = 'AIR' or l_shipmode = 'AIR REG')
	and l_shipinstruct = 'DELIVER IN PERSON'
	and ((
		p_brand = 'Brand#12'
		and (p_container = 'SM CASE' or p_container = 'SM BOX' or p_container = 'SM PACK' or p_container = 'SM PKG')
		and l_quantity >= 1 and l_quantity <= 1 + 10
		and p_size between 1 and 5
	)
	or
	(
		p_brand = 'Brand#23'
		and (p_container = 'MED BAG' or p_container = 'MED BOX' or p_container = 'MED PKG' or p_container = 'MED PACK')
		and l_quantity >= 10 and l_quantity <= 10 + 10
		and p_size between 1 and 10
	)
	or
	(
		p_brand = 'Brand#34'
		and (p_container = 'LG CASE' or p_container = 'LG BOX' or p_container = 'LG PACK' or p_container = 'LG PKG')
		and l_quantity >= 20 and l_quantity <= 20 + 10
		and p_size between 1 and 15
	));
