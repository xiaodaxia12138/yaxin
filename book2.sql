drop table temp_hlw_monitor_income_kexuanbo_20220402;
create table temp_hlw_monitor_income_kexuanbo_20220402(
    time_type varchar(10),
    op_time date,
    user_id varchar(100),
    product_no varchar(100),
    county_name varchar(50),
    type varchar(100),
    privsetid varchar(100),
    priv_name varchar(100),
    price varchar(100),
    channel_type varchar(100),
    channel_type1 varchar(100)
) distributed by ('privsetid');

insert into temp_hlw_monitor_income_kexuanbo_20220402
select  '当月',
        t1.op_time,
        t1.user_id,
        t1.product_no,
        nvl(t4.county_name,'其他'),
        t2.type,t2.price,t2.privsetid,t2.priv_name,
        t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202204 t1
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a 
    where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,
                    case when b.county_name is null then '其他'
                         when b.county_name in ('南岸','渝中') then '城一'
                         when b.county_name in ('渝北','江北','两江新区') then '城二'
                         when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三'                         
                    else county_name end as county_name
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
where t1.op_time between '2022-04-01' and '2022-04-02'
and  t1.status = 1 and (t1.operate_desc like'加入%' or t1.operate_desc like'参加%')
;


insert into temp_hlw_monitor_income_kexuanbo_20220402
select  '环比月',
        t1.op_time,
        t1.user_id,
        t1.product_no,
        nvl(t4.county_name,'其他'),
        t2.type,t2.price,t2.privsetid,t2.priv_name,
        t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202104 t1
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a 
    where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,
                    case when b.county_name in ('南岸','渝中') then '城一'
                         when b.county_name in ('渝北','江北','两江新区') then '城二'
                         when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                         when b.county_name is null then '其他'
                    else county_name end as county_name
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
where t1.op_time between '2021-04-01' and '2021-04-02'
and  t1.status = 1 and (t1.operate_desc like'加入%' or t1.operate_desc like'参加%')
;

insert into temp_hlw_monitor_income_kexuanbo_20220402
select  '同比月',
        t1.op_time,
        t1.user_id,
        t1.product_no,
        nvl(t4.county_name,'其他'),
        t2.type,t2.price,t2.privsetid,t2.priv_name,
        t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202203 t1
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a 
    where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,
                    case when b.county_name in ('南岸','渝中') then '城一'
                         when b.county_name in ('渝北','江北','两江新区') then '城二'
                         when b.county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
                         when b.county_name is null then '其他'
                    else county_name end as county_name
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
where t1.op_time between '2022-03-01' and '2022-03-02'
and  t1.status = 1 and (t1.operate_desc like'加入%' or t1.operate_desc like'参加%')
;