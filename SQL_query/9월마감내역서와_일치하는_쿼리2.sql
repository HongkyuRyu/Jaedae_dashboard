

WITH CTE AS (							
							
	SELECT						
		NO_SMOR,					
		CASE					
			WHEN CD_JAEDAETYPE = '018' THEN '삼방'				
			WHEN CD_JAEDAETYPE = '019' THEN '삼방-2폭'				
			WHEN CD_JAEDAETYPE = '022' THEN '삼방꼬리'				
			WHEN CD_JAEDAETYPE = '026' THEN '삼방-풀발이'				
			WHEN CD_JAEDAETYPE = '046' THEN '삼방스탠드'				
			WHEN CD_JAEDAETYPE = '048' THEN '삼방스탠드-지퍼'				
			WHEN CD_JAEDAETYPE = '052' THEN '삼방-지퍼'				
			WHEN CD_JAEDAETYPE = '053' THEN '삼방-지퍼-2폭'				
			WHEN CD_JAEDAETYPE = '054' THEN '삼방-포켓지퍼'				
			WHEN CD_JAEDAETYPE = '089' THEN '삼방-HD씨링'				
			WHEN CD_JAEDAETYPE = '090' THEN '삼방꼬리-HD씨링'				
			WHEN CD_JAEDAETYPE = '091' THEN '삼방-2폭-HD씨링'				
			WHEN CD_JAEDAETYPE = '092' THEN '2단삼방-풀발이'				
		END AS '제대타입'					
	FROM SMOR_ORDER_H						
)
SELECT							
    A.NO_SMOR AS '주문번호',							
    A.DT_COMP AS '주문일자',							
    CASE							
        WHEN A.CD_CUST = '006235' THEN '진포장'							
        WHEN A.CD_CUST = '006026' THEN '모든팩'							
        WHEN A.CD_CUST = '006656' THEN '엠에스팩'							
        WHEN A.CD_CUST = '019633' THEN '엠에스팩'							
        ELSE '기타'							
    END AS '외주처명',							
    A.CD_PROCESS AS '공정코드',							
    A.DT_REQ AS '공정납기일',							
    A.CK_END AS '작업완료여부',							
    A.QT_ORDER AS '작업지시량',							
    B.NM_PRODUCTNAME AS '품목이름',							
    B.NM_PRODUCTTYPE AS '품목타입',							
    CAST(B.VL_PRODUCTWIDTH AS INTEGER) AS '품목너비',							
	C.제대타입,						
	CONCAT(C.제대타입, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) AS '단가key'						
FROM MMMO_ORDER_M AS A							
	LEFT JOIN SMOR_ORDER_H AS B						
		ON A.NO_SMOR = B.NO_SMOR					
	LEFT JOIN CTE AS C						
		ON A.NO_SMOR = C.NO_SMOR					
WHERE A.DT_COMP BETWEEN '20240405' AND '20240924'						
  AND A.CK_END <> '9'							
  AND A.CD_PROCESS = '05'							
  AND A.CD_CUST IN ('006235', '006026', '006656', '019633')							
