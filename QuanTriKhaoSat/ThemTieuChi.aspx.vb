Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient
Imports Newtonsoft.Json

Public Class ThemTieuChi
    Inherits Page

    Private ReadOnly Property Cs As String
        Get
            Return ConfigurationManager.ConnectionStrings("KhaoSatDb").ConnectionString
        End Get
    End Property

#Region "01. Page Load"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then LoadTieuChi()
    End Sub

#End Region

#Region "02. Load dữ liệu"

    Private Sub LoadTieuChi()
        Dim dt As New DataTable()
        Using conn As New SqlConnection(Cs)
            conn.Open()
            Using da As New SqlDataAdapter(
                "SELECT Id, Ma, TenTieuChi, ThuTu, IsActive FROM dbo.KS_TieuChi ORDER BY ThuTu, Id", conn)
                da.Fill(dt)
            End Using
        End Using
        rptTieuChi.DataSource = dt
        rptTieuChi.DataBind()
    End Sub

#End Region

#Region "03. Thêm tiêu chí"

    Protected Sub btnLuu_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim ten As String = txtTen.Text.Trim()
        If ten = "" Then Return

        Dim thuTu As Integer
        Dim ma As String

        Using conn As New SqlConnection(Cs)
            conn.Open()

            Using cmd As New SqlCommand(
                "SELECT ISNULL(MAX(TRY_CONVERT(INT, Ma)), 0) + 1 FROM dbo.KS_TieuChi", conn)
                ma = Convert.ToInt32(cmd.ExecuteScalar()).ToString()
            End Using

            Using cmd As New SqlCommand(
                "SELECT ISNULL(MAX(ThuTu), 0) + 1 FROM dbo.KS_TieuChi", conn)
                thuTu = Convert.ToInt32(cmd.ExecuteScalar())
            End Using

            Using cmd As New SqlCommand(
                "INSERT INTO dbo.KS_TieuChi (Ma, TenTieuChi, ThuTu, IsActive) VALUES (@Ma, @Ten, @ThuTu, 1)", conn)
                cmd.Parameters.AddWithValue("@Ma", ma)
                cmd.Parameters.AddWithValue("@Ten", ten)
                cmd.Parameters.AddWithValue("@ThuTu", thuTu)
                cmd.ExecuteNonQuery()
            End Using
        End Using

        txtTen.Text = ""
        LoadTieuChi()
        ShowToast("Đã thêm tiêu chí '" & ten & "'.", "success")
    End Sub

#End Region

#Region "04. Ẩn/Hiện · Xóa tiêu chí"

    Protected Sub TieuChi_Command(ByVal sender As Object, ByVal e As CommandEventArgs)
        Dim id As Integer
        If Not Integer.TryParse(Convert.ToString(e.CommandArgument), id) Then Return

        Using conn As New SqlConnection(Cs)
            conn.Open()
            Select Case e.CommandName
                Case "toggle"
                    Using cmd As New SqlCommand(
                        "UPDATE dbo.KS_TieuChi SET IsActive = 1 - IsActive WHERE Id = @Id", conn)
                        cmd.Parameters.AddWithValue("@Id", id)
                        cmd.ExecuteNonQuery()
                    End Using
                    ShowToast("Đã cập nhật trạng thái tiêu chí.", "success")
                Case "delete"
                    Using cmd As New SqlCommand(
                        "DELETE FROM dbo.KS_TieuChi WHERE Id = @Id", conn)
                        cmd.Parameters.AddWithValue("@Id", id)
                        cmd.ExecuteNonQuery()
                    End Using
                    ShowToast("Đã xóa tiêu chí.", "success")
            End Select
        End Using

        LoadTieuChi()
    End Sub

#End Region

#Region "07. Hàm tiện ích"

    Protected Function NzStr(value As Object) As String
        If value Is Nothing OrElse value Is DBNull.Value Then Return ""
        Return value.ToString()
    End Function

    Private Sub ShowToast(text As String, type As String)
        Dim color As String
        Select Case type
            Case "error" : color = "#dc2626"
            Case "warning" : color = "#f59e0b"
            Case Else : color = "#16a34a"
        End Select
        Dim js As String =
            "Toastify({text:" & JsonConvert.SerializeObject(text) &
            ",duration:3500,gravity:'top',position:'right',stopOnFocus:true," &
            "style:{background:'" & color & "',borderRadius:'10px',fontWeight:'600'}}).showToast();"
        ClientScript.RegisterStartupScript(Me.GetType(), "toast_" & Guid.NewGuid().ToString("N"), js, True)
    End Sub

#End Region

End Class
