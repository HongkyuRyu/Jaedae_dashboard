WITH CTE AS (											
												
		SELECT										
			NO_SMOR,
			CD_JAEDAETYPE,
			--CD_PRINTTYPE,
			CASE		
				--WHEN CD_PRINTTYPE = '001' THEN '���ǳ���'
				--WHEN CD_PRINTTYPE = '002' THEN '���Ǿ��'
				--WHEN CD_PRINTTYPE = '003' THEN '����ǥ��'
				--WHEN CD_PRINTTYPE = '004' THEN 'Ʃ��ܸ�'
				--WHEN CD_PRINTTYPE = '005' THEN 'Ʃ����'
				--WHEN CD_PRINTTYPE = '006' THEN 'OPP����'
				--WHEN CD_PRINTTYPE = '007' THEN 'OPPǥ��'
				--WHEN CD_PRINTTYPE = '008' THEN '���̴ܸ�'
				--WHEN CD_PRINTTYPE = '009' THEN '���̾��'
				--WHEN CD_PRINTTYPE = '010' THEN '����(���۾�)'
				--WHEN CD_PRINTTYPE = '011' THEN '��ũ�μ�(����)'
				--WHEN CD_PRINTTYPE = '012' THEN '��ũ�μ�(����)'
				--WHEN CD_PRINTTYPE = '013' THEN 'Ư���μ�'
				WHEN CD_JAEDAETYPE = '026' THEN '2�ܻ��-����'	
				WHEN CD_JAEDAETYPE = '040' THEN '2�ܻ��-����'
				WHEN CD_JAEDAETYPE = '001' THEN '2�ܻ��'		
			    WHEN CD_JAEDAETYPE = '038' THEN '2�ܻ�潺�ĵ�-����'
				WHEN CD_JAEDAETYPE = '002' THEN '2�ܻ��-2��'								
				WHEN CD_JAEDAETYPE = '018' THEN '���'								
				WHEN CD_JAEDAETYPE = '019' THEN '���-2��'								
				WHEN CD_JAEDAETYPE = '022' THEN '��沿��'								
				WHEN CD_JAEDAETYPE = '026' THEN '���-Ǯ����'								
				WHEN CD_JAEDAETYPE = '046' THEN '��潺�ĵ�'								
				WHEN CD_JAEDAETYPE = '048' THEN '��潺�ĵ�-����'								
				WHEN CD_JAEDAETYPE = '052' THEN '���-����'								
				WHEN CD_JAEDAETYPE = '053' THEN '���-����-2��'								
				WHEN CD_JAEDAETYPE = '054' THEN '���-��������'								
				WHEN CD_JAEDAETYPE = '089' THEN '���-HD����'								
				WHEN CD_JAEDAETYPE = '090' THEN '��沿��-HD����'								
				WHEN CD_JAEDAETYPE = '091' THEN '���-2��-HD����'								
				WHEN CD_JAEDAETYPE = '092' THEN '2�ܻ��-Ǯ����'	
				WHEN CD_JAEDAETYPE = '066' THEN '����'
			END AS '����Ÿ��'									
		FROM SMOR_ORDER_H										
	) 											
	, analysis AS (											
	SELECT											
	    A.NO_SMOR AS '�ֹ���ȣ',											
	    A.DT_COMP AS '�ֹ�����',											
	    CASE											
	        WHEN A.CD_CUST = '006235' THEN '������'											
	        WHEN A.CD_CUST = '006026' THEN '�����'											
	        WHEN A.CD_CUST = '006656' THEN '��������'											
	        WHEN A.CD_CUST = '019633' THEN '��������'	
			WHEN A.CD_CUST = '029585' THEN '�ٿ���'
	        ELSE '��Ÿ'											
	    END AS '����ó��',											
	    A.CD_PROCESS AS '�����ڵ�',											
	    A.DT_REQ AS '����������',											
	    A.CK_END AS '�۾��ϷῩ��',											
	    A.QT_ORDER AS '�۾����÷�',											
	    B.NM_PRODUCTNAME AS 'ǰ���̸�',											
	    B.NM_PRODUCTTYPE AS 'ǰ��Ÿ��',											
	    CAST(B.VL_PRODUCTWIDTH AS INTEGER) AS 'ǰ��ʺ�',											
		CAST(B.VL_PRODUCTHEIGHT AS INTEGER) AS 'ǰ�����',	
		VL_FBWIDTH AS ������, 
		QT_MAKE AS ���ܱ���,
		CONVERT(INTEGER, CD_PRINTDEGREE) AS �μ⵵��,
		C.����Ÿ��,		
		C.CD_JAEDAETYPE,
		CASE										
			WHEN C.����Ÿ�� = '��沿��' THEN CONCAT(C.����Ÿ��, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTHEIGHT AS INTEGER))									
			ELSE									
			CONCAT(C.����Ÿ��, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) 									
		END AS '�ܰ�����key',										
		CONCAT(C.����Ÿ��, '-', B.NM_PRODUCTNAME, '-', CAST(B.VL_PRODUCTWIDTH AS INTEGER)) AS '�ܰ�key'										
	FROM MMMO_ORDER_M AS A											
		JOIN SMOR_ORDER_H AS B										
			ON A.NO_SMOR = B.NO_SMOR									
		JOIN CTE AS C										
			ON A.NO_SMOR = C.NO_SMOR									
	WHERE A.DT_REQ BETWEEN '20241226' AND '20250125' -- ����1��
	  AND A.CK_END <> '9'											
	  --AND A.CD_PROCESS = '05'											
	  AND A.CD_CUST IN ('006235', '006026', '006656', '019633')										
												
	)	, analysis2 AS (										
												
	SELECT											
		DISTINCT �ֹ���ȣ,										
		�ֹ�����,										
		����ó��,										
		�����ڵ�,										
		����������,										
		�۾����÷�,										
		ǰ���̸�,										
		ǰ��Ÿ��,										
		ǰ��ʺ�,										
		ǰ�����,										
		����Ÿ��,
		CD_JAEDAETYPE,
		�ܰ�key,										
		�ܰ�����key,										
												
		-- �⺻ �ܰ� ���					
		CASE	
			WHEN ����Ÿ�� = '����' THEN 9
			WHEN ǰ���̸� = '���̷�(û��)140' THEN 32
			WHEN ǰ���̸� = '���̷�(����)140' THEN 22
			WHEN ����Ÿ�� = '2�ܻ��' THEN 9
			WHEN ǰ���̸� = '��������(����)70' THEN 7
			WHEN ����Ÿ�� = '2�ܻ��-����' THEN 32
			WHEN ����Ÿ�� IN ('���', '���-HD����', '���-2��-HD����', '���-2��', '2�ܻ��', '2�ܻ��-2��') THEN									
				CASE								
					WHEN ǰ��ʺ� <= 200 THEN 5							
					WHEN ǰ��ʺ� <= 240 THEN 6							
					WHEN ǰ��ʺ� <= 280 THEN 7							
					WHEN ǰ��ʺ� <= 320 THEN 8							
					WHEN ǰ��ʺ� <= 360 THEN 9							
					WHEN ǰ��ʺ� <= 400 THEN 10							
					WHEN ǰ��ʺ� <= 440 THEN 11							
					WHEN ǰ��ʺ� <= 480 THEN 12							
					WHEN ǰ��ʺ� <= 520 THEN 13							
					WHEN ǰ��ʺ� <= 560 THEN 14							
					WHEN ǰ��ʺ� <= 600 THEN 15							
					WHEN ǰ��ʺ� <= 640 THEN 16							
					ELSE 0							
				END								
			WHEN ����Ÿ�� IN ('��沿��', '��沿��-HD����') THEN									
				CASE								
					WHEN ǰ����� <= 599 THEN 12							
					WHEN ǰ����� <= 699 THEN 14							
					WHEN ǰ����� <= 799 THEN 16							
					WHEN ǰ����� >= 800 THEN 18							
					ELSE 0							
				END								
			WHEN ����Ÿ�� IN ('���-����', '��潺�ĵ�', '2�潺�ĵ�', '���-����-2��', '2�ܻ��-����', '2�ܻ��-Ǯ����') 
			THEN CAST(ǰ��ʺ� / 10 AS INTEGER)									
			WHEN ����Ÿ�� IN('��潺�ĵ�-����', '2�ܻ�潺�ĵ�-����','���-��������') THEN CAST(ǰ��ʺ� / 10 * 1.4 AS DECIMAL(10, 1))									
			ELSE 0									
			END									
			AS 'basic_price'									
												
	FROM analysis											
												
		), final AS (									
		SELECT										
		*,		
        -- �⺻ �ܰ� ��� ��, ���� �ܰ� �ݿ�								
		-- 2�� �� HD������ ���� �ܰ� ����										
		CASE										
			WHEN ǰ��Ÿ�� LIKE '%HD����%' OR �ܰ�����key LIKE '%HD����%' THEN									
				CASE								
					WHEN ǰ��Ÿ�� LIKE '%2��%' OR �ܰ�����key LIKE '%2��%' THEN (basic_price + 0.5-1)							
					ELSE (basic_price + 0.5)							
				END								
			WHEN ǰ��Ÿ�� LIKE '%2��%' OR �ܰ�����key LIKE '%2��%' THEN									
				(basic_price - 1)								
			ELSE basic_price									
		END AS unit_price	
		FROM analysis2	
		)
		SELECT
		*,
		CAST(unit_price * �۾����÷� AS DECIMAL(10, 1)) AS estimate_price
		FROM final
		
		

		