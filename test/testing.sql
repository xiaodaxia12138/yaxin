select
from
(   
    select 
    from cqbassdb.dw_product_outetype_dt_20211031
    where active=1 and substr(gra_product_attr_id1,5,1)=1
) t1
left join
(
    select user_id,telnum as product_no from cqbassdb.dw_5g_privilege_user_dt_20211031 where typename in ('5G叠加包','5G套餐')
) t2
left join
(
    select user_id,product_no
    from  cqbassdb.dw_user_useage_privilege_dt_20211031
    where privsetid in ('gl_zq_vip_nodisturb','gl_zq_svip_nodisturb','gl_wh_nodisturb','gl_wapbxl_nodisturb',
 'gl_tsmg_nodisturb','gl_qt_nodisturb','gl_qf_nodisturb'
 'gl_ctcxs4','gl_11yhg28','gl_1yhg2019_hl','gl_1yhg2019_t','gl_1yhgn2019_t','gl_1yhgn2019_b',
 'gl_1yhgn2019_a','gl_1yhgn2019_c','gl_1yhg2019_gn','gl_1yhg2019_g','gl_1yhg2019_f',
 'gl_1yhg2019_c','gl_1yhg2019_a','gl_1yhg2019_b','gl_1yhg2019_d','gl_1yhg2019_e',
 'pip_oth_1yqyscb1','pip_oth_1yqyscb2','pip_oth_1yqyscb3','pip_oth_1yqyscb4','pip_oth_1yqyscb5','pip_oth_1yqyscb6',
 'gl_4gbdxrw_40','gl_4gbdxrw_60','gl_4gbdxrwhc_40','gl_4gbdxrwhc_60','gl_4gqgbxl98','gl_4gqgbxl98_clzx','gl_4gqgbxl98_clzxa',
 'gl_4gqgbxl98_clzxb','gl_bxl_yh10','gl_bxl_yh10g',
 'gl_bxl_yh20','gl_bxl_yh20g','gl_bxl_yh30','gl_bxl_yh30g','gl_bxl_yh40','gl_bxl_yh40g','gl_bxl_yh50','gl_bxl_yh50g','gl_bxl_yh60','gl_bxl_yh60g',
 'gl_bxl_yh70','gl_bxl_yh70g','gl_bxl_yh80','gl_bxl_yh80g','gl_bxl_yhn10','gl_bxl_yhn20','gl_free3tc_2018e','gl_grbxl_yh10g','gl_grbxl_yh20g','gl_grbxl_yh30g',
 'gl_sharenew38_clzx','gl_zqxkh_10y','gl_zqxkh_20y','gl_zqxkh_30y','gl_zqxkh_40y','gl_zqxkh_50y','gl_zqxkh_60y','gl_zqxkh_70y','gl_zqxkh_80y','gl_zqxkhcy_10y',
 'gl_zqxkhcy_20y','gl_zqxkhcy_30y','gl_zqxkhcy_40y','gl_zqxkhcy_50y','gl_zqxkhcy_60y','gl_zqxkhcy_70y','gl_zqxkhcy_80y','pip_fee_qgbxl60',
 'pip_fee_qgbxl60_2','gl_fptc3zg_2018','gl_4gbdxrw_60','gl_4gbdxrwhc_60'

  )
 and nvl(enddate,'2050-01-01') >'2021-10-31' and enddate is null
)