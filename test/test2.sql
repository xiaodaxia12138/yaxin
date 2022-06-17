drop table temp_hlw_operation_calss_special_privi_xiao2;
create table temp_hlw_operation_calss_special_privi_xiao2 as
select t1.product_no,t1.county_name,
        case when t2.priv_type in ('1元包','套餐折扣','1元合约包') then 1 else 0 end as is_all,
        case when t2.priv_type  ='1元包'  then 1 else 0 end as is_1yuan,
        case when t2.priv_type ='1元合约包' then 1 else 0 end as is_1yuanheyue,
        case when t2.priv_type  ='套餐折扣' then 1 else 0 end as is_tczk,
        case when t3.product_no is not null then 1 else 0 end as is_ywzk, 
        case when t4.product_no is not null then 1 else 0 end as is_yzx,
        case when t3.product_no is null and t4.product_no is null then 1 else 0 end as is_qt,
        case when t5.z_product_no is not null then 1 else 0 end as is_fk,
        t6.priv_fee as fee_0,
        t7.priv_fee as fee_1
from
(
    select distinct product_no,county_name
    from cqbassdb.dw_product_outetype_dt_20211231 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t1 -- 目标用户
left join 
( 
    select distinct a.product_no,a2.priv_type,a2.privsetid
    from cqbassdb.dw_operation_req_202205 as  a
    inner join hlw_dim_special_permi_privilege a2 on a.operate_code=a2.privsetid
    where a.status = 1 and (a.operate_desc like'加入%' or a.operate_desc like'参加%')
    and a.op_time <= '2022-05-31'
) t2 on t1.product_no=t2.product_no -- 目标套餐
left join 
( 
    select distinct a.product_no
    from
    (
        select product_no from hlw_dim_ywsk_yinghui_user a1  where is_yinghui=1
        union all 
        select product_no from hlw_dw_ywsk_userinfo_mm_202205 a2 
    ) a

) t3 on t1.product_no = t3.product_no -- 异网主卡客户
left join 
(   
    select distinct product_no
    from hlw_dw_xiezhuan_user_score3_info_202205
    where s_level='重度'
) t4 on t1.product_no=t4.product_no  -- 易携转
left join
(
    select  distinct z_product_no          -- 主卡号码
                                  -- 副卡号码product_no
    from cqbassdb.dw_zzqs_user_sxk_detail_dt_20220531
    where is_zk_priv='否' and createdate between '2022-05-01' and '2022-05-31'
) t5 on t1.product_no=t5.z_product_no  -- 副卡 
left join 
(
    select distinct product_no ,priv_fee
    from cqbassdb.dw_user_priv_value_info_dt_20220430
) t6 on t1.product_no=t6.product_no
left join 
(
    select distinct product_no ,priv_fee
    from cqbassdb.dw_user_priv_value_info_dt_20220531
) t7 on t1.product_no=t7.product_no
where t2.product_no is not null 

