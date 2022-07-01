drop table temp_hlw_monitor_income_kexuanbo_202204;
create table temp_hlw_monitor_income_kexuanbo_202204(
    month_id varchar(10),
    op_time date,
    county_name varchar(50),
    type varchar(100),
    privsetid varchar(100),
    priv_name varchar(100),
    price decimal(10,2),
    channel_type varchar(100),
    channel_type1 varchar(100)
) distributed by ('price');


-- 插入当月所需明细数据
insert into temp_hlw_monitor_income_kexuanbo_202204
select  '当月',
        t1.op_time,
        t4.county_name,
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202204 t1        -- 当月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code      -- 最新维表，不管
left join 
(
    select distinct a.product_no,a.user_id,            
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(b.county_name,'其他')
            end as county_name
    from cqbassdb.dw_product_outetype_dt_20220430 a                                  -- 需要county_id
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
;

-- 插入同比月明细数据
insert into temp_hlw_monitor_income_kexuanbo_202204
select  '同比月',
        t1.op_time,
        t4.county_name,
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202104 t1         -- 同比月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,            
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(b.county_name,'其他')
            end as county_name
    from cqbassdb.dw_product_outetype_dt_20210430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
;

-- 插入环比月所需明细数据
insert into temp_hlw_monitor_income_kexuanbo_202204
select  '环比月',
        t1.op_time,
        t4.county_name,
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202203 t1        -- 上月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code      -- 最新维表，不管
left join 
(
    select distinct a.product_no,a.user_id,
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(b.county_name,'其他')
            end as county_name
    from cqbassdb.dw_product_outetype_dt_20220331 a                                  -- 需要county_id
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
;

select * from temp_hlw_monitor_income_kexuanbo_202204
-- 输出表1：2022-04-30
select  '2022-04','2022-04-30' ,county_name ,
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end) as value2,

        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2021-03-31' then price end)-1 as value4,

        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2021-03-31' then price end)-1 as value7

        
from temp_hlw_monitor_income_kexuanbo_202203
group by month_id, op_time,county_name


























-- 输出表1_planB
drop table temp_hlw_monitor_income_county_name_20220402;
create table temp_hlw_monitor_income_county_name_20220402 as
select  t1.month,t1.op_time,t1.county_name,t1.cnt_1,t1.income_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1 else t1.sum_1+t4.sum_1 end as sum_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_2 else t1.sum_2+t4.sum_2 end as sum_2,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1-t2.sum_1 else t1.sum_1+t4.sum_1- t2.sum_1 end as tongbi_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1-t2.sum_2 else t1.sum_2+t4.sum_2- t2.sum_2 end as tongbi_2,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1-t3.sum_1 else t1.sum_1+t4.sum_1- t3.sum_1 end as huanbi_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1-t3.sum_2 else t1.sum_2+t4.sum_2- t3.sum_2 end as huanbi_2
        
from temp_hlw_monitor_income_0_county_name_20220402 t1    -- 当天明细表
left join temp_hlw_monitor_income_county_name_20210402 t2 on t1.county_name=t2.county_name   -- 同比中间表
left join temp_hlw_monitor_income_county_name_20220401 t3 on t1.county_name=t3.county_name   -- 环比中间表
left join temp_hlw_monitor_income_county_name_20210401 t4 on t1.county_name=t4.county_name   -- 昨天表
;



drop table temp_hlw_monitor_income_county_name_20210401;
create table temp_hlw_monitor_income_county_name_20210401 as
select  t1.month,t1.op_time,t1.county_name,t1.cnt_1,t1.income_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_1 else t1.sum_1+t4.sum_1 end as sum_1,
        case when substr(t1.op_time,9,2)=01 then t1.sum_2 else t1.sum_2+t4.sum_2 end as sum_2,
        t1.sum_1-t2.sum_1 as tongbi_1 ,
        t1.sum_2-t2.sum_2 as tongbi_2 ,
        t1.sum_1-t3.sum_1 as huanbi_1 ,
        t1.sum_2-t3.sum_2 as huanbi_2
        
from temp_hlw_monitor_income_0_county_name_20220401 t1
left join temp_hlw_monitor_income_0_county_name_20210401 t2 on t1.county_name=t2.county_name   -- 同比中间表
left join temp_hlw_monitor_income_0_county_name_20220301 t3 on t1.county_name=t3.county_name   -- 环比中间表
left join temp_hlw_monitor_income_0_county_name_20210401 t4 on t1.county_name=t4.county_name   -- 昨天表
;





















-- 输出表1：
drop table temp_hlw_monitor_income_county_name_20220401;
create table temp_hlw_monitor_income_county_name_20220401 as

select t1.month,t1.op_time,t1.county_name,t1.cnt_1,t1.income_1,t1.sum_1,t1.sum_2,
        t1.sum_1-t2.sum_1 as tongbi_1 ,
        t1.sum_2-t2.sum_2 as tongbi_2 ,
        t1.sum_1-t3.sum_1 as huanbi_1 ,
        t1.sum_2-t3.sum_2 as huanbi_2

from
(
    select substr(op_time,6,2) as month,op_time,
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(county_name,'其他')
        end as county_name,
        count(privsetid) as cnt_1,
        sum(cast( price AS DECIMAL(20,2) )) as income_1,
        count(privsetid) as sum_1,
        sum(cast( price AS DECIMAL(20,2) )) as sum_2
    from temp_hlw_monitor_income_kexuanbo_202204
    where op_time='2022-04-01'
    group by  op_time,
                case when county_name in ('南岸','渝中') then '城一'
                    when county_name in ('渝北','江北','两江新区') then '城二'
                    when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                else nvl(county_name,'其他')
                end
) t1 
left join
(
    select  county_name,
            count(privsetid) as sum_1,
            sum(cast( price AS DECIMAL(20,2) )) as sum_2
    from temp_hlw_monitor_income_kexuanbo_202104   -- 计算同比
    where op_time='2021-04-01'
) t2 on t1.county_name=t2.county_name
left join
(
    select  county_name,
            count(privsetid) as sum_1,
            sum(cast( price AS DECIMAL(20,2) )) as sum_2
    from temp_hlw_monitor_income_kexuanbo_202203    -- 计算环比
    where op_time='2022-03-01'
) t3 on t1.county_name=t3.county_name
union all 
(
     select substr(op_time,6,2) as month,op_time,'全市',

        count(privsetid) as cnt_1,
        sum(cast( price AS DECIMAL(20,2) )) as income_1,
        0+count(privsetid) as sum_1,
        0+sum(cast( price AS DECIMAL(20,2) )) as sum_2
    from temp_hlw_monitor_income_kexuanbo_202204
    where op_time='2022-04-01'
    group BY op_time
) t1 

;


















