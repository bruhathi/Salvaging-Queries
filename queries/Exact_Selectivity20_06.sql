select SUM(l_extendedprice * l_discount) as revenue
from lineitem
where l_shipdate < date '1993-06-28';
