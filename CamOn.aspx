<%@ Page Title="Cảm ơn Quý khách" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CamOn.aspx.vb" Inherits="KHAOSAT.CamOn" %>

<asp:Content ID="CamOnContent" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/rla-survey.css") %>' />

    <div class="rla-wrap" style="padding-bottom:40px;">
        <div class="rla-card" style="margin-top:24px;">
            <div class="rla-thanks">
                <div class="rla-thanks__check">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M20 6L9 17l-5-5" stroke="#fff" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" />
                    </svg>
                </div>
                <h2>Cảm ơn Quý khách!</h2>
                <p>Phiếu khảo sát của Quý khách đã được ghi nhận thành công. Ý kiến đóng góp của Quý khách là động lực để chúng tôi không ngừng nâng cao chất lượng dịch vụ.</p>
                <div style="margin-top:18px;display:flex;gap:10px;justify-content:center;flex-wrap:wrap;">
                    <a href='<%= ResolveUrl("~/KhaoSat.aspx") %>' class="rla-btn rla-btn-primary" style="flex:0 0 auto;">📝 Gửi phiếu khác</a>
                </div>
            </div>
        </div>
    </div>

</asp:Content>
