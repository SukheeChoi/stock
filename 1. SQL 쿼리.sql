SELECT   J1.STK_CD, J1.STK_NM
		, ROUND( (J2.NET_INCOME / J1.NET_INCOME) * 100, 1 ) 부채비율
		, ROUND( (J4.NET_INCOME / J3.NET_INCOME) * 100, 1 ) 유동비율
        , ROUND( (F1.FIN_ITM_VAL / 1e8), 1 ) `당기순이익(억)`
        , ROUND( (F1.FIN_ITM_VAL / J1.Net_INCOME) * 100 ,1 ) ROE
        , ROUND( (C2.CIGA_SUM / F1.FIN_ITM_VAL), 1 ) PER
        , ROUND( SUM(H1.VOL) / 1e8 , 1 ) `거래량합(억)`
FROM jaemo J1
	INNER JOIN finance_y F1 ON (J1.STK_CD = F1.STK_CD)
	INNER JOIN ciga C2 ON (F1.STK_CD = C2.STK_CD)
    INNER JOIN history_ym H1 ON(C2.STK_CD = H1.STK_CD)
	INNER JOIN jaemo J2 ON (J2.SET_DT = J1.SET_DT AND J2.STK_NM = J1.STK_NM)
	,jaemo J3
	INNER JOIN jaemo J4 ON (J4.SET_DT = J3.SET_DT AND J4.STK_NM = J3.STK_NM)
WHERE J1.SET_DT = '2018-12-31'
AND J1.SET_DT = J3.SET_DT AND J1.STK_NM = J3.STK_NM
AND J1.ITEM_NM = "자본총계" AND J2.ITEM_NM = '부채총계'
AND J3.ITEM_NM = "유동부채" AND J4.ITEM_NM = '유동자산'
AND F1.FIN_ITM_NM = '당기순이익'
AND F1.YY = '2018'
AND H1.YM BETWEEN '201801' AND '201812'
GROUP BY J1.STK_CD
HAVING 부채비율 < 100 AND 유동비율 >200 AND ROE >= 5 AND PER < 10
AND `당기순이익(억)` >= 535.2
# 중첩조건을 통과한 종목중 30번째 당기순이익이 535.2억이므로
# 당기순이익이 535.2억 이상인 종목들의 거래량을 살펴본다.
ORDER BY `거래량합(억)` DESC
;
