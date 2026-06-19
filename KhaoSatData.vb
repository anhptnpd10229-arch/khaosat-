Imports System.Collections.Generic
Imports System.Configuration
Imports System.Data.SqlClient
Imports System.Web

''' <summary>
''' Nguồn dữ liệu chuẩn (single source of truth) cho phiếu khảo sát chất lượng dịch vụ.
''' Danh sách tiêu chí đọc từ bảng dbo.KS_TieuChi (quản lý qua trang quản trị).
''' Thang điểm cố định. Dùng chung cho trang nhập liệu và trang kết quả.
''' </summary>
Public NotInheritable Class KhaoSatData

    Private Sub New()
    End Sub

#Region "01. Lớp dữ liệu"

    ''' <summary>Một tiêu chí đánh giá.</summary>
    Public Class TieuChi
        Public Property Ma As String          ' Ví dụ: "1.1", "5.7"
        Public Property NoiDung As String
        Public Sub New(ma As String, noiDung As String)
            Me.Ma = ma
            Me.NoiDung = noiDung
        End Sub
    End Class

    ''' <summary>Một nhóm tiêu chí.</summary>
    Public Class Nhom
        Public Property SoLaMa As String      ' "I", "II", ...
        Public Property Ten As String
        Public Property DanhSach As List(Of TieuChi)
        Public Sub New(soLaMa As String, ten As String)
            Me.SoLaMa = soLaMa
            Me.Ten = ten
            Me.DanhSach = New List(Of TieuChi)()
        End Sub
    End Class

#End Region

#Region "02. Thang điểm"

    ''' <summary>Nhãn 4 mức điểm (index 1..4).</summary>
    Public Shared ReadOnly Property MucDiem As String() =
        {"", "Rất hài lòng", "Hài lòng", "Có thể chấp nhận được", "Không hài lòng"}

    ''' <summary>Trả về nhãn mức điểm theo điểm 1..4.</summary>
    Public Shared Function TenMucDiem(diem As Integer) As String
        If diem >= 1 AndAlso diem <= 4 Then Return MucDiem(diem)
        Return ""
    End Function

    Public Shared ReadOnly Property MucHaiLongChung As String() =
        {"Rất hài lòng", "Hài lòng", "Bình thường", "Không hài lòng"}

    Public Shared ReadOnly Property KhaNangTiepTuc As String() =
        {"Có", "Cân nhắc", "Không"}

#End Region

#Region "03. Cấu trúc nhóm/tiêu chí"

    Private Const CacheKey As String = "KS_NhomCache"

    ''' <summary>
    ''' Trả về 1 nhóm "II. Đánh giá chi tiết" chứa các tiêu chí đang bật (IsActive=1)
    ''' trong bảng dbo.KS_TieuChi, sắp theo ThuTu. Cache theo từng request để tránh
    ''' đọc DB nhiều lần; mỗi request mới sẽ lấy dữ liệu mới nhất (tiêu chí vừa thêm).
    ''' </summary>
    Public Shared Function GetNhom() As List(Of Nhom)
        ' Cache trong phạm vi 1 request
        Dim ctx As HttpContext = HttpContext.Current
        If ctx IsNot Nothing AndAlso TypeOf ctx.Items(CacheKey) Is List(Of Nhom) Then
            Return DirectCast(ctx.Items(CacheKey), List(Of Nhom))
        End If

        Dim ds As New List(Of Nhom)()
        Dim n1 As New Nhom("II", "Đánh giá chi tiết")

        Try
            Dim cs As String = ConfigurationManager.ConnectionStrings("KhaoSatDb").ConnectionString
            Using conn As New SqlConnection(cs)
                conn.Open()
                Using cmd As New SqlCommand(
                    "SELECT Ma, TenTieuChi FROM dbo.KS_TieuChi WHERE IsActive = 1 ORDER BY ThuTu, Id", conn)
                    Using rd As SqlDataReader = cmd.ExecuteReader()
                        While rd.Read()
                            n1.DanhSach.Add(New TieuChi(rd("Ma").ToString(), rd("TenTieuChi").ToString()))
                        End While
                    End Using
                End Using
            End Using
        Catch
            ' DB lỗi → dùng danh sách mặc định bên dưới để form luôn hoạt động
        End Try

        ' Phương án dự phòng: nếu không lấy được tiêu chí nào (DB lỗi hoặc bảng rỗng)
        If n1.DanhSach.Count = 0 Then
            n1.DanhSach.Add(New TieuChi("1", "Kế hoạch, điều độ cầu bến"))
            n1.DanhSach.Add(New TieuChi("2", "An ninh - an toàn"))
            n1.DanhSach.Add(New TieuChi("3", "Công tác khai thác"))
            n1.DanhSach.Add(New TieuChi("4", "Thương vụ"))
        End If

        ds.Add(n1)

        If ctx IsNot Nothing Then ctx.Items(CacheKey) = ds
        Return ds
    End Function

    ''' <summary>Tổng số tiêu chí đang bật.</summary>
    Public Shared Function TongTieuChi() As Integer
        Dim t As Integer = 0
        For Each n As Nhom In GetNhom()
            t += n.DanhSach.Count
        Next
        Return t
    End Function

    ''' <summary>Tra cứu nội dung tiêu chí theo mã.</summary>
    Public Shared Function NoiDungTheoMa(ma As String) As String
        For Each n As Nhom In GetNhom()
            For Each tc As TieuChi In n.DanhSach
                If tc.Ma = ma Then Return tc.NoiDung
            Next
        Next
        Return ""
    End Function

#End Region

End Class
