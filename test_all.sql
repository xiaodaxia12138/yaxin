drop table temp_hlw_operation_calss_special_privi_shuchu;
create table temp_hlw_operation_calss_special_privi_shuchu
(
    cust_type varchar(30),
    county_name varchar(10),
    voulme_bl int,
    voulme_bl_fk int,
    priv_fee_0 decimal(10,2),
    priv_fee_1 decimal(10,2),
    arpu_avg decimal(10,5),
    is_ct varchar(5),
    ct decimal(20,5)
) distributed by ('cust_type');



-- 输出表：
insert into temp_hlw_operation_calss_special_privi_shuchu 
select '全量特殊权限-合计',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end ,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 
    group by case when county_name in ('南岸','渝中') then '城一'
                  when county_name in ('渝北','江北','两江新区') then '城二'
                  when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                  else county_name
            end 
union all
select '全量特殊权限-合计','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 
-- 1
union all

select '全量特殊权限-异网主卡',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end ,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 and p.is_ywzk=1 
    group by case when county_name in ('南岸','渝中') then '城一'
                  when county_name in ('渝北','江北','两江新区') then '城二'
                  when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                  else county_name
            end 
union all
select '全量特殊权限-异网主卡','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 and p.is_ywzk=1 
-- 2
union all

select '全量特殊权限-易携转重度',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end ,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 and p.is_yzx=1 
    group by case when county_name in ('南岸','渝中') then '城一'
                  when county_name in ('渝北','江北','两江新区') then '城二'
                  when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                  else county_name
            end 
union all
select '全量特殊权限客户-易携转重度','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 and p.is_yzx=1 
-- 3
union all

select  '全量特殊权限客户-其他客户',
        k1.name,
        k1.a,k1.b,k1.c,k1.d,k1.e,
        case when k1.a > k2.fz then '是' else '否' end as is_ct,
        k1.a-k2.fz  as ct
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
union all 
select '全量特殊权限-其他客户',p1.na,p1.a,p1.b,p1.c,p1.d,p1.e,null as f ,p1.m-fz as g
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
) p2 on p1.na=p2.na;
-- 4——阀值计算

insert into temp_hlw_operation_calss_special_privi_shuchu

select '1元包-合计',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_1yuan=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包-合计','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuan=1
-- 5
union all

select '1元包-异网主卡',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuan=1 and  p.is_ywzk=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包-异网主卡','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuan=1 and  p.is_ywzk=1
-- 6
union all

select '1元包-易携转重度客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuan=1 and  p.is_yzx=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包-易携转重度客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuan=1 and  p.is_yzx=1
-- 7
union all

select '1元包-其他客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuan=1 and  p.is_qt=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包-其他客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuan=1 and  p.is_qt=1;
-- 8
insert into temp_hlw_operation_calss_special_privi_shuchu

select '1元包(合约版)-合计',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuanheyue=1 
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包(合约版)-合计','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuanheyue=1
-- 9
union all

select '1元包(合约版)-异网主卡客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuanheyue=1 and p.is_ywzk=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包(合约版)-异网主卡客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuanheyue=1 and p.is_ywzk=1
-- 10
union all

select '1元包(合约版)-易携转重度客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuanheyue=1 and p.is_yzx=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包(合约版)-易携转重度客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuanheyue=1 and p.is_yzx=1
-- 11
union all

select '1元包(合约版)-其他客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_1yuanheyue=1 and p.is_qt=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '1元包(合约版)-其他客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_1yuanheyue=1 and p.is_qt=1;
-- 12
insert into temp_hlw_operation_calss_special_privi_shuchu

select '套餐折扣-合计',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_tczk=1 
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '套餐折扣-合计','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_tczk
-- 13
union all

select '套餐折扣-异网主卡客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_tczk=1 and p.is_ywzk=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '套餐折扣-异网主卡客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_tczk and p.is_ywzk=1
-- 14
union all

select '套餐折扣-易携转重度客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_tczk=1 and p.is_yzx=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '套餐折扣-易携转重度客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_tczk and p.is_yzx=1
-- 15
union all

select '套餐折扣-其他客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where  p.is_tczk=1 and p.is_qt=1
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '套餐折扣-其他客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_tczk and p.is_qt=1
-- 16
;

