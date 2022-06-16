drop table temp_hlw_operation_calss_special_privi_suchu;
create table temp_hlw_operation_calss_special_privi_suchu
(
    cust_type varchar(30),
    county_name varchar(10),
    voulme_bl int,
    voulme_bl_fk int,
    priv_fee_0 decimal(10,2),
    priv_fee_1 decimal(10,2),
    arpu_avg decimal(10,5),
    is_ct varchar(5),
    ct decimal(5,5)
) distributed by ('county_name');



-- 输出表：
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
        end,
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
select '全量特殊权限-易携转重度','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 and p.is_yzx=1 
-- 3——阀值计算
union all

select '全量特殊权限-其他客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end,
        sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 and p.is_qt=1 
    group by case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end 
union all
select '全量特殊权限-其他客户','合计',sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_0) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e,
        null as f,null as g
from temp_hlw_operation_calss_special_privi_xiao p
where p.is_all =1 and p.is_qt=1 
-- 4
union all

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
where p.is_1yuan=1 and  p.is_qt=1
-- 8
union all

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
where p.is_1yuanheyue=1 and p.is_qt=1
-- 12
union all

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

