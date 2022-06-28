drop table temp_hlw_monitor_income_kexuanbo_202104;  -- 计算同比
create table temp_hlw_monitor_income_kexuanbo_202104(
    op_time date,
    county_name varchar(50),
    type varchar(100),
    privsetid varchar(100),
    priv_name varchar(100),
    price varchar(100),
    channel_type varchar(100),
    channel_type1 varchar(100)
) distributed by ('privsetid');
insert into temp_hlw_monitor_income_kexuanbo_202104
select  t1.op_time,
        t4.county_name,
        t2.type,t2.price,t2.privsetid,t2.priv_name,
        t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202104 t1
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,b.county_name
    from cqbassdb.dw_product_outetype_dt_20210430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
;
drop table temp_hlw_monitor_income_kexuanbo_202203;  -- 计算环比
create table temp_hlw_monitor_income_kexuanbo_202203(
    op_time date,
    county_name varchar(50),
    type varchar(100),
    privsetid varchar(100),
    priv_name varchar(100),
    price varchar(100),
    channel_type varchar(100),
    channel_type1 varchar(100)
) distributed by ('privsetid');
insert into temp_hlw_monitor_income_kexuanbo_202203
select  t1.op_time,
        t4.county_name,
        t2.type,t2.price,t2.privsetid,t2.priv_name,
        t3.channel_type,t3.channel_type1
from cqbassdb.dw_operation_req_202203 t1
inner join
(
    select a.f1 as type,a.f2 as priv_name,a.f3 as privsetid,a.f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_20220430 a where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid
left join hlw_dim_oper_channel_style_20220430 t3 on t1.oper_code=t3.oper_code
left join 
(
    select distinct a.product_no,a.user_id,b.county_name
    from cqbassdb.dw_product_outetype_dt_20220331 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t4 on t1.product_no=t4.product_no
;