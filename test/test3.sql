drop table temp_hlw_monitor_income_kexuanbo_20220430;
create table temp_hlw_monitor_income_kexuanbo_20220430(
    month_id varchar(10),
    op_time date,
    user_id varchar(100),
    county_name varchar(50),
    type varchar(100),
    privsetid varchar(100),
    priv_name varchar(100),
    price decimal(10,2),
    channel_type varchar(100),
    channel_type1 varchar(100)
) distributed by ('price');


-- 插入当月所需明细数据
insert into temp_hlw_monitor_income_kexuanbo_20220430
select  '当月',
        t1.op_time,t1.user_id,
        nvl(t4.county_name,'其他'),
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202204 t1        -- 当月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
inner join temp_hlw_dim_oper_channel_type_xiao_20220430 t3 on t1.oper_code=t3.oper_code      -- 最新维表，不管
left join 
(
    select distinct a.product_no,a.user_id,            
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else b.county_name
            end as county_name
    from cqbassdb.dw_product_dt_20220430 a                                  -- 需要county_id
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 
) t4 on t1.product_no=t4.product_no
where t1.status=1 and (t1.operate_desc like '加入%' or '参加%')
;

-- 插入同比月明细数据
insert into temp_hlw_monitor_income_kexuanbo_20220430
select  '同比月',
        t1.op_time,t1.user_id,
        nvl(t4.county_name,'其他'),
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202104 t1         -- 同比月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
inner join temp_hlw_dim_oper_channel_type_xiao_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,            
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(b.county_name,'其他')
            end as county_name
    from cqbassdb.dw_product_dt_20210430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1
) t4 on t1.product_no=t4.product_no
where t1.status=1 and (t1.operate_desc like '加入%' or '参加%')
;

-- 插入环比月所需明细数据
insert into temp_hlw_monitor_income_kexuanbo_20220430
select  '环比月',
        t1.op_time,t1.user_id,
        nvl(t4.county_name,'其他'),
        t2.type,t2.privsetid,t2.priv_name,
        t2.price,t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202203 t1        -- 上月
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
inner join temp_hlw_dim_oper_channel_type_xiao_20220430 t3 on t1.oper_code=t3.oper_code      -- 最新维表，不管
left join 
(
    select distinct a.product_no,a.user_id,
            case when b.county_name in ('南岸','渝中') then '城一'
             when b.county_name in ('渝北','江北','两江新区') then '城二'
             when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else nvl(b.county_name,'其他')
            end as county_name
    from cqbassdb.dw_product_dt_20220331 a                                  -- 需要county_id
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 
) t4 on t1.product_no=t4.product_no
where t1.status=1 and (t1.operate_desc like '加入%' or '参加%')
;

select count(1) from temp_hlw_monitor_income_kexuanbo_20220430
where month_id = '当月'

-- 输出表1_分公司分类：2022-04-30
drop table temp_hlw_monitor_income_kexuanbo_county_20220430;
create table temp_hlw_monitor_income_kexuanbo_county_20220430(
    month_id varchar(20),
    day_id date,
    county_name varchar(50),    -- 分公司
    value1 int,                 -- 当日销量
    value2 decimal(20,4),       -- 当日收入（万元）
    value3 int,                 -- 当月销量累计
    value4 decimal(20,4),       -- 销量月累计同比
    value5 decimal(20,4),       -- 销量月累计环比
    value6 decimal(20,4),       -- 当月收入（万元）
    value7 decimal(20,4),       -- 月收入同比
    value8 decimal(20,4)        -- 月收入环比  
) ;

insert into temp_hlw_monitor_income_kexuanbo_county_20220430
select  '2022-04','2022-04-30' ,county_name ,
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8    
from temp_hlw_monitor_income_kexuanbo_20220430
group by county_name
;
insert into temp_hlw_monitor_income_kexuanbo_county_20220430
select '2022-04','2022-04-30' ,'全市',
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8  
from temp_hlw_monitor_income_kexuanbo_20220430
;
-- 输出表2_渠道分类：2022-04-30
drop table temp_hlw_monitor_income_kexuanbo_channel_20220430;
create table temp_hlw_monitor_income_kexuanbo_channel_20220430(
    month_id varchar(20),
    day_id date,
    channel_type1 varchar(50),   -- 渠道大类
    channel_type varchar(50),    -- 渠道小类
    value1 int,   
    value2 decimal(20,4),
    value3 int,
    value4 decimal(20,4),
    value5 decimal(20,4),
    value6 decimal(20,4),
    value7 decimal(20,4),
    value8 decimal(20,4)   
) ;

insert into temp_hlw_monitor_income_kexuanbo_channel_20220430
select  '2022-04','2022-04-30' ,channel_type1 ,'合计',
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8    
from temp_hlw_monitor_income_kexuanbo_20220430
group by channel_type1
;
insert into temp_hlw_monitor_income_kexuanbo_channel_20220430
select '2022-04','2022-04-30' ,'全市','合计',
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8  
from temp_hlw_monitor_income_kexuanbo_20220430
;
insert into temp_hlw_monitor_income_kexuanbo_channel_20220430
select  '2022-04','2022-04-30' ,channel_type1 ,channel_type,
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8    
from temp_hlw_monitor_income_kexuanbo_20220430
group by channel_type1,channel_type
;

-- 输出表3_业务类型分类：2022-04-30
drop table temp_hlw_monitor_income_kexuanbo_type_20220430;
create table temp_hlw_monitor_income_kexuanbo_type_20220430(
    month_id varchar(20),
    day_id date,
    type varchar(50),       -- 业务类型
    value1 int,   
    value2 decimal(20,4),
    value3 int,
    value4 decimal(20,4),
    value5 decimal(20,4),
    value6 decimal(20,4),
    value7 decimal(20,4),
    value8 decimal(20,4)   
) ;

insert into temp_hlw_monitor_income_kexuanbo_type_20220430
select  '2022-04','2022-04-30' ,type ,
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8    
from temp_hlw_monitor_income_kexuanbo_20220430
group by type
;
insert into temp_hlw_monitor_income_kexuanbo_type_20220430
select '2022-04','2022-04-30' ,'合计',
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8  
from temp_hlw_monitor_income_kexuanbo_20220430
;


-- 输出表4_具体业务分类：2022-04-30
drop table temp_hlw_monitor_income_kexuanbo_priv_20220430;
create table temp_hlw_monitor_income_kexuanbo_priv_20220430(
    month_id varchar(20),
    day_id date,
    type varchar(50),        -- 业务类型
    priv_name varchar(100),   -- 具体业务
    value1 int,   
    value2 decimal(20,4),
    value3 int,
    value4 decimal(20,4),
    value5 decimal(20,4),
    value6 decimal(20,4),
    value7 decimal(20,4),
    value8 decimal(20,4)   
) ;

insert into temp_hlw_monitor_income_kexuanbo_priv_20220430
select  '2022-04','2022-04-30' ,type ,priv_name,
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8    
from temp_hlw_monitor_income_kexuanbo_20220430
group by type,priv_name
;
insert into temp_hlw_monitor_income_kexuanbo_priv_20220430
select '2022-04','2022-04-30' ,'合计','合计',
        count(case when month_id='当月' and op_time='2022-04-30' then price end) as value1,
        sum(case when month_id='当月' and op_time='2022-04-30' then price end)/10000 as value2,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end) as value3,        
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value4,
        count(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        count(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value5,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/10000 as value6,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='同比月' and op_time between '2021-04-01' and '2021-04-30' then price end)-1 as value7,
        sum(case when month_id='当月' and op_time between '2022-04-01' and '2022-04-30' then price end)/ 
        sum(case when month_id='环比月' and op_time between '2022-03-01' and '2022-03-31' then price end)-1 as value8  
from temp_hlw_monitor_income_kexuanbo_20220430
;
