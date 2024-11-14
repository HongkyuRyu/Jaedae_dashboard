Sub 검증()
    Dim wsSep As Worksheet
    Dim wsPivot AS Worksheet
    Dim wsQuery As Worksheet


    ' 시트 설정
    Set wsSep = ThisWorkbook.Sheets("9월제대전체_둘다반영")
    Set wsPivot = ThisWorkbook.Sheets("9월피벗")
    Set wsQuery = ThisWorkbook.Sheets("9월쿼리")


    ' 피벗 테이블 이름 배열
    Dim pivotTableNames As Variant
    pivotTableNames = Array("피벗 테이블1", "피벗 테이블2", "피벗 테이블3")


    ' VLOOKUP을 통해, 단가 가져오기.
    lastRow = wsSep.Cells(wsSep.Rows.Count, "H").End(xlUp).Row

    Set reference_look_up = ThisWorkbook.Sheets("reference").Range("$B:$C")
    Set query_look_up = wsQuery.Range("$A:$P")
    For i = 2 To lastRow
        vlookupResult = Application.VLookup(wsSep.Cells(i, "G"), reference_look_up, 2, False)
        If Not IsError(vlookupResult) Then
            wsSep.Cells(i, "I").Value = vlookupResult
        Else
            queryResult = Application.VLookup(wsSep.Cells(i, "A"), query_look_up, 16, False)
        End If
    Next i

    On Error Resume Next

    ' 피벗 테이블 업데이트
    For Each ptName In pivotTableNames
        On Error Resume Next
        Set pt = wsPivot.PivotTables(ptName)
        On Error GoTo 0
        pt.RefreshTable
    Next ptName
    MsgBox("단가 반영이 완료되었습니다.")
End Sub