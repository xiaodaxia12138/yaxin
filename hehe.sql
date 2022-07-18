-- 流量表
DW_USER_ARPU_MOU_DOU_MM_YYYYMM
-- 协转
DW_ZZQS_XZZT_XR_USER_DT_YYYYMMDD
DW_ZZQS_XZZT_XC_USER_DT_YYYYMMDD
XR_TIME=202205
-- 新增
select a.*
from cqbassdb.dw_user_all_newdetail_dt_20220531 a
where a.op_time>='2022-05-01' and a.op_time <= '2022-05-31' and a.m2m_flag=0 and a.etype_flag=0
-- 纯新增new_flag=1



-- 折扣终端明细 
drop table temp_hlw_5g_term_zk_bl_info_202205;
create table temp_hlw_5g_term_zk_bl_info_202205(
op_time varchar(100),            -- 受理时间
product_no varchar(100),            -- 号码
create_time varchar(100),            -- 受理时间
oper_code varchar(100),            -- 受理工号
phone_type varchar(100) ,           -- 机型
phone_term varchar(100),            -- 品牌
ent_id varchar(100),            -- 集团编码
end_address varchar(100),            -- 集团单位
crm_code varchar(100),            -- CRM受理业务模块名称
oper_type      varchar(100),    -- 业务类型（销售/自购机优惠）
oper_county    varchar(100),        -- 受理工号归属
iemi_id        varchar(100),     -- IEMI号
dl_oper_code   varchar(100),          -- 代办工号
heyue_price  decimal(20,2),          -- 手机合约价（采购价）
shiji_price  decimal(20,2),           -- 客户实际支付金额（购机款）
yufu         decimal(20,2),   -- 实际支付金额（预存话费）
favour_name   varchar(100),       -- 办理优惠名称
butue_rate   decimal(5,4),           -- 补贴率
is_5Gterm varchar(10),            -- 是否为5G机型
USER_STATUS varchar(100),            -- 用户状态
is_cb varchar(100),            -- 是否拆包
favour decimal(20,2),           -- 办理优惠名称
hy_time int,            -- 合约期
hy_arpu int,            -- 合约期收入
term_cast decimal(20,2)            -- 终端成本
) distributed by ('product_no')
;

select count(1),count(distinct product_no) from temp_hlw_5g_term_zk_bl_info_202205;
-- 4326 4326

-- 输出表3_多user_id
drop table temp_hlw_5g_term_zk_bl_user_info_01;
create table temp_hlw_5g_term_zk_bl_user_info_01(
    op_time varchar(100),
    product_no varchar(100),
    user_id varchar(100),
    oper_county varchar(100),
    crm_code varchar(100), 
    avg_arpu_04 decimal(20,2), -- 折前近3月平均arpu
    arpu_06 decimal(20,2),  -- 次月折前arpu
    dou_04 decimal(20,2),  -- 办理前DOU
    dou_06 decimal(20,2),   -- 6月DOU
    avg_zk_arpu_04 decimal(20,2), -- 折后近3月平均arpu
    zk_arpu_06 decimal(20,2),   -- 次月折后arpu
    is_xz varchar(10)  -- 是否新增
);

insert into temp_hlw_5g_term_zk_bl_user_info_01
select  t1.op_time,t1.product_no,tt.user_id,t1.oper_county,t1.crm_code,
        t2.avg_arpu,t3.arpu ,t2.dou,t3.dou,t2.avg_zk_arpu,t3.zk_arpu,
        case when t4.product_no is not null then '是' else '否' end 
from temp_hlw_5g_term_zk_bl_info_202205 t1 
left join 
(
    select distinct product_no,user_id
    from cqbassdb.dw_product_outetype_dt_20220531
    where active=1
) tt on t1.product_no =tt.product_no
left join cqbassdb.DW_USER_ARPU_MOU_DOU_MM_202204 t2 on tt.user_id=t2.user_id
left join cqbassdb.DW_USER_ARPU_MOU_DOU_MM_202206 t3 on tt.user_id=t3.user_id
left join 
(
    select product_no
    from cqbassdb.dw_user_all_newdetail_dt_20220531 a
    where a.op_time>='2022-05-01' and a.op_time <= '2022-05-31' and a.m2m_flag=0 and a.etype_flag=0
) t4 on t1.product_no=t4.product_no
;

select count(1),count(distinct product_no) from temp_hlw_5g_term_zk_bl_user_info_01;
-- 4326 4326

drop table temp_hlw_jyq_arpu_info_4yue;
create table temp_hlw_jyq_arpu_info_4yue as         -- 4月家庭圈明细
select distinct t1.product_no,t2.group_id,t2.cnt,t3.cnt as cnt2,t3.avg_arpu_sum
from temp_hlw_5g_term_zk_bl_user_info_01 t1 
left join 
(
    select distinct group_id,user_id,cnt
    from hlw_dw_jiating_gongxiang_quanzi_202205
) t2 on t1.user_id=t2.user_id  
left join 
(
    select t1.group_id ,avg(t2.cnt) as cnt,sum(t3.avg_arpu) as avg_arpu_sum
    from 
    (
        select distinct group_id
        from hlw_dw_jiating_gongxiang_quanzi_202204
    ) t1
    left join hlw_dw_jiating_gongxiang_quanzi_202204 t2 on t1.group_id= t2.group_id
    left join 
    (
        select user_id,avg_arpu
        from cqbassdb.DW_USER_ARPU_MOU_DOU_MM_202204
    ) t3 on t2.user_id=t3.user_id   -- 4月avg_arpu
    group by group_id
) t3 on t2.group_id =t3.group_id
;

drop table temp_hlw_jyq_arpu_info_6yue;
create table temp_hlw_jyq_arpu_info_6yue as             -- 6月家庭圈明细
select distinct t1.product_no,t2.group_id,t2.cnt,t3.cnt as cnt2,t3.arpu
from temp_hlw_5g_term_zk_bl_user_info_01 t1 
left join 
(
    select distinct group_id,user_id,cnt
    from hlw_dw_jiating_gongxiang_quanzi_202205
) t2 on t1.user_id=t2.user_id  
left join 
(
    select t1.group_id ,avg(t2.cnt) as cnt,sum(t3.arpu) as arpu
    from 
    (
        select distinct group_id
        from hlw_dw_jiating_gongxiang_quanzi_202206
    ) t1
    left join hlw_dw_jiating_gongxiang_quanzi_202206 t2 on t1.group_id= t2.group_id
    left join 
    (
        select user_id,arpu
        from cqbassdb.DW_USER_ARPU_MOU_DOU_MM_202206
    ) t3 on t2.user_id=t3.user_id   -- 6月arpu
    group by group_id
) t3 on t2.group_id =t3.group_id
;
-- 输出表2:
drop table temp_hlw_5g_term_zk_bl_user_info_02;
create table temp_hlw_5g_term_zk_bl_user_info_02(
    op_time varchar(100),
    product_no varchar(100),
    oper_county varchar(100),
    crm_code varchar(100), 
    is_xiez varchar(10),      -- 是否携转
    is_cxz varchar(10),         -- 是否纯新增
    zk_arpu_06 decimal(20,2),   -- 次月arpu
    dou_06 decimal(20,2),        -- 次月DOU
    cnt_04 int,      -- 4月家庭圈人数
    avg_arpu_04 decimal(20,2),   -- -- 4月家庭圈ARPU
    cnt_06 int,      -- 6月家庭圈人数
    avg_arpu_06 decimal(20,2)   -- -- 6月家庭圈ARPU
);

insert into temp_hlw_5g_term_zk_bl_user_info_02
select  nvl(t1.op_time,0),nvl(t1.product_no,0),nvl(t1.oper_county,0),nvl(t1.crm_code,0),
        case when t2.product_no is not null then '是' else '否' end,
        case when t3.product_no is not null then '是' else '否' end,
        nvl(t4.arpu,0),nvl(t4.dou,0),
        nvl(t5.cnt2,0),nvl(t5.avg_arpu_sum,0),
        nvl(t6.cnt2,0),nvl(t6.arpu,0)
from temp_hlw_5g_term_zk_bl_user_info_01 t1
left join 
(
    select distinct a.product_no
    from 
    (
        select product_no
        from cqbassdb.DW_ZZQS_XZZT_XR_USER_DT_20220531
        union all 
        select product_no
        from cqbassdb.DW_ZZQS_XZZT_XC_USER_DT_20220531
    ) a
) t2 on t1.product_no = t2.product_no
left join 
(
    select distinct product_no
    from cqbassdb.dw_user_all_newdetail_dt_20220531 a
    where a.op_time>='2022-05-01' and a.op_time <= '2022-05-31' 
    and a.m2m_flag=0 and a.etype_flag=0 and new_flag=1
) t3 on t1.product_no = t3.product_no
left join 
(
    select user_id,zk_arpu,dou,arpu
    from cqbassdb.DW_USER_ARPU_MOU_DOU_MM_202206
) t4 on t1.user_id=t4.user_id
left join temp_hlw_jyq_arpu_info_4yue t5 on t1.product_no=t5.product_no
left join temp_hlw_jyq_arpu_info_6yue t6 on t1.product_no=t6.product_no
;

select count(1),count(distinct product_no) from temp_hlw_5g_term_zk_bl_user_info_02;
-- 4326 4326

-- 输出表1：
drop table temp_hlw_5g_term_zk_bl_user_info_03;
create table temp_hlw_5g_term_zk_bl_user_info_03(
time varchar(10),      -- 月份
value1  int,           -- 政企折扣购机办理量
value2  decimal(20,2), -- 办理前三月平均ARPU
value3  decimal(20,2), -- 办理次月ARPU
value4  decimal(20,2), -- 办理前DOU
value5  decimal(20,2), -- 办理次月DOU
value6  decimal(20,2), -- 办理前三月平均折后收入
value7  decimal(20,2), -- 办理次月折后收入
value8  int,           -- 纯新增非携转
value9  decimal(20,2), -- 号码办理后次月ARPU
value10  decimal(20,2), -- 号码办理后次月DOU
value11  int,           -- 办理上月家庭圈成员数量
value12  decimal(20,2), -- 办理前3月该号码家庭圈平均ARPU 
value13  decimal(20,2), -- 办理后次月家庭圈成员数量 
value14  decimal(20,2), -- 办理后次月该号码家庭圈ARPU
value15  int,           -- 携转纯新增
value16  decimal(20,2), -- 号码办理后次月ARPU
value17  decimal(20,2), -- 号码办理后次月DOU
value18  int,           -- 办理上月家庭圈成员数量
value19  decimal(20,2), -- 办理前3月该号码家庭圈平均ARPU
value20  decimal(20,2), -- 办理后次月家庭圈成员数量
value21  decimal(20,2), -- 办理后次月该号码家庭圈ARPU
value22  int,           -- 携转非纯新增
value23  decimal(20,2), -- 号码办理后次月ARPU
value24  decimal(20,2), -- 号码办理后次月DOU
value25  int,           -- 办理上月家庭圈成员数量
value26  decimal(20,2), -- 办理前3月该号码家庭圈平均ARPU
value27  decimal(20,2), -- 办理后次月家庭圈成员数量
value28  decimal(20,2)  -- 办理后次月该号码家庭圈ARPU
);

insert into temp_hlw_5g_term_zk_bl_user_info_03
select  '5月',count(1),
        sum(t2.avg_arpu_04),sum(t2.arpu_06),sum(t2.dou_04),sum(t2.dou_06),sum(t2.avg_zk_arpu_04),sum(t2.zk_arpu_06),
        
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then 1 else 0 end) as typ1,
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.zk_arpu_06 else 0 end),
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.dou_06 else 0 end),
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.cnt_04 else 0 end),
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.avg_arpu_04 else 0 end),
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.cnt_06 else 0 end),
        sum(case when t3.is_xiez = '否' and is_cxz = '是' then t3.avg_arpu_06 else 0 end),

        sum(case when t3.is_xiez = '是' and is_cxz = '是' then 1 else 0 end) as typ2,
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.zk_arpu_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.dou_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.cnt_04 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.avg_arpu_04 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.cnt_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '是' then t3.avg_arpu_06 else 0 end),

        sum(case when t3.is_xiez = '是' and is_cxz = '否' then 1 else 0 end) as typ3,
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.zk_arpu_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.dou_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.cnt_04 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.avg_arpu_04 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.cnt_06 else 0 end),
        sum(case when t3.is_xiez = '是' and is_cxz = '否' then t3.avg_arpu_06 else 0 end)
        
from temp_hlw_5g_term_zk_bl_info_202205 t1 
left join temp_hlw_5g_term_zk_bl_user_info_01 t2 on t1.product_no = t2.product_no
left join temp_hlw_5g_term_zk_bl_user_info_02 t3 on t1.product_no = t3.product_no
;

-- 输出表3：去除多余user_id
drop table temp_hlw_5g_term_zk_bl_user_info_04;
create table temp_hlw_5g_term_zk_bl_user_info_04(
    op_time varchar(100),
    product_no varchar(100),
    oper_county varchar(100),
    crm_code varchar(100), 
    avg_arpu_04 decimal(20,2), -- 折前近3月平均arpu
    arpu_06 decimal(20,2),  -- 次月折前arpu
    dou_04 decimal(20,2),  -- 办理前DOU
    dou_06 decimal(20,2),   -- 6月DOU
    avg_zk_arpu_04 decimal(20,2), -- 折后近3月平均arpu
    zk_arpu_06 decimal(20,2),   -- 次月折后arpu
    is_xz varchar(10)  -- 是否新增
);

insert into temp_hlw_5g_term_zk_bl_user_info_04
select  nvl(op_time,0),
        nvl(product_no,0),
        nvl(oper_county,0),
        nvl(crm_code,0),
        nvl(avg_arpu_04,0),
        nvl(arpu_06,0),
        nvl(dou_04,0),
        nvl(dou_06,0),
        nvl(avg_zk_arpu_04,0),
        nvl(zk_arpu_06,0),
        nvl(is_xz,0)
from temp_hlw_5g_term_zk_bl_user_info_01
;
