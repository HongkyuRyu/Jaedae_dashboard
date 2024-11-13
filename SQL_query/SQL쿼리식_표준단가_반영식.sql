												
												
	WITH CTE AS (											
												
		SELECT										
			NO_SMOR,									
			CASE									
				WHEN CD_JAEDAETYPE = '026' THEN '2단삼방-지퍼'																
				WHEN CD_JAEDAETYPE = '001' THEN '2단삼방'								
				WHEN CD_JAEDAETYPE = '002' THEN '2단삼방-2폭'								
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
	, analysis AS (											
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
		CAST(B.VL_PRODUCTHEIGHT AS INTEGER) AS '품목높이',										
		C.제대타입,										
		CASE										
			WHEN C.제대타입 = '삼방꼬리' THEN CONCAT(C.제대타입, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTHEIGHT AS INTEGER))									
			ELSE									
			CONCAT(C.제대타입, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) 									
		END AS '단가수정key',										
		CONCAT(C.제대타입, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) AS '단가key'										
	FROM MMMO_ORDER_M AS A											
		LEFT JOIN SMOR_ORDER_H AS B										
			ON A.NO_SMOR = B.NO_SMOR									
		LEFT JOIN CTE AS C										
			ON A.NO_SMOR = C.NO_SMOR									
	WHERE A.DT_REQ BETWEEN '20241026' AND '20241125'											
	  AND A.CK_END <> '9'											
	  AND A.CD_PROCESS = '05'											
	  AND A.CD_CUST IN ('006235', '006026', '006656', '019633')											
												
	)	, analysis2 AS (										
												
	SELECT											
		DISTINCT 주문번호,										
		주문일자,										
		외주처명,										
		공정코드,										
		공정납기일,										
		작업지시량,										
		품목이름,										
		품목타입,										
		품목너비,										
		품목높이,										
		제대타입,										
		단가key,										
		단가수정key,										
												
		-- 기본 단가 계산					
		CASE										
			WHEN 제대타입 IN ('삼방', '삼방-HD씨링', '삼방-2폭-HD씨링', '삼방-2폭', '2단삼방') THEN									
				CASE								
					WHEN 품목너비 <= 200 THEN 5							
					WHEN 품목너비 <= 240 THEN 6							
					WHEN 품목너비 <= 280 THEN 7							
					WHEN 품목너비 <= 320 THEN 8							
					WHEN 품목너비 <= 360 THEN 9							
					WHEN 품목너비 <= 400 THEN 10							
					WHEN 품목너비 <= 440 THEN 11							
					WHEN 품목너비 <= 480 THEN 12							
					WHEN 품목너비 <= 520 THEN 13							
					WHEN 품목너비 <= 560 THEN 14							
					WHEN 품목너비 <= 600 THEN 15							
					WHEN 품목너비 <= 640 THEN 16							
					ELSE 0							
				END								
			WHEN 제대타입 IN ('삼방꼬리', '삼방꼬리-HD씨링') THEN									
				CASE								
					WHEN 품목높이 <= 599 THEN 12							
					WHEN 품목너비 <= 699 THEN 14							
					WHEN 품목너비 <= 799 THEN 16							
					WHEN 품목너비 >= 800 THEN 18							
					ELSE 0							
				END								
			WHEN 제대타입 IN ('삼방-지퍼', '삼방스탠드', '2방스탠드', '삼방-지퍼-2폭', '2단삼방-지퍼', '삼방-포켓지퍼', '2단삼방-풀발이') THEN CAST(품목너비 / 10 AS INTEGER)									
			WHEN 제대타입 = '삼방스탠드-지퍼' THEN CAST(품목너비 / 10 * 1.4 AS DECIMAL(10, 0))									
			ELSE 0									
			END									
			AS '기본단가'									
												
	FROM analysis											
												
		)										
		SELECT										
		*,		
        -- 기본 단가 계산 후, 최종 단가 반영								
		-- 2폭 및 HD씨링에 따른 단가 수정										
		CASE										
			WHEN 단가수정key LIKE '%HD씨링%' THEN									
				CASE								
					WHEN 단가수정key LIKE '%2폭%' THEN (기본단가 + 0.5-1)							
					ELSE (기본단가 + 0.5)							
				END								
			WHEN 단가수정key LIKE '%2폭%' THEN									
				(기본단가 - 1)								
			ELSE 기본단가									
		END AS 최종단가										
		FROM analysis2										
