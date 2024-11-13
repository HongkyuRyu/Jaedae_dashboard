

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
	C.제대타입,
	CONCAT(C.제대타입, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) AS '단가key'
FROM MMMO_ORDER_M AS A
	LEFT JOIN SMOR_ORDER_H AS B
		ON A.NO_SMOR = B.NO_SMOR
	LEFT JOIN CTE AS C
		ON A.NO_SMOR = C.NO_SMOR
WHERE A.DT_REQ BETWEEN '20240926' AND '20241025'
  AND A.CK_END <> '9'
  AND A.CD_PROCESS = '05'
  AND A.CD_CUST IN ('006235', '006026', '006656', '019633')

)
, price AS (
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
	제대타입,
	단가key,
	CASE 
        WHEN analysis.단가key = '삼방-패트52-300' THEN 10
        WHEN analysis.단가key = '삼방-나이론70-250' THEN 7
        WHEN analysis.단가key = '삼방-나이론80-350' THEN 9
        WHEN analysis.단가key = '삼방-나이론65-320' THEN 8
        WHEN analysis.단가key = '삼방-나이론80-370' THEN 10
        WHEN analysis.단가key = '삼방-패트(유무광)100-300' THEN 8.5
        WHEN analysis.단가key = '삼방-[구이 2-10]나이론(자동포장용)100-240' THEN 6
        WHEN analysis.단가key = '삼방-나이론60-250' THEN 7.5
        WHEN analysis.단가key = '삼방-패트60-420' THEN 11
        WHEN analysis.단가key = '삼방-나이론(유백/유무광)105-230' THEN 6
        WHEN analysis.단가key = '삼방-패트90-190' THEN 4
        WHEN analysis.단가key = '삼방-[구이 2-24]나이론(자동포장용)100-350' THEN 9
        WHEN analysis.단가key = '삼방-[구이 2-18]나이론(자동포장용)100-240' THEN 6
        WHEN analysis.단가key = '삼방-은박95-400' THEN 10
        WHEN analysis.단가key = '삼방-오씨피피(투명)60-190' THEN 7
        WHEN analysis.단가key = '삼방-나이론105-300' THEN 8
        WHEN analysis.단가key = '삼방-나이론70=무지-450' THEN 14
        WHEN analysis.단가key = '삼방-나이론80-280' THEN 7
		-- 삼방-나이론70-200 단가 고정X 왔다갔다함.
        WHEN analysis.단가key = '삼방-나이론70-200' THEN 5
        WHEN analysis.단가key = '삼방-나이론105-205' THEN 5
        WHEN analysis.단가key = '삼방-나이론70-220' THEN 6
        WHEN analysis.단가key = '삼방-나이론100-350' THEN 9
        WHEN analysis.단가key = '삼방-패증착150-285' THEN 8
        WHEN analysis.단가key = '삼방-나이론70-160' THEN 5
        WHEN analysis.단가key = '삼방-패씨피피60-210' THEN 6
        WHEN analysis.단가key = '삼방-패트(유무광)100-220' THEN 6
        WHEN analysis.단가key = '삼방-나이론(크린)80-430' THEN 11.5
        WHEN analysis.단가key = '삼방-나이론60-350' THEN 9.5
        WHEN analysis.단가key = '삼방-패트92-280' THEN 7
        WHEN analysis.단가key = '삼방-패트(칼라/노랑)100-270' THEN 7
        WHEN analysis.단가key = '삼방-패트92-300' THEN 8
        WHEN analysis.단가key = '삼방-나이론80-200' THEN 5
        WHEN analysis.단가key = '삼방-나이론70-350' THEN 9
        WHEN analysis.단가key = '삼방-은박93-200' THEN 5
        WHEN analysis.단가key = '삼방-나이론105-102' THEN 5
        WHEN analysis.단가key = '삼방-나이론110-180' THEN 5
        WHEN analysis.단가key = '삼방-나이론63-220' THEN 6
        WHEN analysis.단가key = '삼방-나이론(옥텐)90-250' THEN 7
        WHEN analysis.단가key = '삼방-나이론80-250' THEN 7
        WHEN analysis.단가key = '삼방-나이론60-200' THEN 5
        WHEN analysis.단가key = '삼방-나이론100-200' THEN 5
        WHEN analysis.단가key = '삼방-나이론70-230' THEN 6
        WHEN analysis.단가key = '삼방-패트60-160' THEN 5
        WHEN analysis.단가key = '삼방-나이론70-210' THEN 6
        WHEN analysis.단가key = '삼방-나이론80-210' THEN 6
        WHEN analysis.단가key = '삼방-오씨피피(무광)60-100' THEN 8
        WHEN analysis.단가key = '삼방-나이론90-400' THEN 10
        WHEN analysis.단가key = '삼방-나이론(투명)110-200' THEN 5
        WHEN analysis.단가key = '삼방-패트120-215' THEN 6
        WHEN analysis.단가key = '삼방-나이론100-190' THEN 5
        WHEN analysis.단가key = '삼방-나씨피피55-230' THEN 6
        WHEN analysis.단가key = '삼방-패트70-190' THEN 5
        WHEN analysis.단가key = '삼방-나이론110-315' THEN 8
        WHEN analysis.단가key = '삼방-나이론95-210' THEN 6
        WHEN analysis.단가key = '삼방-나이론(유무광)100-220' THEN 6
        WHEN analysis.단가key = '삼방-패트100-320' THEN 8
        WHEN analysis.단가key = '삼방-나이론(옥텐)100-300' THEN 8
        WHEN analysis.단가key = '삼방-패트(무광)100-250' THEN 7
        WHEN analysis.단가key = '삼방-나이론90-160' THEN 5
        WHEN analysis.단가key = '삼방-나이론90-180' THEN 5
        WHEN analysis.단가key = '삼방-나이론110-200' THEN 5
        WHEN analysis.단가key = '삼방-패나이론120-150' THEN 4
        WHEN analysis.단가key = '삼방-나이론60-300' THEN 8.5
        WHEN analysis.단가key = '삼방-나이론100-250' THEN 7
        WHEN analysis.단가key = '삼방-나이론70-180' THEN 5
        WHEN analysis.단가key = '삼방-증착70-250' THEN 7
        WHEN analysis.단가key = '삼방-은박(유무광)120-125' THEN 5
        WHEN analysis.단가key = '삼방-은박93-320' THEN 8
        WHEN analysis.단가key = '삼방-은박93=무지-350' THEN 9
        WHEN analysis.단가key = '삼방-2폭-은박93-170' THEN 4
        WHEN analysis.단가key = '삼방-2폭-은박93-150' THEN 4
        WHEN analysis.단가key = '삼방-2폭-은박100-90' THEN 4
        WHEN analysis.단가key = '삼방-2폭-나이론70-150' THEN 4
        WHEN analysis.단가key = '삼방-2폭-나이론110-180' THEN 4
        WHEN analysis.단가key = '삼방-2폭-나이론80-147' THEN 4.5
        WHEN analysis.단가key = '삼방-2폭-나이론(옥텐)130-240' THEN 6
        WHEN analysis.단가key = '삼방-2폭-나이론(유무광)100-200' THEN 4.5
        WHEN analysis.단가key = '삼방-2폭-나이론80-75' THEN 5
        WHEN analysis.단가key = '삼방-2폭-은박93-100' THEN 4.5
        WHEN analysis.단가key = '삼방-2폭-나이론70-160' THEN 4
        WHEN analysis.단가key = '삼방-2폭-크증착130-100' THEN 5
        WHEN analysis.단가key = '삼방-2폭-은박93=무지-130' THEN 4
        WHEN analysis.단가key = '삼방꼬리-패트80-340' THEN 12
        WHEN analysis.단가key = '삼방꼬리-나이론60-380' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-나이론60-350' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-나이론80-340' THEN 12
        WHEN analysis.단가key = '삼방꼬리-나이론70-500' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-나이론60-360' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-나이론60-250' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-나이론(청색)140-480' THEN 14
        WHEN analysis.단가key = '삼방꼬리-나이론55-250' THEN 14
        WHEN analysis.단가key = '삼방꼬리-나이론70-350' THEN 14
        WHEN analysis.단가key = '삼방꼬리-나이론60-280' THEN 18
        WHEN analysis.단가key = '삼방꼬리-오씨피피80-210' THEN 12
        WHEN analysis.단가key = '삼방꼬리-은박93-400' THEN 14
        WHEN analysis.단가key = '삼방꼬리-나이론(유무광)70-400' THEN 14
        WHEN analysis.단가key = '삼방-풀발이-패트(유백)90-320' THEN 25.6
        WHEN analysis.단가key = '삼방-풀발이-노루지증착120-390' THEN 31.2
        WHEN analysis.단가key = '삼방스탠드-은박140-150' THEN 15
        WHEN analysis.단가key = '삼방스탠드-패트140-140' THEN 14
        WHEN analysis.단가key = '삼방스탠드-패씨피피(유무광)80-150' THEN 15
        WHEN analysis.단가key = '삼방스탠드-지퍼-패트120-200' THEN 28
        WHEN analysis.단가key = '삼방스탠드-지퍼-크증착130-180' THEN 25.2
        WHEN analysis.단가key = '삼방스탠드-지퍼-진지스120=무지-180' THEN 25.2
        WHEN analysis.단가key = '삼방스탠드-지퍼-패트100-150' THEN 21
        WHEN analysis.단가key = '삼방스탠드-지퍼-크증착130-200' THEN 28
        WHEN analysis.단가key = '삼방스탠드-지퍼-패트120-150' THEN 21
        WHEN analysis.단가key = '삼방스탠드-지퍼-진지스120-200' THEN 28
        WHEN analysis.단가key = '삼방스탠드-지퍼-진지스120-150' THEN 21
        WHEN analysis.단가key = '삼방스탠드-지퍼-진지스120-130' THEN 18.2
        WHEN analysis.단가key = '삼방-지퍼-진지90-250' THEN 25
        WHEN analysis.단가key = '삼방-지퍼-은박100=1도(백베다)-130' THEN 13.2
        WHEN analysis.단가key = '삼방-지퍼-패트(유무광)90-230' THEN 23.5
        WHEN analysis.단가key = '삼방-지퍼-패트(유무광)90-250' THEN 25
        WHEN analysis.단가key = '삼방-지퍼-패트105-260' THEN 26
        WHEN analysis.단가key = '삼방-지퍼-나이론(유백/유무광)115-250' THEN 25.5
        WHEN analysis.단가key = '삼방-지퍼-나이론(유백)95-285' THEN 29
        WHEN analysis.단가key = '삼방-지퍼-오피피(무광)80-260' THEN 27
        WHEN analysis.단가key = '삼방-지퍼-패트90-275' THEN 28
        WHEN analysis.단가key = '삼방-지퍼-패트90-250' THEN 25
        WHEN analysis.단가key = '삼방-지퍼-오씨피피(투명)80-230' THEN 23.5
        WHEN analysis.단가key = '삼방-지퍼-패트90-230' THEN 23
        WHEN analysis.단가key = '삼방-지퍼-오씨피피(유무광)80-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-패트150-260' THEN 26
        WHEN analysis.단가key = '삼방-지퍼-패트70-340' THEN 34
        WHEN analysis.단가key = '삼방-지퍼-패트70-275' THEN 27.5
        WHEN analysis.단가key = '삼방-지퍼-진지90-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-오피피(무광)80-170' THEN 17.2
        WHEN analysis.단가key = '삼방-지퍼-패트90-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-나이론100-320' THEN 32
        WHEN analysis.단가key = '삼방-지퍼-나이론(유무광)105-260' THEN 26
        WHEN analysis.단가key = '삼방-지퍼-오씨피피(투명)80-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-오피피(무광)70-320' THEN 32.2
        WHEN analysis.단가key = '삼방-지퍼-패트100-130' THEN 13.2
        WHEN analysis.단가key = '삼방-지퍼-오씨피피(유무광)80-300' THEN 30
        WHEN analysis.단가key = '삼방-지퍼-패트(유무광)120-150' THEN 15
        WHEN analysis.단가key = '삼방-지퍼-패트90-215' THEN 21.7
        WHEN analysis.단가key = '삼방-지퍼-패트(유무광)120-200' THEN 20.2
        WHEN analysis.단가key = '삼방-지퍼-패트100-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-진지90-320' THEN 32
        WHEN analysis.단가key = '삼방-지퍼-은지93-320' THEN 32
        WHEN analysis.단가key = '삼방-지퍼-은지93-250' THEN 25
        WHEN analysis.단가key = '삼방-지퍼-진지90-160' THEN 16
        WHEN analysis.단가key = '삼방-지퍼-은지93-200' THEN 20
        WHEN analysis.단가key = '삼방-지퍼-2폭-은박(유무광)100-115' THEN 11.5
        WHEN analysis.단가key = '삼방-포켓지퍼-패트100-210' THEN 25.2
        WHEN analysis.단가key = '삼방-포켓지퍼-패트100-240' THEN 28.8
        WHEN analysis.단가key = '삼방-포켓지퍼-패트(유무광)100-125' THEN 15.2
        WHEN analysis.단가key = '삼방-HD씨링-나이론70=무지-400' THEN 13
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-450' THEN 14
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-400' THEN 10.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-180' THEN 5.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-230' THEN 5.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-200' THEN 5.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론60-200' THEN 5.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론60-350' THEN 9.5
        WHEN analysis.단가key = '삼방-HD씨링-나이론70-250' THEN 7.5
        WHEN analysis.단가key = '삼방꼬리-HD씨링-나이론70-500' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-HD씨링-나이론70-450' THEN 14.5
        WHEN analysis.단가key = '삼방꼬리-HD씨링-나이론60-400' THEN 14.5
        WHEN analysis.단가key = '삼방-2폭-HD씨링-나이론70-100' THEN 4.5
        WHEN analysis.단가key = '삼방-2폭-HD씨링-나이론70-150' THEN 4.5
        WHEN analysis.단가key = '2단삼방-풀발이-전백후증70-225' THEN 20
    END AS 단가
FROM analysis
WHERE analysis.주문번호 IN (
'20240911-1000165531', '20240912-1000150889', '20240912-131020', '20240912-131021', '20240913-1000141313',
    '20240913-1000161052', '20240913-1619P0121', '20240913-900017', '20240913-900018', '20240913-903002',
    '20240913-903003', '20240913-903005', '20240919-1000138905', '20240919-1000146651', '20240919-1000161236',
    '20240919-1000168755', '20240919-1000168759', '20240919-1000168763', '20240919-1000169125', '20240919-1000169130',
    '20240919-1000169131', '20240919-1000169132', '20240919-1218P0339', '20240919-1219P0390', '20240920-1000137857',
    '20240920-1000139379', '20240920-1000141556', '20240920-1000148427', '20240920-1000150481', '20240920-1000154562',
    '20240920-1000159302', '20240920-1000163172', '20240920-1000163519', '20240920-1000168434', '20240920-1000169135',
    '20240920-1116P0004', '20240920-1218P0326', '20240920-140626', '20240923-1000136494', '20240923-1000136504',
    '20240923-1000152324', '20240923-1000154707', '20240923-1000157709', '20240923-1000158450', '20240923-1000161378',
    '20240923-1000162478', '20240923-1000167708', '20240923-11150297', '20240923-1117P0161', '20240923-1118P0261',
    '20240924-1000136058', '20240924-1000136714', '20240924-1000141398', '20240924-1000150070', '20240924-1000154318',
    '20240924-1000162997', '20240924-1000169142', '20240924-1000169159', '20240924-1000169166', '20240924-1000169175',
    '20240924-1000169177', '20240924-1000169179', '20240924-11150360', '20240924-1117P0162', '20240924-1119P0054',
    '20240924-130537', '20240924-1320N0003', '20240925-1000143215', '20240925-1000146575', '20240925-1000154950',
    '20240925-1000169195', '20240925-1000169208', '20240925-11150225', '20240925-1117N0054', '20240925-1120P0066',
    '20240925-12150484', '20240925-1219P0311', '20240925-13160151', '20240925-1316N0011', '20240925-1316P0076',
    '20240926-1000138836', '20240926-1000146475', '20240926-1000148670', '20240926-1000148794', '20240926-1000155576',
    '20240926-1000155583', '20240926-1000160893', '20240926-1000161209', '20240926-1000169201', '20240926-1216P0146',
    '20240926-13160151', '20240927-1000150490', '20240927-1000160680', '20240927-1000162013', '20240927-1000169198',
    '20240927-1117N0055', '20240927-1217P0106', '20240927-1220P0186', '20240927-900022', '20240927-900023',
    '20240930-1000141201', '20240930-1000144319', '20240930-1000149756', '20240930-1000154020', '20240930-1000163203',
    '20240930-1000163638', '20240930-1000165711', '20240930-1000166093', '20240930-1000169223', '20240930-1000169224',
    '20240930-1118N0021', '20240930-1316P0072', '20240930-900001', '20240930-900009', '20240930-900010', '20240930-900021',
    '20240930-900022', '20240930-901001', '20240930-901008', '20241002-1000136587', '20241002-1000137857',
    '20241002-1000143265', '20241002-1000143944', '20241002-1000152197', '20241002-1000154859', '20241002-1000156505',
    '20241002-1000156900', '20241002-1000157411', '20241002-1000159704', '20241002-1000166861', '20241002-1000167365',
    '20241002-1000167373', '20241002-1000167792', '20241002-1000168423', '20241002-1000168606', '20241002-1000169234',
    '20241002-1000169238', '20241002-1119N0012', '20241002-1218P0338', '20241002-13160150', '20241002-902001',
    '20241002-902002', '20241002-902003', '20241002-902004', '20241002-903002', '20241002-903003', '20241002-903004',
    '20241004-1000155625', '20241004-1000169250', '20241004-910001', '20241004-910002', '20241004-910003', '20241004-910004',
    '20241004-910005', '20241007-1000136128', '20241007-1000136979', '20241007-1000143472', '20241007-1000150481',
    '20241007-1000150745', '20241007-1000164958', '20241007-1000169251', '20241007-1219N0043', '20241007-1219P0218',
    '20241007-1219P0219', '20241007-1219P0228', '20241007-1219P0330', '20241007-13150099', '20241007-13150140',
    '20241007-910007', '20241007-910008', '20241007-910513', '20241007-910514', '20241007-910515', '20241008-1000138905',
    '20241008-1000154025', '20241008-1000165766', '20241008-1218N0070', '20241008-1218P0211', '20241008-900002',
    '20241008-910513', '20241008-910514', '20241010-1000137856', '20241010-1000138362', '20241010-1000150743',
    '20241010-1000153557', '20241010-1000153900', '20241010-1000153902', '20241010-1000153904', '20241010-1000157188',
    '20241010-1000157466', '20241010-1000160038', '20241010-1000163997', '20241010-1000165711', '20241010-1000167792',
    '20241010-1000168606', '20241010-1119P0153', '20241010-1219P0060', '20241011-1000137720', '20241011-1000151457',
    '20241011-1000159593', '20241011-1000165460', '20241011-1000169293', '20241011-131021', '20241011-131022',
    '20241011-1619N0040', '20241014-1000165165', '20241014-1000169319', '20241014-1000169335', '20241014-1619N0021',
    '20241015-1316N1128', '20241016-1217N0087')
)
SELECT
	DISTINCT 주문번호,
	주문일자,
	외주처명,
	공정코드,
	공정납기일,
	품목이름,
	품목타입,
	품목너비,
	제대타입,
	단가key,
	작업지시량,
	단가,
	단가*작업지시량 AS '추정_공급가액'
FROM price

ORDER BY 주문번호 ASC;