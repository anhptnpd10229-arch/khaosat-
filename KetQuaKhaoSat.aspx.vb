Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports System.Text
Imports Newtonsoft.Json

Public Class KetQuaKhaoSat
    Inherits Page

    Private ReadOnly Property Cs As String
        Get
            Return ConfigurationManager.ConnectionStrings("KhaoSatDb").ConnectionString
        End Get
    End Property

#Region "01. Page Load"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            LoadData()
        End If
    End Sub

#End Region

#Region "02. Load dữ liệu"

    Private Sub LoadData()
        Dim dtPhieu As New DataTable()
        Dim dtChiTiet As New DataTable()

        Using conn As New SqlConnection(Cs)
            conn.Open()
            Using da As New SqlDataAdapter("SELECT * FROM dbo.KS_Phieu ORDER BY NgayGui DESC", conn)
                da.Fill(dtPhieu)
            End Using
            Using da As New SqlDataAdapter("SELECT PhieuId, MaTieuChi, NoiDung, Diem, DienGiai FROM dbo.KS_ChiTiet ORDER BY PhieuId, Id", conn)
                da.Fill(dtChiTiet)
            End Using
        End Using

        ' --- Bảng + trạng thái rỗng ---
        Dim tong As Integer = dtPhieu.Rows.Count
        pnlEmpty.Visible = (tong = 0)
        pnlTable.Visible = (tong > 0)

        rptPhieu.DataSource = dtPhieu
        rptPhieu.DataBind()

        ' --- Thống kê ---
        litTong.Text = tong.ToString()
        TinhThongKe(dtChiTiet, dtPhieu, tong)

        ' --- JSON chi tiết cho modal ---
        litJson.Text = BuildJson(dtPhieu, dtChiTiet)
    End Sub

    Private Sub TinhThongKe(dtChiTiet As DataTable, dtPhieu As DataTable, tong As Integer)
        Dim tongDiem As Double = 0
        Dim soDiem As Integer = 0
        Dim soHaiLong As Integer = 0   ' điểm 1-2

        For Each r As DataRow In dtChiTiet.Rows
            If Not IsDBNull(r("Diem")) Then
                Dim d As Integer = Convert.ToInt32(r("Diem"))
                tongDiem += d
                soDiem += 1
                If d <= 2 Then soHaiLong += 1
            End If
        Next

        If soDiem > 0 Then
            litDiemTB.Text = (tongDiem / soDiem).ToString("0.00")
            litPctHaiLong.Text = Math.Round(soHaiLong * 100.0 / soDiem).ToString() & "%"
        Else
            litDiemTB.Text = "—"
            litPctHaiLong.Text = "—"
        End If

        If tong > 0 Then
            Dim soTiepTuc As Integer = 0
            For Each r As DataRow In dtPhieu.Rows
                If Not IsDBNull(r("TiepTucSuDung")) AndAlso r("TiepTucSuDung").ToString() = "Có" Then
                    soTiepTuc += 1
                End If
            Next
            litPctTiepTuc.Text = Math.Round(soTiepTuc * 100.0 / tong).ToString() & "%"
        Else
            litPctTiepTuc.Text = "—"
        End If
    End Sub

    ''' <summary>Tạo JSON { id: { header..., Details:[...] } } cho modal chi tiết.</summary>
    Private Function BuildJson(dtPhieu As DataTable, dtChiTiet As DataTable) As String
        Dim root As New Dictionary(Of String, Object)()

        For Each p As DataRow In dtPhieu.Rows
            Dim id As Integer = Convert.ToInt32(p("Id"))
            Dim item As New Dictionary(Of String, Object) From {
                {"HoTen", NzStr(p("HoTen"))},
                {"ChucVu", NzStr(p("ChucVu"))},
                {"CongTy", NzStr(p("CongTy"))},
                {"LienHe", NzStr(p("LienHe"))},
                {"DichVu", NzStr(p("DichVu"))},
                {"TenTau", NzStr(p("TenTau"))},
                {"LoaiHangHoa", NzStr(p("LoaiHangHoa"))},
                {"ThoiGian", NzStr(p("ThoiGian"))},
                {"HaiLongChung", NzStr(p("HaiLongChung"))},
                {"TiepTucSuDung", NzStr(p("TiepTucSuDung"))},
                {"DeXuat", NzStr(p("DeXuat"))}
            }

            Dim details As New List(Of Object)()
            For Each d As DataRow In dtChiTiet.Rows
                If Convert.ToInt32(d("PhieuId")) = id Then
                    details.Add(New Dictionary(Of String, Object) From {
                        {"MaTieuChi", NzStr(d("MaTieuChi"))},
                        {"NoiDung", NzStr(d("NoiDung"))},
                        {"Diem", If(IsDBNull(d("Diem")), Nothing, Convert.ToInt32(d("Diem")))},
                        {"DienGiai", NzStr(d("DienGiai"))}
                    })
                End If
            Next
            item("Details") = details
            root(id.ToString()) = item
        Next

        ' Tránh phá vỡ thẻ </script> nếu dữ liệu chứa chuỗi đó
        Return JsonConvert.SerializeObject(root).Replace("</", "<\/")
    End Function

#End Region

#Region "06. Xử lý xuất Excel"

    Protected Sub btnExcel_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim dtPhieu As New DataTable()
        Using conn As New SqlConnection(Cs)
            conn.Open()
            Using da As New SqlDataAdapter(
                "SELECT NgayGui, HoTen, ChucVu, CongTy, LienHe, DichVu, TenTau, LoaiHangHoa, ThoiGian, HaiLongChung, TiepTucSuDung, DeXuat " &
                "FROM dbo.KS_Phieu ORDER BY NgayGui DESC", conn)
                da.Fill(dtPhieu)
            End Using
        End Using

        Dim sb As New StringBuilder()
        sb.Append("<meta http-equiv=""content-type"" content=""application/vnd.ms-excel; charset=UTF-8"">")
        sb.Append("<table border='1'><tr style='background:#484848;color:#fff;font-weight:bold;'>")
        Dim headers As String() = {"Ngày gửi", "Họ tên", "Chức vụ", "Công ty", "SĐT/Email", "Dịch vụ", "Tên tàu", "Loại hàng", "Thời gian", "Hài lòng chung", "Tiếp tục SD", "Đề xuất"}
        For Each h As String In headers
            sb.AppendFormat("<th>{0}</th>", Server.HtmlEncode(h))
        Next
        sb.Append("</tr>")

        For Each r As DataRow In dtPhieu.Rows
            sb.Append("<tr>")
            Dim ngay As String = If(IsDBNull(r("NgayGui")), "", Convert.ToDateTime(r("NgayGui")).ToString("dd/MM/yyyy HH:mm"))
            sb.AppendFormat("<td>{0}</td>", ngay)
            For Each col As String In {"HoTen", "ChucVu", "CongTy", "LienHe", "DichVu", "TenTau", "LoaiHangHoa", "ThoiGian", "HaiLongChung", "TiepTucSuDung", "DeXuat"}
                sb.AppendFormat("<td>{0}</td>", Server.HtmlEncode(NzStr(r(col))))
            Next
            sb.Append("</tr>")
        Next
        sb.Append("</table>")

        Dim fileName As String = "KetQuaKhaoSat_" & DateTime.Now.ToString("yyyyMMdd_HHmm") & ".xls"
        Response.Clear()
        Response.Buffer = True
        Response.Charset = "UTF-8"
        Response.ContentEncoding = Encoding.UTF8
        Response.ContentType = "application/vnd.ms-excel"
        Response.AddHeader("content-disposition", "attachment;filename=" & fileName)
        Response.Write(sb.ToString())
        Response.Flush()
        Response.End()
    End Sub

#End Region

#Region "07. Hàm tiện ích"

    ''' <summary>Trả về chuỗi an toàn từ object DB (DBNull -> "").</summary>
    Protected Function NzStr(value As Object) As String
        If value Is Nothing OrElse value Is DBNull.Value Then Return ""
        Return value.ToString()
    End Function

    ''' <summary>Lớp badge theo mức hài lòng chung.</summary>
    Protected Function BadgeClass(text As String) As String
        Select Case text
            Case "Rất hài lòng" : Return "m1"
            Case "Hài lòng" : Return "m2"
            Case "Bình thường" : Return "m3"
            Case "Không hài lòng" : Return "m4"
            Case Else : Return ""
        End Select
    End Function

#End Region

End Class
