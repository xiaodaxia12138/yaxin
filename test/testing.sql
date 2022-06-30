drop table temp_hlw_5g_tb_sale_map_info_01;
create table temp_hlw_5g_tb_sale_map_info_01
(
    user_id varchar(100),
    product_no varchar(100),
    privsetid varchar(100),
    is_xy int,       -- 是否校园
    is_bxl int,     -- 是否不限量   
    is_5gzd int,     -- 是否5G终端
    is_jt int,     -- 是否家庭
    is_qyrh int,     -- 是否权益融合
    is_dy68 int,     -- 是否套餐68以上
    is_18_68 int,     -- 是否套餐18-68
    is_xy18 int,     -- 是否套餐18以下
    is_fk int     -- 是否副卡
) distributed by ('user_id');


insert into temp_hlw_5g_tb_sale_map_info_01
select  t1.user_id,t1.product_no,
        ' ',
        case when t2.user_id is not null then 1 else 0 end as is_xy,
        case when t2_1.user_id is not null then 1 else 0 end as is_bxl,
        case when t3.product_no is not null then 1 else 0 end as is_5gzd,
        case when t4.user_id is not null then 1 else 0 end as is_jt,
        case when t5.product_no is not null then 1 else 0 end as is_qyrh,
        case when t6.user_id is not null then 1 else 0 end as is_dy68,
        case when t7.user_id is not null then 1 else 0 end as is_18_68,
        case when t8.user_id is not null then 1 else 0 end as is_xy18,
        case when t9.product_no is not null then 1 else 0 end as is_fk 
from cqbassdb.dw_product_outetype_dt_20220531 t1 
left join 
(
    select distinct user_id
    from cqbassdb.dw_user_useage_privilege_dt_20220531
    where privsetid in (
    'gl_hkqcbtc','gl_hkqcbtk','gl_ydhk_19A_qyhy12','gl_ydhk_19A_qyhy6','gl_ydhk_19A_zkhy12','gl_ydhk_19A_zkhy6','gl_ydhk_19atc','gl_ydhk_19atk','gl_ydhk_19B_qyhy12',
    'gl_ydhk_19B_qyhy6','gl_ydhk_19B_zkhy12','gl_ydhk_19B_zkhy6','gl_ydhk_19btc','gl_ydhk_19btk','gl_ydhk_19C_qyhy12','gl_ydhk_19C_qyhy6','gl_ydhk_19C_zkhy12','gl_ydhk_19C_zkhy6',
    'gl_ydhk_19ctc','gl_ydhk_19ctk','gl_ydhk_19D_qyhy12','gl_ydhk_19D_qyhy6','gl_ydhk_19D_zkhy12','gl_ydhk_19D_zkhy6','gl_ydhk_19dtc','gl_ydhk_19dtk',
    'gl_ydhk_bzbhyb1','gl_ydwk19a','gl_ydwk39a','gl_ydwk59a','gl_ydwk19b','gl_ydwk39b','gl_ydwk59b','pip_main_qck19','pip_main_qck19n',
    'pip_main_qck39','pip_main_qck39n','pip_main_qck59','pip_main_qck59n','pip_main_jlk29','pip_main_jlk39','pip_main_5gdg59','pip_main_5gdg79','pip_main_5gdg99'
    ) 
    and  nvl(enddate,'2050-01-01') >'2022-05-31' and enddate is null
) t2 on t1.user_id=t2.user_id           
left join 
(
    select distinct user_id
    from cqbassdb.dw_user_useage_privilege_dt_20220531
    where privsetid in (
    'pip_main_qgbxl99','pip_main_supfmy68','gl_4gqgbxl98','pip_main_supfmy98','gl_xydjb_59b','pip_main_qgbxl169','gl_bdbxl_tcn','gl_xydjb_39b','gl_qgbxlfk','pip_main_qgbxl69',
    'pip_main_supfmy168','pip_main_supfmy128','gl_xydjb_59a','gl_xydjb_39a','gl_bdbxl_tc','pip_main_qgbxl159','pip_main_nolim109','pip_main_qgbxl128','pip_main_supfmy238','gl_4gqgbxl238',
    'pip_main_supfmy288','pip_main_qgbxl239','pip_main_zxjh288','pip_gprs_nolim1','gl_4grwytc78','pip_main_qgbxl289','pip_main_supfmy388','pip_main_zxjh388','gl_4grwytc98','pip_main_qgbxl389',
    'pip_main_zxjh588','pip_main_nolim199','pip_main_supfmy588','gl_4grwytc198','gl_rwy_tcc','pip_main_qgbxl198','pip_gprs_hjqy','gl_rwy_tca','pip_gprs_zsqy','pip_gprs_bjqy',
    'gl_rwy_tcb','pip_gprs_nolim2','pip_gprs_vipcust','pip_gprs_nolim3','pip_qgbxl_58pack','pip_gprs_nolim4','pip_gprs_nolim5','pip_qgbxl_88pack','pip_gprs_nolim7','pip_qgbxl_138pack',
    'pip_gprs_nolim6','pip_gprs_qgbxl3','gl_xyllbxl_d','pip_gprs_qgbxl1','pip_gprs_qgbxl2','pip_gprs_xybdbxl4','pip_gprs_qgbxl4','pip_gprs_qgbxl6','pip_gprs_qgbxl5','gl_xyllbxl_c',
    'pip_gprs_xybdbxl3','gl_xyllbxl_b','pip_gprs_xsbdbxl1','pip_gprs_xsbdbxl4','gl_xyllbxl_a','pip_gprs_xybdbxl5','pip_qgbxl_58packfr','pip_qgbxl_88packfr','pip_gprs_xsbdbxl2',
    'pip_qgbxl_138packfr','pip_gprs_xsbdbxl3','pip_gprs_xybdbxl2','pip_gprs_xybdbxl1','gl_xyllbxl_e'
    ) 
    and  nvl(enddate,'2050-01-01') >'2022-05-31' and enddate is null
) t2_1 on t1.user_id=t2_1.user_id
left join
(
    select distinct a.user_id,product_no
    from cqbassdb.dw_user_imei_dt_20220531 a
    inner join cqbassdb.dim_pub_5g_terminfo_tac b on a.tac=b.tac
) t3 on t1.user_id = t3.user_id                    -- 5G终端
left join cqbassdb.dw_znjf_cust_zhudinet_info_outside_dm_20220531 t4 on t1.user_id=t4.user_id         -- 家庭用户
left join 
(
    select distinct product_no 
    from 
    (
        select msisdn as product_no
        from cqbassdb.dw_gprs_app_bh_dt_20220531
        where subtypename in ('优酷','腾讯视频','爱奇艺视频')
        group by msisdn,subtypename
        having sum(totalbytes) >=10*1040
        union all 
        select msisdn as product_no
        from cqbassdb.dw_gprs_app_bh_dt_20220531
        where subtypename in ('优酷','腾讯视频','爱奇艺视频') 
        group by msisdn,subtypename
        having sum(usedays) >=15
    ) a 
) t5 on t1.product_no=t5.product_no             -- 权益融合
left join
(
    select user_id from cqbassdb.dw_user_nowuse_privilege_dt_20220531 where total_value >= 68
) t6 on t1.user_id=t6.user_id              -- 大于68
left join
(
    select user_id from cqbassdb.dw_user_nowuse_privilege_dt_20220531 where total_value between 18 and 68 
) t7 on t1.user_id=t7.user_id     
left join           -- 18-68
(
    select user_id,'1'  from cqbassdb.dw_user_nowuse_privilege_dt_20220531 where total_value <= 18
) t8 on t1.user_id=t8.user_id               -- 小于18
left join 
(
    select distinct product_no
    from cqbassdb.dw_zzqs_user_sxk_detail_dt_20220531 
    where is_zk_priv='否'
) t9 on t1.product_no=t9.product_no           -- 副卡
where t1.active=1 and substr(t1.gra_product_attr_id1,5,1)=1
;

drop table temp_hlw_5g_tb_sale_map_info_02;
create table temp_hlw_5g_tb_sale_map_info_02
(
    user_id varchar(100),
    product_no varchar(100),
    tb_cnt int,       -- 5G套包办理
    dtb_cnt int,      -- 5G叠加包办理
    is_yyx int ,      -- 是否易营销
    is_5gdd int       -- 是否5G到达
) distributed by ('user_id');

insert into temp_hlw_5g_tb_sale_map_info_02
select t1.user_id,t1.product_no,
        t2.5gtb_cnt,t10.cnt,
        case when   t3.user_id is not null or
                    t4.user_id is null or
                    t5.user_id is not null or              
                    t6.product_no is not null or
                    t7.user_id is not null or
                    t8.user_id is not null or
                    t9.user_id is not null then 0 else 1 end as is_yyx,
        case when t2.user_id is not null then 1 else 0 end as is_5gdd 
from cqbassdb.dw_product_outetype_dt_20220531 t1
left join 
(
    select user_id,count(1) as 5gtb_cnt from cqbassdb.dw_5g_privilege_user_dt_20220531 where typename in ('5G叠加包','5G套餐')
    group by user_id
) t2 on t1.user_id=t2.user_id
left join 
(  
    select distinct user_id
    from  cqbassdb.dw_user_useage_privilege_dt_20220531
    where privsetid in ('gl_zq_vip_nodisturb','gl_zq_svip_nodisturb','gl_wh_nodisturb','gl_wapbxl_nodisturb','gl_tsmg_nodisturb','gl_qt_nodisturb','gl_qf_nodisturb'
    'gl_ctcxs4','gl_11yhg28','gl_1yhg2019_hl','gl_1yhg2019_t','gl_1yhgn2019_t','gl_1yhgn2019_b',
    'gl_1yhgn2019_a','gl_1yhgn2019_c','gl_1yhg2019_gn','gl_1yhg2019_g','gl_1yhg2019_f',
    'gl_1yhg2019_c','gl_1yhg2019_a','gl_1yhg2019_b','gl_1yhg2019_d','gl_1yhg2019_e',
    'pip_oth_1yqyscb1','pip_oth_1yqyscb2','pip_oth_1yqyscb3','pip_oth_1yqyscb4','pip_oth_1yqyscb5','pip_oth_1yqyscb6',
    'gl_4gbdxrw_40','gl_4gbdxrw_60','gl_4gbdxrwhc_40','gl_4gbdxrwhc_60','gl_4gqgbxl98','gl_4gqgbxl98_clzx','gl_4gqgbxl98_clzxa','gl_4gqgbxl98_clzxb','gl_bxl_yh10','gl_bxl_yh10g',
    'gl_bxl_yh20','gl_bxl_yh20g','gl_bxl_yh30','gl_bxl_yh30g','gl_bxl_yh40','gl_bxl_yh40g','gl_bxl_yh50','gl_bxl_yh50g','gl_bxl_yh60','gl_bxl_yh60g',
    'gl_bxl_yh70','gl_bxl_yh70g','gl_bxl_yh80','gl_bxl_yh80g','gl_bxl_yhn10','gl_bxl_yhn20','gl_free3tc_2018e','gl_grbxl_yh10g','gl_grbxl_yh20g','gl_grbxl_yh30g',
    'gl_sharenew38_clzx','gl_zqxkh_10y','gl_zqxkh_20y','gl_zqxkh_30y','gl_zqxkh_40y','gl_zqxkh_50y','gl_zqxkh_60y','gl_zqxkh_70y','gl_zqxkh_80y','gl_zqxkhcy_10y',
    'gl_zqxkhcy_20y','gl_zqxkhcy_30y','gl_zqxkhcy_40y','gl_zqxkhcy_50y','gl_zqxkhcy_60y','gl_zqxkhcy_70y','gl_zqxkhcy_80y','pip_fee_qgbxl60','pip_fee_qgbxl60_2','gl_fptc3zg_2018','gl_4gbdxrw_60','gl_4gbdxrwhc_60'
    )
    and nvl(enddate,'2050-01-01') >'2022-05-31' and enddate is null
) t3 on t1.user_id=t3.user_id
left join
(
    select distinct user_id 
    from 
    (
        select distinct a.user_id,a.product_no
        from cqbassdb.dw_user_imei_dt_20220531 a
        inner join cqbassdb.dim_pub_5g_terminfo_tac b on a.tac=b.tac
        union all
        select distinct a.user_id,a.product_no 
        from cqbassdb.dw_user_imei_dt_20220531 a
        left join cqbassdb.dim_pub_all_terminfo_tac b on a.tac=b.tac
        where  n09  in ('1','6','7','9') 
    ) a 
) t4 on t1.user_id=t4.user_id
left join
(
    select distinct user_id 
    from 
    (
        select distinct user_id from cqbassdb.DW_ZZQS_USER_LLGX_DT_20220531
        where  is_llgx=1 
        union  all
        select distinct user_id1 as user_id from cqbassdb.DW_ZZQS_USER_LLGX_DT_20220531
        where  is_llgx=1 
        union all
        select distinct user_id2 as user_id from cqbassdb.DW_ZZQS_USER_LLGX_DT_20220531
        where  is_llgx=1 
        union all
        select distinct user_id3 as user_id from cqbassdb.DW_ZZQS_USER_LLGX_DT_20220531
        where  is_llgx=1 
        union all
        select distinct user_id4 as user_id from cqbassdb.DW_ZZQS_USER_LLGX_DT_20220531
        where  is_llgx=1 
    ) a 
) t5 on t1.user_id=t5.user_id
left join 
(
    select distinct product_no
    from cqbassdb.dw_zzqs_user_conn_qianyue_dt_20220531
    where age >= 60
) t6 on t1.product_no=t6.product_no
left join 
(
    select distinct user_id
    from cqbassdb.dw_user_charges_useage_mm_202205
    where usageratio <= 0.3 or dateratio <=0.3
) t7 on t1.user_id=t7.user_id
left join 
(
    select distinct user_id
    from cqbassdb.dwb_imei_double_card_main_type_dt_20220531 
    where product_no is not null and card_type in ('移动移动','电信移动','联通移动')
) t8 on t1.user_id=t8.user_id
left join
(
    select distinct user_id 
    from cqbassdb.dw_zzqs_5g_tb_detail_dt_20220531
    where userstatus_name not in ('临时生成资料','临时资料交费开机','回退') 
    and (enddate>='2022-06-01' or enddate is null) 
    and operate_date between '2022-05-01' and '2022-05-31' 
    and priv_type not in ('副卡','升舱包')
) t9 on t1.user_id=t9.user_id
left join
(
    select distinct user_id,count(1) as cnt from cqbassdb.dw_zzqs_5g_tb_detail_dt_20220531
    where userstatus_name not in ('临时生成资料','临时资料交费开机','回退')  
    and operate_date between '2022-01-01' and '2022-05-31' 
    and (enddate>='2022-06-01' or enddate is null) 
    and priv_type not in ('副卡','升舱包')
    and priv_type='5G叠加包'
    group by user_id
) t10 on t1.user_id=t10.user_id
where t1.active=1 and substr(t1.gra_product_attr_id1,5,1)=1
;
-- 插入非副卡分类
drop table temp_hlw_5g_tb_sale_map_info_03;
create table temp_hlw_5g_tb_sale_map_info_03(
    class_tc varchar(20),     -- 套餐分类
    value1 int,    -- 通信用户
    value2 int,    -- 5G到达
    value3 decimal(20,4),    -- 5G套包渗透率
    value4 int,    -- 其中易营销客户
    value5 int,    -- 其中易营销客户5G到达
    value6 int,    -- 其中易营销客户5G叠加包办理
    value7 int,    -- 其中拍照客户
    value8 int,    -- 拍照客户中易营销
    value9 int,    -- 拍照客户5G到达
    value10  int,    -- 拍照客户中易营销客户5G到达
    value11  decimal(20,4),    -- 拍照客户5G套包渗透率
    value12  int,    -- 新增客户
    value13  int,    -- 新增客户5G到达
    value14  decimal(20,4)    -- 新增客户5G套包渗透率
) distributed by ('class_tc');

insert into temp_hlw_5g_tb_sale_map_info_03 
select  case when t1.is_xy=1 then '校园'
            when t1.is_xy=0 and t1.is_bxl=1 then '不限量'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=1 then '5G终端'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=1 then '家庭'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=1 then '权益融合'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=1 then '大于68' 
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=0 and t1.is_18_68=1 then '18-68之间'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=0 and t1.is_18_68=0 and t1.is_xy18=1 then '小于18'
        end as class_tc,
        count(t2.user_id) as value1,
        sum(t2.is_5gdd) as value2,
        count(t2.tb_cnt)/count(t2.user_id)as value3,
        sum(is_yyx) as value4,
        sum(case when t2.is_yyx=1 then t2.is_5gdd end)as value5,
        sum(case when t2.is_yyx=1 then t2.dtb_cnt end)as value6,
        count(t3.user_id)as value7,
        sum(case when t3.user_id is not null then t2.is_yyx end)as value8,
        sum(case when t3.user_id is not null then t2.is_5gdd end)as value9,
        sum(case when t2.is_yyx=1 and t3.user_id is not null then t2.is_5gdd end)as value10,
        sum(case when t3.user_id is not null then t2.is_5gdd end)/count(t3.user_id)as value11,
        count(t4.user_id)as value12,
        sum(case when t4.user_id is not null then t2.is_5gdd end)as value13,
        sum(case when t4.user_id is not null then t2.is_5gdd end)/count(t4.user_id) as value14
from temp_hlw_5g_tb_sale_map_info_01 t1
left join temp_hlw_5g_tb_sale_map_info_02 t2 on t1.user_id=t2.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20210531
)  t3 on t1.user_id=t3.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20220531
    where active=1 and open_date >= '2022-01-01'
)t4 on t1.user_id=t4.user_id
group by case when t1.is_xy=1 then '校园'
            when t1.is_xy=0 and t1.is_bxl=1 then '不限量'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=1 then '5G终端'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=1 then '家庭'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=1 then '权益融合'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=1 then '大于68' 
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=0 and t1.is_18_68=1 then '18-68之间'
            when t1.is_xy=0 and t1.is_bxl=0 and t1.is_5gzd=0 and t1.is_jt=0 and t1.is_qyrh=0 and t1.is_dy68=0 and t1.is_18_68=0 and t1.is_xy18=1 then '小于18'
        end

;
-- 插入合计
insert into temp_hlw_5g_tb_sale_map_info_03
select  '合计',
        count(t2.user_id) as value1,
        sum(t2.is_5gdd) as value2,
        count(t2.tb_cnt)/count(t2.user_id)as value3,
        sum(is_yyx) as value4,
        sum(case when t2.is_yyx=1 then t2.is_5gdd end)as value5,
        sum(case when t2.is_yyx=1 then t2.dtb_cnt end)as value6,
        count(t3.user_id)as value7,
        sum(case when t3.user_id is not null then t2.is_yyx end)as value8,
        sum(case when t3.user_id is not null then t2.is_5gdd end)as value9,
        sum(case when t2.is_yyx=1 and t3.user_id is not null then t2.is_5gdd end)as value10,
        sum(case when t3.user_id is not null then t2.is_5gdd end)/count(t3.user_id)as value11,
        count(t4.user_id)as value12,
        sum(case when t4.user_id is not null then t2.is_5gdd end)as value13,
        sum(case when t4.user_id is not null then t2.is_5gdd end)/count(t4.user_id) as value14
from temp_hlw_5g_tb_sale_map_info_01 t1
left join temp_hlw_5g_tb_sale_map_info_02 t2 on t1.user_id=t2.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20210531
)  t3 on t1.user_id=t3.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20220531
    where active=1 and open_date >= '2022-01-01'
)t4 on t1.user_id=t4.user_id
;
-- 插入副卡分类
insert into temp_hlw_5g_tb_sale_map_info_03
select  case when t1.is_fk=1 then '副卡' end as class_tc,
        count(t2.user_id) as value1,
        sum(t2.is_5gdd) as value2,
        count(t2.tb_cnt)/count(t2.user_id)as value3,
        sum(is_yyx) as value4,
        sum(case when t2.is_yyx=1 then t2.is_5gdd end)as value5,
        sum(case when t2.is_yyx=1 then t2.dtb_cnt end)as value6,
        count(t3.user_id)as value7,
        sum(case when t3.user_id is not null then t2.is_yyx end)as value8,
        sum(case when t3.user_id is not null then t2.is_5gdd end)as value9,
        sum(case when t2.is_yyx=1 and t3.user_id is not null then t2.is_5gdd end)as value10,
        sum(case when t3.user_id is not null then t2.is_5gdd end)/count(t3.user_id)as value11,
        count(t4.user_id)as value12,
        sum(case when t4.user_id is not null then t2.is_5gdd end)as value13,
        sum(case when t4.user_id is not null then t2.is_5gdd end)/count(t4.user_id) as value14
from temp_hlw_5g_tb_sale_map_info_01 t1
left join temp_hlw_5g_tb_sale_map_info_02 t2 on t1.user_id=t2.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20210531
)  t3 on t1.user_id=t3.user_id
left join 
(
    select user_id
    from cqbassdb.dw_product_outetype_dt_20220531
    where active=1 and open_date >= '2022-01-01'
)t4 on t1.user_id=t4.user_id
where t1.is_fk=1
group by case when t1.is_fk=1 then '副卡' end
;

-- 输出表：
select  class_tc,
        value1 ,
        value2 ,
        value3 ,
        value2/max(value2) over (),
        value4 ,
        value5 ,
        value6 ,
        value7 ,
        value8 ,
        value9 ,
        value10 ,
        value11 ,
        value9/max(value9) over () ,
        value12 ,
        value13 ,
        value14 ,
        value13/max(value13) over ()
from temp_hlw_5g_tb_sale_map_info_03
