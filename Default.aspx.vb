Public Class _Default
    Inherits Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Mở ứng dụng là vào thẳng phiếu khảo sát
        Response.Redirect("~/KhaoSat.aspx")
    End Sub
End Class