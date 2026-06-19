Imports System.Configuration
Imports System.Data
Imports System.Data.SqlClient

Public Class KhaoSat
    Inherits Page

#Region "01. Page Load"

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            BindTieuChi()
        End If
    End Sub

#End Region

#Region "02. Load dữ liệu"

    Private Sub BindTieuChi()
        rptNhom.DataSource = KhaoSatData.GetNhom()
        rptNhom.DataBind()
    End Sub

#End Region

#Region "03. Xử lý thêm mới (lưu phiếu)"

    Protected Sub btnGui_Click(ByVal sender As Object, ByVal e As EventArgs)
        Dim cs As String = ConfigurationManager.ConnectionStrings("KhaoSatDb").ConnectionString

        Using conn As New SqlConnection(cs)
            conn.Open()
            Using tran As SqlTransaction = conn.BeginTransaction()
                Try
                    ' --- Insert header, lấy Id ---
                    Dim phieuId As Integer
                    Using cmd As New SqlCommand(
                        "INSERT INTO dbo.KS_Phieu (HoTen, ChucVu, CongTy, LienHe, DichVu, TenTau, LoaiHangHoa, ThoiGian, HaiLongChung, TiepTucSuDung, DeXuat, IPClient) " &
                        "VALUES (@HoTen,@ChucVu,@CongTy,@LienHe,@DichVu,@TenTau,@LoaiHangHoa,@ThoiGian,@HaiLongChung,@TiepTucSuDung,@DeXuat,@IPClient); " &
                        "SELECT CAST(SCOPE_IDENTITY() AS INT);", conn, tran)

                        cmd.Parameters.AddWithValue("@HoTen", Nz(txtHoTen.Text))
                        cmd.Parameters.AddWithValue("@ChucVu", Nz(txtChucVu.Text))
                        cmd.Parameters.AddWithValue("@CongTy", Nz(txtCongTy.Text))
                        cmd.Parameters.AddWithValue("@LienHe", Nz(txtLienHe.Text))
                        cmd.Parameters.AddWithValue("@DichVu", Nz(txtDichVu.Text))
                        cmd.Parameters.AddWithValue("@TenTau", Nz(txtTenTau.Text))
                        cmd.Parameters.AddWithValue("@LoaiHangHoa", Nz(txtLoaiHang.Text))
                        cmd.Parameters.AddWithValue("@ThoiGian", Nz(txtThoiGian.Text))
                        cmd.Parameters.AddWithValue("@HaiLongChung", Nz(Request.Form("hailong")))
                        cmd.Parameters.AddWithValue("@TiepTucSuDung", Nz(Request.Form("tieptuc")))
                        cmd.Parameters.AddWithValue("@DeXuat", Nz(Request.Form("dexuat")))
                        cmd.Parameters.AddWithValue("@IPClient", Nz(Request.UserHostAddress))

                        phieuId = CInt(cmd.ExecuteScalar())
                    End Using

                    ' --- Insert chi tiết 4 tiêu chí ---
                    For Each nhom As KhaoSatData.Nhom In KhaoSatData.GetNhom()
                        For Each tc As KhaoSatData.TieuChi In nhom.DanhSach
                            Dim key As String = tc.Ma.Replace(".", "_")
                            Dim diemRaw As String = Request.Form("diem_" & key)
                            Dim dienGiai As Object = Nz(Request.Form("dg_" & key))

                            Dim diem As Object = DBNull.Value
                            Dim d As Integer
                            If Integer.TryParse(diemRaw, d) AndAlso d >= 1 AndAlso d <= 4 Then
                                diem = d
                            End If

                            Using cmdDt As New SqlCommand(
                                "INSERT INTO dbo.KS_ChiTiet (PhieuId, MaTieuChi, Nhom, NoiDung, Diem, DienGiai) " &
                                "VALUES (@PhieuId,@Ma,@Nhom,@NoiDung,@Diem,@DienGiai);", conn, tran)

                                cmdDt.Parameters.AddWithValue("@PhieuId", phieuId)
                                cmdDt.Parameters.AddWithValue("@Ma", tc.Ma)
                                cmdDt.Parameters.AddWithValue("@Nhom", nhom.SoLaMa & ". " & nhom.Ten)
                                cmdDt.Parameters.AddWithValue("@NoiDung", tc.NoiDung)
                                cmdDt.Parameters.AddWithValue("@Diem", diem)
                                cmdDt.Parameters.AddWithValue("@DienGiai", dienGiai)
                                cmdDt.ExecuteNonQuery()
                            End Using
                        Next
                    Next

                    tran.Commit()
                    Response.Redirect("~/CamOn.aspx", False)
                    Context.ApplicationInstance.CompleteRequest()

                Catch ex As Exception
                    tran.Rollback()
                    Try
                        System.IO.File.WriteAllText(Server.MapPath("~/App_Data/ks_error.log"), ex.ToString())
                    Catch
                    End Try
                    ScriptManager.RegisterStartupScript(Me, Me.GetType(), "err",
                        "Swal.fire({icon:'error',title:'Lỗi',text:'Không thể lưu phiếu. Vui lòng thử lại.',confirmButtonColor:'#EB8023'});", True)
                End Try
            End Using
        End Using
    End Sub

#End Region

#Region "07. Hàm tiện ích"

    ''' <summary>Chuẩn hóa chuỗi: trả về DBNull nếu rỗng, ngược lại trả chuỗi đã Trim.</summary>
    Private Function Nz(value As String) As Object
        If String.IsNullOrWhiteSpace(value) Then Return DBNull.Value
        Return value.Trim()
    End Function

#End Region

End Class
