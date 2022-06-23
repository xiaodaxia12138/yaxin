select op_time,''
from cqbassdb.dw_operation_req_202203 t1
inner join
(
    select f1 as type,f2 as priv_name,f3 as privsetid,f4 as price 
    from HLW_DW_REF_JF_DIM_DATACODE_DETAIL_DAC_${taskid} where data_key = 'kxb_code'
    and f1 in ('滚动计费','日包-已下线','时包','日包','三日包','月包','周包','定向流量')

) t2 on t1.operate_code=t2.privsetid

;