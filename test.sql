drop table temp_hlw_operation_calss_special_privi_xiao;
create table temp_hlw_operation_calss_special_privi_xiao as
select  t1.product_no,t1.county_name,
        t7.is_all,t7.is_1yuan,t7.is_1yuanheyue,t7.is_tczk,
        case when t2.product_no is not null then 1 else 0 end as is_ywzk, 
        case when t3.product_no is not null then 1 else 0 end as is_yzx,
        case when t2.product_no is null and t3.product_no is null then 1 else 0 end as is_qt,
        t4.product_no,
        case when t4.product_no is not null then 1 else 0 end as is_fk,
        t5.priv_fee as fee_0,
        t6.priv_fee as fee_1
from
( 
    select distinct product_no,county_name
    from cqbassdb.dw_product_outetype_dt_20211231 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t1
left join 
( 
    select product_no
    from hlw_dim_ywsk_yinghui_user 
    where is_yinghui=1 
) t2 on t1.product_no = t2.product_no
left join 
(   
    select product_no
    from hlw_dw_xiezhuan_user_score3_info_202205
    where s_level='重度'
) t3 on t1.product_no=t3.product_no
left join
(
    select  z_product_no,           -- 主卡号码
            product_no              -- 副卡号码
    from cqbassdb.dw_zzqs_user_sxk_detail_dt_20220531
    where is_zk_priv='否' and createdate between '2022-05-01' and '2022-05-31'
) t4 on t1.product_no=t4.z_product_no
left join 
(
    select product_no ,priv_fee
    from cqbassdb.dw_user_priv_value_info_dt_20220430
) t5 on t1.product_no=t5.product_no
left join 
(
    select product_no ,priv_fee
    from cqbassdb.dw_user_priv_value_info_dt_20220531
) t6 on t1.product_no=t6.product_no
left join temp_operation_calss_special_privi_all t7 on t1.product_no=t7.product_no
;

-- 输出表：
select  k1.county_name,k1.a,k1.b,k1.c,k1.d,k1.e,k2.fz,
        case when k1.a > k2.fz then '是' else '否' end as is_ct,
        case when k1.a > k2.fz then k1.a-k2.fz else null end as ct,
        k1.a-k2.fz
from
(
    select county_name,sum(is_all) as a,sum(is_fk) as b ,
        sum(fee_0) as c ,sum(fee_1) as d,(sum(fee_1)-sum(fee_0))/sum(is_all) as e
    from temp_hlw_operation_calss_special_privi_xiao p
    where p.is_all =1 
    group by county_name 
) k1
left join
(
    select county_name,count(product_no)*0.00065/30*31 as fz
    from cqbassdb.dw_product_outetype_dt_20220430 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
    group by county_name
) k2 on  k1.county_name= k2.county_name
union all 
(
    select 
)


























drop table temp_operation_calss_special_privi_all;
create table temp_operation_calss_special_privi_all as 
select  distinct product_no,
case when operate_code in 
('gl_tczk_new_1',
'gl_tczk_new_2',
'gl_tczk_new_3',
'gl_tczk_new_4',
'gl_tczk_new_5',
'gl_tczk_new_6',
'gl_tczk_new_7',
'gl_tczk_new_8',
'gl_tczk_new_9',
'gl_tczk_new_10',
'gl_tczk_new_11',
'gl_tczk_new_12',
'gl_tczk_new_13',
'gl_tczk_new_14',
'gl_tczk_new_15',
'gl_tc95zyh_3y',
'gl_tc9zyh_3y',
'gl_tc85zyh_3y',
'gl_tc8zyh_3y',
'gl_tc75zyh_3y',
'gl_tc7zyh_3y',
'gl_tc95zyh_6y',
'gl_tc9zyh_6y',
'gl_tc85zyh_6y',
'gl_tc8zyh_6y',
'gl_tc75zyh_6y',
'gl_tc7zyh_6y',
'gl_tc95zyh_12y',
'gl_tc9zyh_12y',
'gl_tc85zyh_12y',
'gl_tc8zyh_12y',
'gl_tc75zyh_12y',
'gl_tc7zyh_12y',
'gl_5gzzf_qyxn_1',
'gl_5gzzf_qyxn_2',
'gl_5gzzf_qyxn_3',
'gl_5gzzf_qyxn_4',
'gl_5gzzf_qyxn_5',
'gl_5gzzf_qyxn_6',
'gl_5gzzf_qyxn_7',
'gl_5gzzf_qyxn_8',
'gl_5gzzf_qyxn_9',
'gl_1yyb_1000fz',
'gl_1yyb_500fz',
'gl_1yyb_200fz',
'gl_1yyb_300fz',
'gl_1yyb_800fz',
'gl_1yyb_100fz',
'gl_1yyb_1000fzhy',
'gl_1yyb_500fzhy',
'gl_1yyb_800fzhy',
'gl_1yyb_200fzhy',
'gl_1yyb_300fzhy',
'gl_1yyb_100fzhy',
'pl_1y10g_1',
'pl_1y20g_1',
'pl_1y30g_1',
'pl_1y5g_1',
'locpp.10047646',
'locpp.10047648',
'locpp.10047650',
'locpp.10047652',
'locpp.10047634',
'locpp.10047636',
'locpp.10047638',
'locpp.10047654',
'locpp.10047656',
'locpp.10047658',
'locpp.10047660',
'locpp.10047640',
'locpp.10047642',
'locpp.10047644') then 1 else 0 end as is_all,
case when  operate_code in 
(
'gl_1yyb_1000fz',
'gl_1yyb_500fz',
'gl_1yyb_200fz',
'gl_1yyb_300fz',
'gl_1yyb_800fz',
'gl_1yyb_100fz',
'gl_1yyb_1000fzhy',
'gl_1yyb_500fzhy',
'gl_1yyb_800fzhy',
'gl_1yyb_200fzhy',
'gl_1yyb_300fzhy',
'gl_1yyb_100fzhy',
'pl_1y10g_1',
'pl_1y20g_1',
'pl_1y30g_1',
'pl_1y5g_1'
)then 1 else 0 end as is_1yuan,
case when operate_code in
(
'gl_tczk_new_1',
'gl_tczk_new_2',
'gl_tczk_new_3',
'gl_tczk_new_4',
'gl_tczk_new_5',
'gl_tczk_new_6',
'gl_tczk_new_7',
'gl_tczk_new_8',
'gl_tczk_new_9',
'gl_tczk_new_10',
'gl_tczk_new_11',
'gl_tczk_new_12',
'gl_tczk_new_13',
'gl_tczk_new_14',
'gl_tczk_new_15',
'gl_tc95zyh_3y',
'gl_tc9zyh_3y',
'gl_tc85zyh_3y',
'gl_tc8zyh_3y',
'gl_tc75zyh_3y',
'gl_tc7zyh_3y',
'gl_tc95zyh_6y',
'gl_tc9zyh_6y',
'gl_tc85zyh_6y',
'gl_tc8zyh_6y',
'gl_tc75zyh_6y',
'gl_tc7zyh_6y',
'gl_tc95zyh_12y',
'gl_tc9zyh_12y',
'gl_tc85zyh_12y',
'gl_tc8zyh_12y',
'gl_tc75zyh_12y',
'gl_tc7zyh_12y',
'gl_5gzzf_qyxn_1',
'gl_5gzzf_qyxn_2',
'gl_5gzzf_qyxn_3',
'gl_5gzzf_qyxn_4',
'gl_5gzzf_qyxn_5',
'gl_5gzzf_qyxn_6',
'gl_5gzzf_qyxn_7',
'gl_5gzzf_qyxn_8',
'gl_5gzzf_qyxn_9') then 1 else 0 end as is_tczk,
case when operate_code in 
(
'locpp.10047646',
'locpp.10047648',
'locpp.10047650',
'locpp.10047652',
'locpp.10047634',
'locpp.10047636',
'locpp.10047638',
'locpp.10047654',
'locpp.10047656',
'locpp.10047658',
'locpp.10047660',
'locpp.10047640',
'locpp.10047642',
'locpp.10047644'
) then 1 else 0 end as is_1yuanheyue
from cqbassdb.dw_operation_req_202205 a
where a.status = 1 and (a.operate_desc like'加入%' or a.operate_desc like'参加%')
and a.op_time <= '2022-05-31'
;