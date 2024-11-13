  WITH CTE AS (
    SELECT
        B1.NO_SMOR,
        C1.CODE,
        C1.VL_WIDTH,
        C1.VL_LENGTH,
        C1.UP_PRICE,
        ROW_NUMBER() OVER (
            PARTITION BY B1.NO_SMOR
            ORDER BY
                CASE
                    WHEN CAST(B1.VL_PRODUCTWIDTH AS INTEGER) = 0 THEN ABS(C1.VL_LENGTH - B1.VL_PRODUCTHEIGHT)
                    ELSE ABS(C1.VL_WIDTH - B1.VL_PRODUCTWIDTH)
                END ASC
        ) AS RN
    FROM BSIN_PRCOST AS C1
    INNER JOIN SMOR_ORDER_H AS B1
        ON B1.CD_JAEDAETYPE = C1.CODE
    WHERE
        (C1.VL_WIDTH IS NOT NULL AND B1.VL_PRODUCTWIDTH IS NOT NULL)
        OR (C1.VL_LENGTH IS NOT NULL AND B1.VL_PRODUCTHEIGHT IS NOT NULL)
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
    B.CD_JAEDAETYPE AS '제대타입',
    B.VL_PRODUCTWIDTH AS '품목너비',
    B.VL_PRODUCTHEIGHT AS '품목높이',
    C.VL_WIDTH AS '기준너비',
    C.VL_LENGTH AS '기준높이',
    -- 제대코드에 따라 단가 계산식 선택(변경해야함)
    CASE
        WHEN B.CD_JAEDAETYPE IN ('046', '048', '052', '053', '054', '026', '027', '040', '050', '056', '057')
        THEN B.VL_PRODUCTWIDTH * 0.1
        ELSE C.UP_PRICE
    END AS '단가',
    -- 단가 계산식 반영한 공급가액 계산(변경해야함)
    CAST(CAST(A.QT_ORDER AS INTEGER) *
         CASE
             WHEN B.CD_JAEDAETYPE IN ('046', '048', '052', '053', '054', '026', '027', '040', '050', '056', '057')
             THEN B.VL_PRODUCTWIDTH * 0.1
             ELSE C.UP_PRICE
         END AS INTEGER) AS '추정 공급가액'
FROM MMMO_ORDER_M AS A
LEFT JOIN SMOR_ORDER_H AS B
    ON A.NO_SMOR = B.NO_SMOR
LEFT JOIN CTE AS C
    ON B.NO_SMOR = C.NO_SMOR
    AND B.CD_JAEDAETYPE = C.CODE
    AND C.RN = 1
WHERE A.NO_SMOR = '20240909-1000168436'
-- WHERE A.DT_REQ BETWEEN '20241026' AND '20241125'
  AND A.CK_END <> '9'
  AND A.CD_PROCESS = '05'
  AND A.CD_CUST IN ('006235');
 -- AND A.CD_CUST IN ('006235', '006026', '006656', '019633');