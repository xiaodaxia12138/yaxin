-- 此段代码将年替换成参数即可,拍照数据
drop table temp_hlw_school_tongji_huisuan_pzuser_02;
create table temp_hlw_school_tongji_huisuan_pzuser_02
(
	user_id bigint,
	product_no varchar(20),
	pz_fee decimal(20,2)
) distributed by ('user_id')
;

insert into temp_hlw_school_tongji_huisuan_pzuser_02
select	distinct t1.user_id,t2.product_no,nvl(t3.zk_arpu,0)+nvl(t3.jfdh_fee,0) as pz_fee
from
(
	select user_id
	from cqbassdb.dw_user_useage_privilege_dt_${pyyyy}1231
	where privsetid in ('pip_main_5gdg59','pip_main_5gdg79','pip_main_5gdg99',
	'pip_main_mzsgc79_2','pip_main_mzsgc79 ','pip_main_mzsgc99','pip_main_qck19',
	'pip_main_qck19n','pip_main_qck39','pip_main_qck39n','pip_main_qck59','pip_main_qck59n',
	'gl_ydwk19b','gl_ydwk19a','gl_ydwk39b','gl_ydwk39a','gl_ydwk59b','gl_ydwk59a')
	and (enddate>'${pyyyy}-12-31' or enddate is null)
) t1
inner join
(
	select user_id,product_no
	from cqbassdb.dw_zzqs_user_conn_qianyue_dt_${pyyyy}1231        -- 拍照时间
	where tongxin_month=1 and IS_WLK=0
) t2 on t1.user_id=t2.user_id
left join cqbassdb.dw_user_arpu_mou_dou_mm_${pyyyy}12 t3 on t1.user_id=t3.user_id
;






-- 输出结果

delete from HLW_ST_QCK_IOPREPORT_MM_${YYYY} where op_time='${YYYYMM}';
insert into HLW_ST_QCK_IOPREPORT_MM_${YYYY}
select  q1.month_date as op_time,
		q1.value,
		q1.value1,
		q1.value2,
		q1.value3,
		q1.value4,
		q1.value5,
		q2.value6,
		q1.value7,
		q1.value8,
		q1.value9,
		q1.value10,
		q1.value11
from
(
	select	'${taskidyyyymm}' as month_date,
			count(distinct t1.user_id) as value,                                     -- 拍照用户
			count(distinct case when t2.user_id is not null then t1.user_id end) as value1,         -- 拍照保有用户
			round(count(distinct case when t2.user_id is not null then t1.user_id end)/count(distinct t1.user_id),4) as value2,         -- 拍照用户保有率
			sum(t1.pz_fee) as value3,         -- 拍照收入
			sum(nvl(t3.zk_arpu,0)+nvl(t3.jfdh_fee,0)) as value4,         -- 拍照保有收入
			round(sum(nvl(t3.zk_arpu,0)+nvl(t3.jfdh_fee,0))/sum(t1.pz_fee),4) as value5,         -- 拍照收入保有率
			0 as value6,         -- 当月通信用户
			round(count(distinct case when t2.user_id is not null then t4.user_id end)/count(distinct t1.user_id),4) as value7,         -- 5G套包渗透率
			round(count(distinct case when t2.user_id is not null then t5.user_id end)/count(distinct t1.user_id),4) as value8,         -- 签约率
			round(sum(t3.zk_arpu)/count(distinct t1.user_id),2) as value9,         -- 人均折后ARPU
			round(sum(t3.dou)/count(distinct t1.user_id),2) as value10,         -- 人均折后DOU
			round(sum(t3.mou)/count(distinct t1.user_id),2) as value11         -- 人均折后MOU
	from temp_hlw_school_tongji_huisuan_pzuser_02 t1
	left join
	(
		select	distinct user_id,product_no
		from cqbassdb.dw_zzqs_user_conn_qianyue_dt_${ldtaskid}
		where tongxin_month=1
	) t2 on t1.user_id=t2.user_id
	left join cqbassdb.dw_user_arpu_mou_dou_mm_${taskidyyyymm} t3 on t1.user_id=t3.user_id
	left join
	(
		select	distinct user_id from cqbassdb.dw_zzqs_5g_tb_detail_dt_${ldtaskid}
		where USERSTATUS_NAME not in ('临时生成资料','临时资料交费开机','回退') and (enddate>='${aftermonth_beginday}' or enddate is null)
	) t4 on t1.user_id=t4.user_id
	left join 
	(
		select distinct user_id 
		from cqbassdb.dw_user_useage_privilege_dt_${ldtaskid} a 
		inner join cqbassdb.dim_pub_qianyue_2019 b on a.PRIVSETID=b.itemid
		where (a.enddate>='${sde_date}' or a.enddate is null)
	) t5 on t1.user_id=t5.user_id
) q1
left join
(
	select '${taskidyyyymm}' as month_date,
			count(distinct t1.user_id) as value6
	from
	(
		select user_id
		from cqbassdb.dw_user_useage_privilege_dt_${ldtaskid}
		where privsetid in ('pip_main_5gdg59','pip_main_5gdg79','pip_main_5gdg99',
		'pip_main_mzsgc79_2','pip_main_mzsgc79 ','pip_main_mzsgc99','pip_main_qck19',
		'pip_main_qck19n','pip_main_qck39','pip_main_qck39n','pip_main_qck59','pip_main_qck59n',
		'gl_ydwk19b','gl_ydwk19a','gl_ydwk39b','gl_ydwk39a','gl_ydwk59b','gl_ydwk59a')
		and (enddate>'${sde_date}' or enddate is null)
	) t1
	inner join
	(
		select user_id,product_no
		from cqbassdb.dw_zzqs_user_conn_qianyue_dt_${ldtaskid}
		where tongxin_month=1 and IS_WLK=0
	) t2 on t1.user_id=t2.user_id
) q2 on q1.month_date=q2.month_date
;



HLW_ST_QCK_IOPREPORT_MM_${YYYY}
青春卡统计报表
hlw_st_qck_iopreport_mm_ym.mql






调度时间 op_time	varchar(10)
拍照用户	value	bigint
拍照保有用户	value1	bigint
拍照用户保有率	value2	decimal(24,4)
拍照收入	value3	decimal(42,2)
拍照保有收入	value4	decimal(43,2)
拍照收入保有率	value5	decimal(48,4)
当月通信用户	value6	bigint
5G套包渗透率	value7	decimal(20,4)
签约率	value8	decimal(20,4)
人均折后ARPU	value9	decimal(20,2)
人均折后DOU	value10	decimal(20,2)
人均折后MOU	value11	decimal(20,2)

select op_time,
value,
value1,
value2,
value3,
value4,
value5,
value6,
value7,
value8,
value9,
value10,
value11
from HLW_ST_QCK_IOPREPORT_MM_${batchNo?substring(0,4)}
where op_time='${batchNo?substring(0,6)}'









月份
拍照用户
拍照保有用户
拍照用户保有率
拍照收入
拍照保有收入
拍照收入保有率
当月通信用户
5G套包渗透率
签约率
人均折后ARPU
人均DOU
人均MOU


HLWG65158
/data03/cqioprpt/clyyzx/m/

___明早搞















temp_hlw_school_tongji_huisuan_mm_june_03
