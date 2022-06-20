select *
from
(
    select distinct a.product_no,a.user_id,b.county_name
    from cqbassdb.dw_product_outetype_dt_20220331 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t1 -- 全市通信客户
left join 
( 
    select distinct a.product_no,b.priv_type,b.priv_id
    from cqbassdb.dw_operation_req_202203 as  a
    inner join temp_hlw_dim_szjt_1yuan_priv_2022 b on a.operate_code=b.priv_id
    where a.status = 1 and (a.operate_desc like'加入%' or a.operate_desc like'参加%')
    and a.op_time <= '2022-05-31'
) t2 on t1.product_no=t2.product_no -- 目标套餐
left join cqbassdb.dw_user_arpu_mou_dou_mm_202202 t3 on t1.user_id=t3.user_id -- 2月arpu
left join cqbassdb.dw_user_arpu_mou_dou_mm_202204 t4 on t1.user_id=t4.user_id -- 4月arpu
left join hlw_dw_jiating_gongxiang_quanzi_202202 t5 on t1





;
