-- 分类
select case when a.is_xy=1 then xy 
            when a.is_xy=0 and a.is_bxl=1 then bxl
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=1 then 5gzd
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=1 then jt
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=1 then qyrh
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=1 then dy68 
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=0 and a.is_18_68=1 then 18_68
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=0 and a.is_18_68=0 and a.is_xy18=1 then xy18
            when a.is_fk=1 then fka.
        end as class_tc,count(1) 
from 
(
    select  t1.user_id,t1.product_no
            t2.privsetid,
            case when t2.privsetid in ('gl_hkqcbtc','gl_hkqcbtk','gl_ydhk_19A_qyhy12','gl_ydhk_19A_qyhy6','gl_ydhk_19A_zkhy12','gl_ydhk_19A_zkhy6','gl_ydhk_19atc','gl_ydhk_19atk','gl_ydhk_19B_qyhy12',
    'gl_ydhk_19B_qyhy6','gl_ydhk_19B_zkhy12','gl_ydhk_19B_zkhy6','gl_ydhk_19btc','gl_ydhk_19btk','gl_ydhk_19C_qyhy12','gl_ydhk_19C_qyhy6','gl_ydhk_19C_zkhy12','gl_ydhk_19C_zkhy6',
    'gl_ydhk_19ctc','gl_ydhk_19ctk','gl_ydhk_19D_qyhy12','gl_ydhk_19D_qyhy6','gl_ydhk_19D_zkhy12','gl_ydhk_19D_zkhy6','gl_ydhk_19dtc','gl_ydhk_19dtk',
    'gl_ydhk_bzbhyb1','gl_ydwk19a','gl_ydwk39a','gl_ydwk59a','gl_ydwk19b','gl_ydwk39b','gl_ydwk59b','pip_main_qck19','pip_main_qck19n','pip_main_qck39','pip_main_qck39n','pip_main_qck59','pip_main_qck59n',
    'pip_main_jlk29','pip_main_jlk39','pip_main_5gdg59','pip_main_5gdg79','pip_main_5gdg99') then 1 else 0 end as is_xy,
            case when t2.privsetid in ('pip_main_qgbxl99','pip_main_supfmy68','gl_4gqgbxl98','pip_main_supfmy98','gl_xydjb_59b','pip_main_qgbxl169','gl_bdbxl_tcn','gl_xydjb_39b','gl_qgbxlfk','pip_main_qgbxl69',
    'pip_main_supfmy168','pip_main_supfmy128','gl_xydjb_59a','gl_xydjb_39a','gl_bdbxl_tc','pip_main_qgbxl159','pip_main_nolim109','pip_main_qgbxl128','pip_main_supfmy238','gl_4gqgbxl238',
    'pip_main_supfmy288','pip_main_qgbxl239','pip_main_zxjh288','pip_gprs_nolim1','gl_4grwytc78','pip_main_qgbxl289','pip_main_supfmy388','pip_main_zxjh388','gl_4grwytc98','pip_main_qgbxl389',
    'pip_main_zxjh588','pip_main_nolim199','pip_main_supfmy588','gl_4grwytc198','gl_rwy_tcc','pip_main_qgbxl198','pip_gprs_hjqy','gl_rwy_tca','pip_gprs_zsqy','pip_gprs_bjqy',
    'gl_rwy_tcb','pip_gprs_nolim2','pip_gprs_vipcust','pip_gprs_nolim3','pip_qgbxl_58pack','pip_gprs_nolim4','pip_gprs_nolim5','pip_qgbxl_88pack','pip_gprs_nolim7','pip_qgbxl_138pack',
    'pip_gprs_nolim6','pip_gprs_qgbxl3','gl_xyllbxl_d','pip_gprs_qgbxl1','pip_gprs_qgbxl2','pip_gprs_xybdbxl4','pip_gprs_qgbxl4','pip_gprs_qgbxl6','pip_gprs_qgbxl5','gl_xyllbxl_c',
    'pip_gprs_xybdbxl3','gl_xyllbxl_b','pip_gprs_xsbdbxl1','pip_gprs_xsbdbxl4','gl_xyllbxl_a','pip_gprs_xybdbxl5','pip_qgbxl_58packfr','pip_qgbxl_88packfr','pip_gprs_xsbdbxl2',
    'pip_qgbxl_138packfr','pip_gprs_xsbdbxl3','pip_gprs_xybdbxl2','pip_gprs_xybdbxl1','gl_xyllbxl_e') then 1 else 0 end as is_bxl,
            case when t3.product_no is not null then 1 else 0 end as is_5gzd,
            case when t4.user_id is not null then 1 else 0 end as is_jt,
            case when t5.product_no is not null then 1 else 0 end as is_qyrh,
            case when t6.user_id is not null then 1 else 0 end as is_dy68,
            case when t7.user_id is not null then 1 else 0 end as is_18_68,
            case when t8.user_id is not null then 1 else 0 end as is_xy18,
            case when t9.product_no is not null then 1 else 0 end as is_fk
    from cqbassdb.dw_product_outetype_dt_20211031 t1 
    left join cqbassdb.dw_user_useage_privilege_dt_20211031 t2 on t1.product_no=t2.product_no
    left join
    (
        select distinct a.user_id,product_no
        from cqbassdb.dw_user_imei_dt_20211031 a
        inner join cqbassdb.dim_pub_5g_terminfo_tac b on a.tac=b.tac
        ---A
    ) t3 on t1.user_id = t3.user_id -- 5G终端
    left join cqbassdb.dw_znjf_cust_zhudinet_info_outside_dm_20211031 t4 on t1.user_id=t4.user_id -- 家庭用户
    left join 
    (
        select  case when sum(totalbytes) >= 1040*10 then msisdn end as product_no,
                sum(totalbytes) as totalbytes
        from cqbassdb.dw_gprs_app_bh_dt_20211031
        where subtypename in ('优酷','腾讯视频','爱奇艺视频')
        group by msisdn
        union all 
        select msisdn as product_no,totalbytes
        from cqbassdb.dw_gprs_app_bh_dt_20211031
        where subtypename in ('优酷','腾讯视频','爱奇艺视频') and usedays >= 15
        ---A
    ) t5 on t1.product_no=t5.product_no   -- 权益融合
    left join
    (
        select user_id from cqbassdb.dw_user_nowuse_privilege_dt_20211031 where total_value >= 68
    ) t6 on t1.user_id=t6.user_id --大于68
    left join
    (
        select user_id from cqbassdb.dw_user_nowuse_privilege_dt_20211031 where total_value between 18 and 68 
    ) t7 on t1.user_id=t7.user_id  --18-68
    (
        select user_id from cqbassdb.dw_user_nowuse_privilege_dt_20211031 where total_value =< 18
    ) t8 on t1.user_id=t8.user_id --小于18
    left join 
    (
        select product_no
        from cqbassdb.dw_zzqs_user_sxk_detail_dt_20211031 
        where is_zk_priv='否'
    ) t9 on t1.product_no=t9.product_no
    where nvl(t2.enddate,'2050-01-01') >'2021-10-31' and t2.enddate is null
    and t1.active=1 and substr(t1.gra_product_attr_id1,5,1)=1
) a
group by case when a.is_xy=1 then xy 
            when a.is_xy=0 and a.is_bxl=1 then bxl
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=1 then 5gzd
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=1 then jt
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=1 then qyrh
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=1 then dy68 
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=0 and a.is_18_68=1 then 18_68
            when a.is_xy=0 and a.is_bxl=0 and a.is_5gzd=0 and a.is_jt=0 and a.is_qyrh=0 and a.is_dy68=0 and a.is_18_68=0 and a.is_xy18=1 then xy18
            when a.is_fk=1 then fka.
        end 
;