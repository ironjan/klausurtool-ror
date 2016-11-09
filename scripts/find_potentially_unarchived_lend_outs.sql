SELECT 
    *
FROM
    old_lend_outs o
        JOIN
    archived_old_lend_outs ao
WHERE
    ao.deposit = o.deposit
        AND ao.lender = o.lender
        AND ao.lendingTime = o.lendingTime;