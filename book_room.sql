    select distinct user_id,count(1) as cnt from cqbassdb.dw_zzqs_5g_tb_detail_dt_20220531
    where priv_type='5G叠加包'
    group by user_id
    ;