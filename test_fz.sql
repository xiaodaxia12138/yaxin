select  '全量特殊权限-其他客户',
        k1.name,
        k1.a,k1.b,k1.c,k1.d,k1.e,
        case when k1.a > k2.fz then '是' else '否' end as is_ct,
        case when k1.a > k2.fz then k1.a-k2.fz else null end as ct
from
(
    select case when p.county_name in ('南岸','渝中') then '城一'
             when p.county_name in ('渝北','江北','两江新区') then '城二'
             when p.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else p.county_name
            end as name,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 and p.is_qt =1
    group by case when p.county_name in ('南岸','渝中') then '城一'
             when p.county_name in ('渝北','江北','两江新区') then '城二'
             when p.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else p.county_name
        end
) k1
left join
(
    select case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else b.county_name
            end as name,
            count(distinct product_no)*0.00065/30*31 as fz
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
    group by case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else b.county_name
            end 
) k2 on  k1.name= k2.name