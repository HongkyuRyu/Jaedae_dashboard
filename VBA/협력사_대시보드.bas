Attribute VB_Name = "final_vba2"


Sub finalVBA2()
    Dim wsOct As Worksheet, wsNov As Worksheet, wsPivot As Worksheet
    Dim wsDashboard As Worksheet
    Dim lastRow As Long, orderNumCol As Long, newCol As Long
    Dim i As Long, j As Long
    Dim lookupRange As Range
    Dim vlookupResult As Variant
    Dim ws As Worksheet
    Dim pt As PivotTable
    Dim chartObj As ChartObject
    Dim ptName As Variant
    Dim sheetName As Variant
    Dim sheetNames As Variant
    
    

    ' 시트 설정
    Set wsOct = ThisWorkbook.Sheets("10query")
    Set wsNov = ThisWorkbook.Sheets("11query")
    Set wsPivot = ThisWorkbook.Sheets("pivot")
    Set wsDashboard = ThisWorkbook.Sheets("dashboard") ' 대시보드 시트 설정

    ' 피벗 테이블 이름 배열
    Dim pivotTableNames As Variant
    pivotTableNames = Array("10query1-1", "10query1-2", "11query1-1", "11query1-2")

    ' (1) 쿼리 업데이트 실행
    ThisWorkbook.RefreshAll
    
    
    ' (2)
    On Error Resume Next
    wsOct.Columns("L:M").ClearContents
    On Error GoTo 0
    
    
  ' 참조 테이블 범위 설정
    Set lookupRange = ThisWorkbook.Sheets("reference").Range("E:F")
    
    ' 시트 배열 설정
    sheetNames = Array(wsOct, wsNov)
    
   ' (2) 기존 "unit_price" 및 "estimate_price" 열 삭제
    On Error Resume Next
    wsOct.Columns("L:M").ClearContents
    On Error GoTo 0
    
    ' (3) 단가 및 추정공급가액 열 추가 및 계산
    lastRow = wsOct.Cells(wsOct.Rows.Count, "K").End(xlUp).Row
    wsOct.Range("L1").Value = "unit_price"
    wsOct.Range("M1").Value = "estimate_price"

    ' 단가key를 기반으로 VLOOKUP 적용
    Set lookupRange = ThisWorkbook.Sheets("reference").Range("$E:$F")
    For i = 2 To lastRow
        vlookupResult = Application.VLookup(wsOct.Cells(i, "K"), lookupRange, 2, False)
        If Not IsError(vlookupResult) Then
            wsOct.Cells(i, "L").Value = vlookupResult
            wsOct.Cells(i, "M").Value = wsOct.Cells(i, "F").Value * vlookupResult
        Else
            wsOct.Cells(i, "L").Value = "0"  ' 찾을 수 없을 때
        End If
    Next i
    
    On Error Resume Next
    wsNov.Columns("P:Q").ClearContents
    On Error GoTo 0
    
    ' (3) 단가 및 추정공급가액 열 추가 및 계산
    lastRow = wsNov.Cells(wsNov.Rows.Count, "K").End(xlUp).Row
    wsNov.Range("P1").Value = "unit_price"
    wsNov.Range("Q1").Value = "estimate_price"

    ' 단가key를 기반으로 VLOOKUP 적용
    Set lookupRange = ThisWorkbook.Sheets("reference").Range("$E:$F")
    
    For i = 2 To lastRow
        vlookupResult = Application.VLookup(wsNov.Cells(i, "L"), lookupRange, 2, False)
        If Not IsError(vlookupResult) Then
            wsNov.Cells(i, "P").Value = vlookupResult
            wsNov.Cells(i, "Q").Value = wsNov.Cells(i, "F").Value * vlookupResult
        Else
            
            
            wsNov.Cells(i, "P").Value = wsNov.Cells(i, "O").Value
            wsNov.Cells(i, "Q").Value = wsNov.Cells(i, "F").Value * wsNov.Cells(i, "O").Value
        End If
    Next i
    
    
    For Each ptName In pivotTableNames
        On Error Resume Next
        Set pt = wsPivot.PivotTables(ptName)
        On Error GoTo 0
        
        If Not pt Is Nothing Then
            ' 피벗 테이블 업데이트 (최신 데이터 반영)
            pt.RefreshTable
            
            ' 이미 "Sum of estimate_price"가 값 필드에 추가되어 있으면 삭제
            On Error Resume Next
            Set DataField = pt.DataFields("Sum of estimate_price")
            If Not DataField Is Nothing Then
                DataField.Orientation = xlHidden  ' 기존 필드 숨기기
            End If
            On Error GoTo 0
            
            ' "estimate_price" 필드를 값 필드로 다시 추가
            On Error Resume Next  ' 필드가 이미 추가된 경우 오류 무시
            Set pf = pt.PivotFields("estimate_price")
            pt.AddDataField pf, "Sum of estimate_price", xlSum
            On Error GoTo 0
        End If
    Next ptName

    
    
    
    

    ' 차트 새로 고침 및 수정
    For Each chartObj In wsDashboard.ChartObjects
        ' 차트 이름 출력
        ' MsgBox "차트 이름: " & chartObj.Name  // 차트는 정상적으로 출력하고 있음
        
        On Error Resume Next
        
        
        '   디버그
        
        
        chartObj.Chart.Refresh ' 차트 새로 고침

        ' 범례 제거
        If Not chartObj.Chart.Legend Is Nothing Then
            chartObj.Chart.Legend.Delete
        End If

        ' 데이터 레이블 추가
        chartObj.Chart.ApplyDataLabels

        ' 색상 변경 및 범례 추가를 위한 Dictionary 초기화
        Dim legendItems As Object
        Set legendItems = CreateObject("Scripting.Dictionary")

        Dim srs As Series
        For Each srs In chartObj.Chart.SeriesCollection
            For j = 1 To srs.Points.Count
                Dim categoryName As String
                categoryName = srs.XValues(j)

                ' 차트1과 차트2의 경우
                If chartObj.Name = "차트1" Or chartObj.Name = "chart2" Then
                    If categoryName = "모든팩" Then
                        srs.Points(j).Format.Fill.ForeColor.RGB = RGB(255, 215, 0) ' 황금색
                        If Not legendItems.Exists("모든팩") Then
                            legendItems.Add "모든팩", ""
                        End If
                    ElseIf categoryName = "엠에스팩" Then
                        srs.Points(j).Format.Fill.ForeColor.RGB = RGB(0, 176, 80) ' 녹색
                        If Not legendItems.Exists("엠에스팩") Then
                            legendItems.Add "엠에스팩", ""
                        End If
                    End If

            ' 차트3과 차트4의 경우
                ElseIf chartObj.Name = "chart3" Or chartObj.Name = "chart4" Then
                    Dim firstPart As String
                    firstPart = Split(categoryName, " ")(0)

                    If firstPart = "모든팩" Then
                        Debug.Print "모든팩 색상 변경"
                        srs.Points(j).Format.Fill.ForeColor.RGB = RGB(255, 215, 0) ' 황금색
                        If Not legendItems.Exists("모든팩") Then
                            Debug.Print "모든팩 추가"
                            legendItems.Add "모든팩", ""
                        End If
                    ElseIf firstPart = "엠에스팩" Then
                        srs.Points(j).Format.Fill.ForeColor.RGB = RGB(0, 176, 80) ' 녹색
                        If Not legendItems.Exists("엠에스팩") Then
                            legendItems.Add "엠에스팩", ""
                        End If
                    ElseIf firstPart = "진포장" Then
                        ' 다른 색상 추가 가능
                        If Not legendItems.Exists("진포장") Then
                            legendItems.Add "진포장", ""
                        End If
                    End If
                End If
            Next j
        Next srs
    ' 범례 제거
        ' Debug.Print legendItems
         ' Debug.Print chartObj.Chart.Legend
        If Not chartObj.Chart.Legend Is Nothing Then
            chartObj.Chart.Legend.Delete
        End If
    ' 범례 추가
        Dim legendKey As Variant
        For Each legendKey In legendItems.Keys
            Debug.Print "범례 항목: " & legendKey
        Next legendKey
    
    
    
    
        Dim legendItem As Variant
        For Each legendItem In legendItems.Keys
            
            chartObj.Chart.Legend.AddLegendEntry legendItem
        Next legendItem

        
    Next chartObj

    MsgBox "데이터 업데이트가 완료되었습니다."
End Sub





