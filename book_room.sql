drop table temp_hlw_tongliang_5g_4g_info_01;
create table temp_hlw_tongliang_5g_4g_info_01(
    product_no varchar(50),           
    cell_name_juzhu varchar(128),       -- 居住基站
    cell_name_zhiye varchar(128),       -- 工作基站
    dept_name varchar(100)              -- 网格
)row format delimited fields terminated by ',' stored as textfile;

insert overwrite table temp_hlw_tongliang_5g_4g_info_01
select t1.product_no,t2.cell_name_juzhu,t2.cell_name_zhiye,t3.dept_name
from 
(
    select distinct product_no,dept_id
    from default.dw_zzqs_user_conn_qianyue_dt_yyyymmdd
    where day_id=20220630   -- 6月数据
    and is_5g_term =1       -- 5G终端
    and county_id=25        -- 铜梁分公司
    and tongxin_month =1    -- 当月通信
    and is_wlk=0            -- 剔除物联卡
    and (mon_5gopen_flag = 1 or mon_saopen_flag =1)   -- 打开5G开关
    and is_5gflow=0         -- 5G流量为0
) t1
left join HLW_DW_ZHIYEJUZHU_YYYYMM t2 on t1.product_no=t2.phone_no and t2.month_id = 202206
left join default.dim_pub_dept_new t3 on t1.dept_id=t3.dept_id and t3.active_flag=1
;


create table temp_hlw_tongliang_5g_4g_info_02 as 
select product_no,cell_name_juzhu as jizhen_info,dept_name
from temp_hlw_tongliang_5g_4g_info_01
where cell_name_juzhu is not null 
union all 
select product_no,cell_name_zhiye as jizhen_info,dept_name
from temp_hlw_tongliang_5g_4g_info_01
where cell_name_juzhu is null and cell_name_zhiye is not null  

-- gbase验证=================
t1.product_no,t2.cell_name_juzhu,t2.cell_name_zhiye,t3.dept_name

drop temp_hlw_tongliang_5g_4g_info_03;
create table temp_hlw_tongliang_5g_4g_info_03 as 
select distinct t1.product_no,t2.cell_name_juzhu,t2.cell_name_zhiye,t3.dept_name
from 
(
    select distinct product_no,dept_id
    from cqbassdb.dw_zzqs_user_conn_qianyue_dt_20220630
    where is_5g_term =1       -- 5G终端
    and county_id=25        -- 铜梁分公司
    and tongxin_month =1    -- 当月通信
    and is_wlk=0            -- 剔除物联卡
    and is_5gflow=0         -- 5G流量为0
) t1
left join HLW_DW_ZHIYEJUZHU_202206 t2 on t1.product_no=t2.phone_no 
left join cqbassdb.dim_pub_dept_new t3 on t1.dept_id=t3.dept_id and t3.active_flag=1
inner join 
(
    select distinct product_no,mon_5gopen_flag,mon_saopen_flag
    from cqbassdb.dw_zzqs_term_5g_switch_dt_20220630
    where active=1 and (mon_5gopen_flag = 1 or mon_saopen_flag =1)
) t4 on t1.product_no=t4.product_no
;


