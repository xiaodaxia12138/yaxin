drop table temp_hlw_szjt_1yuan_shouru_tongx;  -- 字段明细见68行
create table temp_hlw_szjt_1yuan_shouru_tongx as 
select distinct t1.user_id,t1.product_no,t1.county_name,t2.priv_type ,
        t3.zk_arpu as arpu_2,t4.zk_arpu as arpu_4,
        t5.is_jtq,
        case when t5.is_jtq=1 then t3.zk_arpu else 0 end as arpu_jt2,
        case when t5.is_jtq=1 then t4.zk_arpu else 0 end as arpu_jt4,
        case when t5.is_jtq=1 then t6.cnt else 0 end as cnt
        
from
(
    select distinct a.product_no,a.user_id,b.county_name
    from cqbassdb.dw_product_outetype_dt_20220331 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t1 -- 全市通信客户
inner join 
( 
    select distinct a.product_no,b.priv_type,b.priv_id
    from cqbassdb.dw_operation_req_202203 as  a
    inner join temp_hlw_dim_szjt_1yuan_priv_2022 b on a.operate_code=b.priv_id
    where a.status = 1 and (a.operate_desc like'加入%' or a.operate_desc like'参加%')
    and a.op_time <= '2022-05-31'
) t2 on t1.product_no=t2.product_no -- 目标套餐
left join cqbassdb.dw_user_arpu_mou_dou_mm_202202 t3 on t1.user_id=t3.user_id -- 2月arpu
left join cqbassdb.dw_user_arpu_mou_dou_mm_202204 t4 on t1.user_id=t4.user_id -- 4月arpu
left join 
(
    select  user_id, 
            case when style in ('超级家共享','一证多号','流量共享','同一wifi','家庭短号') then 1 else 0 end as is_jtq
    from     hlw_dw_jiating_gongxiang_quanzi_202202
) t5 on t1.user_id=t5.user_id   -- 2月家庭
left join hlw_dw_jiating_gongxiang_quanzi_202204 t6 on t1.user_id=t6.user_id


;
-- 输出表1：

select '全市通信客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end as county_name,
        count(distinct t1.user_id),
        count(distinct t2.user_id),
        sum(t2.arpu_2),sum(t2.arpu_4),sum(t2.arpu_jt2),sum(t2.arpu_jt4),sum(t2.is_jtq)
from 
(
    select distinct county_name, user_id ,product_no,priv_type
    from temp_hlw_szjt_1yuan_shouru_tongx
    where priv_type='数字家庭套餐'
) t1
left join
(
    select distinct product_no,user_id,priv_type,arpu_2,arpu_4,arpu_jt2,arpu_jt4,cnt,is_jtq 
    from temp_hlw_szjt_1yuan_shouru_tongx
    where priv_type='1元包'
) t2 on t1.product_no=t2.product_no
group by  case when county_name in ('南岸','渝中') then '城一'
               when county_name in ('渝北','江北','两江新区') then '城二'
               when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
              else county_name
          end
union all 
select '全市通信客户','全市',
        count(distinct t1.user_id),
        count(distinct t2.user_id),
        sum(t2.arpu_2),sum(t2.arpu_4),sum(t2.arpu_jt2),sum(t2.arpu_jt4),sum(t2.is_jtq)
from 
(
    select distinct county_name, user_id ,product_no,priv_type
    from temp_hlw_szjt_1yuan_shouru_tongx
    where priv_type='数字家庭套餐'
) t1
left join
(
    select distinct product_no,user_id,priv_type,arpu_2,arpu_4,arpu_jt2,arpu_jt4,cnt,is_jtq 
    from temp_hlw_szjt_1yuan_shouru_tongx
    where priv_type='1元包'
) t2 on t1.product_no=t2.product_no

;

drop table temp_hlw_szjt_1yuan_shouru_cunl;
create table temp_hlw_szjt_1yuan_shouru_cunl
(
    user_id bigint,
    product_no varchar(20),
    county_name varchar(100),
    priv_type varchar(100),   -- 家庭套餐和1元包套餐办理
    arpu_2 decimal(20,2),     -- 2月上述收入
    arpu_4 decimal(20,2),     -- 4月上述收入
    is_jtq int,               -- 是否家庭圈用户
    arpu_jt2 decimal(20,2),   -- 家庭圈用户2月收入
    arpu_jt4 decimal(20,2),   -- 家庭圈用户4月收入
    cnt int                   -- 家庭圈内人数
)distributed by ('product_no');

insert into temp_hlw_szjt_1yuan_shouru_cunl
select distinct t1.user_id,t1.product_no,t1.county_name,t2.priv_type ,
        t3.zk_arpu as arpu_2,t4.zk_arpu as arpu_4,
        t5.is_jtq,
        case when t5.is_jtq=1 then t3.zk_arpu else 0 end as arpu_jt2,
        case when t5.is_jtq=1 then t4.zk_arpu else 0 end as arpu_jt4,
        case when t5.is_jtq=1 then t6.cnt else 0 end as cnt
        
from
(
    select distinct a.product_no,a.user_id,b.county_name
    from cqbassdb.dw_product_outetype_dt_20211231 a
    left join cqbassdb.dim_pub_county_new b on a.county_id=b.county_id
    where a.active=1 and substr(a.gra_product_attr_id1,5,1)=1
) t1 -- 全市存量客户
inner join 
( 
    select distinct a.product_no,b.priv_type,b.priv_id
    from cqbassdb.dw_operation_req_202203 as  a
    inner join temp_hlw_dim_szjt_1yuan_priv_2022 b on a.operate_code=b.priv_id
    where a.status = 1 and (a.operate_desc like'加入%' or a.operate_desc like'参加%')
    and a.op_time <= '2022-05-31'
) t2 on t1.product_no=t2.product_no -- 目标套餐
left join cqbassdb.dw_user_arpu_mou_dou_mm_202202 t3 on t1.user_id=t3.user_id -- 2月arpu
left join cqbassdb.dw_user_arpu_mou_dou_mm_202204 t4 on t1.user_id=t4.user_id -- 4月arpu
left join 
(
    select  user_id, 
            case when style in ('超级家共享','一证多号','流量共享','同一wifi','家庭短号') then 1 else 0 end as is_jtq
    from     hlw_dw_jiating_gongxiang_quanzi_202202
) t5 on t1.user_id=t5.user_id   -- 2月家庭
left join hlw_dw_jiating_gongxiang_quanzi_202204 t6 on t1.user_id=t6.user_id
;
-- 输出表2：

select '全市存量客户',
        case when county_name in ('南岸','渝中') then '城一'
             when county_name in ('渝北','江北','两江新区') then '城二'
             when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
             else county_name
        end as county_name,
        count(distinct t1.user_id),
        count(distinct t2.user_id),
        sum(t2.arpu_2),sum(t2.arpu_4),sum(t2.arpu_jt2),sum(t2.arpu_jt4),sum(t2.is_jtq)
from 
(
    select distinct county_name, user_id ,product_no,priv_type
    from temp_hlw_szjt_1yuan_shouru_cunl
    where priv_type='数字家庭套餐'
) t1
left join
(
    select distinct product_no,user_id,priv_type,arpu_2,arpu_4,arpu_jt2,arpu_jt4,cnt,is_jtq 
    from temp_hlw_szjt_1yuan_shouru_cunl
    where priv_type='1元包'
) t2 on t1.product_no=t2.product_no
group by  case when county_name in ('南岸','渝中') then '城一'
               when county_name in ('渝北','江北','两江新区') then '城二'
               when county_name in ('沙坪坝','大渡口','九龙坡') then '城三' 
              else county_name
          end
union all 
select '全市存量客户','全市',
        count(distinct t1.user_id),
        count(distinct t2.user_id),
        sum(t2.arpu_2),sum(t2.arpu_4),sum(t2.arpu_jt2),sum(t2.arpu_jt4),sum(t2.is_jtq)
from 
(
    select distinct county_name, user_id ,product_no,priv_type
    from temp_hlw_szjt_1yuan_shouru_cunl
    where priv_type='数字家庭套餐'
) t1
left join
(
    select distinct product_no,user_id,priv_type,arpu_2,arpu_4,arpu_jt2,arpu_jt4,cnt,is_jtq 
    from temp_hlw_szjt_1yuan_shouru_cunl
    where priv_type='1元包'
) t2 on t1.product_no=t2.product_no

;