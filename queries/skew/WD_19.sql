-- sample part.
WITH PartView (p_partkey, p_brand, p_container, p_size) AS 
        (Select p_partkey, p_brand, p_container, p_size
        From Part 
        Where p_partkey <= 20000000),
				
D1 (revenue) AS 
        (Select SUM(l_extendedprice * (1 - l_discount)) as revenue 
        From Lineitem, PartView 
        Where
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
	))
        ),
		
--V3 (sum_v2, count_v2) AS
--        (Select SUM(revenue) as s, COUNT(*) as c
--        From D1),
		
PartViewCount (count_part) AS
	(Select COUNT(*) as c
	From PartView)
		
Select SUM(a) as estimate_value
From (Select SUM(revenue * 20000000 / PartViewCount.count_part) as a
	From D1, PartViewCount) main;
