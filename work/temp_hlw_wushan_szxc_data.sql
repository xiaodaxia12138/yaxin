 -- temp_hlw_wushan_szxc_data;
 -- temp_hlw_wushan_zhsq_data;
drop table temp_hlw_wushan_szxc_data_shuchu_xc;
create table temp_hlw_wushan_szxc_data_shuchu_xc(
    address varchar(100),
    name varchar(10),
    product_no varchar(100),
    area_name varchar(100),
    dept_name varchar(100),
    plan_name varchar(100),
    avg_zk_arpu decimal(20,2),
    is_kd varchar(10),
    is_mbh varchar(10),
    is_qy varchar(10)
) distributed by ('product_no');

insert into temp_hlw_wushan_szxc_data_shuchu_xc
select  distinct t1.address,t1.name,t1.product_no,
        t2.area_name,t2.dept_name,t2.plan_name,
        t3.avg_zk_arpu,  -- 前三月折后arpu
        case when t4.product_no is not null then '是' else '否' end as is_kd,  -- 是否办理宽带
        case when t5.product_no is not null then '是' else '否' end as is_mbh,   -- 是否办理魔百盒
        case when t6.user_id is not null then '是' else '否' end as is_qy      -- 是否签约
from temp_hlw_wushan_szxc_data t1
left join 
(
    select distinct a.user_id,a.product_no,
                    b.dept_name,    -- 网格
                    c.area_name,    -- 分局
                    d.plan_name     -- 三级资费
    from cqbassdb.dw_product_dt_20220621 a
    left join cqbassdb.dim_pub_dept_new b on a.dept_id=b.dept_id and b.active_flag=1
    left join cqbassdb.dim_pub_area_new c on b.area_id=c.area_id and c.active_flag=1
    left join cqbassdb.dim_cust_plan d on a.plan_id=d.plan_id
    where a.active=1
) t2 on t1.product_no=t2.product_no
left join cqbassdb.dw_user_arpu_mou_dou_mm_202205 t3 on t2.user_id=t3.user_id
left join cqbassdb.dw_znjf_cust_zhudinet_info_outside_dm_20220621 t4 on t1.product_no=t4.product_no
left join
(
    select distinct product_no
    from cqbassdb.DW_ZZQS_MBH_INNET_DETAIL_DT_20220621
) t5 on t1.product_no=t5.product_no
left join 
(
    select distinct user_id
    from cqbassdb.dw_user_useage_privilege_dt_20220621 a
    inner join cqbassdb.dim_pub_qianyue_2019 b on a.privsetid=b.itemid
    where (a.enddate>'2022-06-21' or a.enddate is null)
) t6 on t2.user_id=t6.user_id
;

drop table temp_hlw_wushan_zhsq_shuchu_sq;
create table temp_hlw_wushan_zhsq_shuchu_sq(
    name varchar(20),
    sex varchar(10),
    address varchar(100),
    id_type varchar(20),
    xiaoqu varchar(20),
    product_no varchar(20),
    area_name varchar(100),
    dept_name varchar(100),
    plan_name varchar(100),
    avg_zk_arpu decimal(20,2),
    is_kd varchar(10),
    is_mbh varchar(10),
    is_qy varchar(10)
) distributed by ('product_no');

insert into temp_hlw_wushan_zhsq_shuchu_sq
select  distinct t1.name,t1.sex,t1.address,t1.id_type,t1.xiaoqu,t1.product_no,
        t2.area_name,t2.dept_name,t2.plan_name,
        t3.avg_zk_arpu,    -- 前三月折后arpu
        case when t4.product_no is not null then '是' else '否' end as is_kd,  -- 是否办理宽带
        case when t5.product_no is not null then '是' else '否' end as is_mbh,   -- 是否办理魔百盒
        case when t6.user_id is not null then '是' else '否' end as is_qy    -- 是否签约
from temp_hlw_wushan_zhsq_data t1
left join 
(
    select distinct a.user_id,a.product_no,
                    b.dept_name,    -- 网格
                    c.area_name,    -- 分局
                    d.plan_name     -- 三级资费
    from cqbassdb.dw_product_dt_20220621 a
    left join cqbassdb.dim_pub_dept_new b on a.dept_id=b.dept_id and b.active_flag=1
    left join cqbassdb.dim_pub_area_new c on b.area_id=c.area_id and c.active_flag=1
    left join cqbassdb.dim_cust_plan d on a.plan_id=d.plan_id
    where a.active=1
) t2 on t1.product_no=t2.product_no
left join cqbassdb.dw_user_arpu_mou_dou_mm_202205 t3 on t2.user_id=t3.user_id
left join cqbassdb.dw_znjf_cust_zhudinet_info_outside_dm_20220621 t4 on t1.product_no=t4.product_no
left join
(
    select distinct product_no
    from cqbassdb.DW_ZZQS_MBH_INNET_DETAIL_DT_20220621
) t5 on t1.product_no=t5.product_no
left join 
(
    select distinct user_id
    from cqbassdb.dw_user_useage_privilege_dt_20220621 a
    inner join cqbassdb.dim_pub_qianyue_2019 b on a.privsetid=b.itemid
    where (a.enddate>'2022-06-21' or a.enddate is null)
) t6 on t2.user_id=t6.user_id
;


select a.product_no,count(a.product_no)
from(
select  product_no,area_name,dept_name,plan_name,is_kd,is_mbh,is_qy
from temp_hlw_wushan_szxc_data_shuchu_xc) a
group by a.product_no
having count(a.product_no)>1






-- 宽带
cqbassdb.dw_znjf_cust_zhudinet_info_outside_dm_20220621

-- 分局,网格,三级资费

select distinct a.user_id,a.product_no,
  b.dept_name,    -- 网格
  c.area_name,    -- 分局
  d.plan_name     -- 三级资费
from cqbassdb.dw_product_dt_20220621 a
left join cqbassdb.dim_pub_dept_new b on a.dept_id=b.dept_id and b.active_flag=1
left join cqbassdb.dim_pub_area_new c on b.area_id=c.area_id and c.active_flag=1
left join cqbassdb.dim_cust_plan d on a.plan_id=d.plan_id
where a.active=1

-- 前三月折后arpu
avg_zk_arpu cqbassdb.dw_user_arpu_mou_dou_mm_202205


魔百和(魔百盒)
cqbassdb.DW_ZZQS_MBH_INNET_DETAIL_DT_20220621


签约

cqbassdb.dw_user_useage_privilege_dt_20220621 a
inner join cqbassdb.dim_pub_qianyue_2019 b on a.privsetid=b.itemid
where (a.enddate>'2022-06-21' or a.enddate is null)









