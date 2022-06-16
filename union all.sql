union all 
select '全量特殊权限-其他客户',p1.a,p1.b,p1.c,p1.d,p1.e,null as f ,p1.m-fz as g
from
(
    select '合计' as na,sum(p.is_all) as a,sum(p.is_fk) as b ,
        sum(p.fee_0) as c ,sum(p.fee_0) as d,(sum(p.fee_1)-sum(p.fee_0))/sum(p.is_all) as e,
        sum(p.is_all) as m
    from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 and p.is_qt=1
) p1
left join 
(
    select '合计' as na ,count(distinct product_no)*0.00065/30*31 as fz
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) p2 on p1.na=p2.na

