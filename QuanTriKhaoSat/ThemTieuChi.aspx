<%@ Page Title="Quản lý tiêu chí" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="ThemTieuChi.aspx.vb" Inherits="KHAOSAT.ThemTieuChi" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/rla-survey.css") %>' />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />

    <div class="rla-wrap" style="max-width:900px;padding-bottom:40px;">

        <%-- ===== Hero ===== --%>
        <section class="rla-hero">
            <div class="rla-kicker" style="color:#fed7aa;font-weight:800;">⚙️ QUẢN TRỊ KHẢO SÁT</div>
            <h1 class="rla-title">Quản lý tiêu chí đánh giá</h1>
            <div class="rla-subtitle">Thêm mới, ẩn/hiện hoặc xóa các tiêu chí hiển thị trên phiếu khảo sát.</div>
        </section>

        <%-- ===== Thêm tiêu chí ===== --%>
        <div class="rla-card">
            <div class="rla-card__head">
                <span class="rla-card__num">➕</span>
                <div>
                    <h2 class="rla-card__title">Thêm tiêu chí mới</h2>
                    <p class="rla-card__desc">Tiêu chí mới sẽ xuất hiện ngay trên phiếu khảo sát sau khi lưu.</p>
                </div>
            </div>
            <div class="rla-add-form">
                <div class="rla-field rla-add-form__ten">
                    <label class="rla-label">Tên tiêu chí <span class="req">*</span></label>
                    <asp:TextBox runat="server" ID="txtTen" CssClass="rla-input" ClientIDMode="Static"
                        placeholder="VD: Dịch vụ hỗ trợ khách hàng" MaxLength="200" />
                </div>
                <div class="rla-field rla-add-form__btn">
                    <asp:Button runat="server" ID="btnLuu" CssClass="rla-btn rla-btn-primary"
                        Text="➕ Thêm tiêu chí" OnClick="btnLuu_Click"
                        OnClientClick="return confirmAdd(this);" />
                </div>
            </div>
        </div>

        <%-- ===== Danh sách tiêu chí ===== --%>
        <div class="rla-card">
            <div class="rla-card__head">
                <span class="rla-card__num">📋</span>
                <h2 class="rla-card__title">Danh sách tiêu chí</h2>
            </div>
            <div style="overflow-x:auto;">
                <table class="rla-table mobile-card-list" style="width:100%;">
                    <thead>
                        <tr>
                            <th style="width:60px;">Mã</th>
                            <th>Tên tiêu chí</th>
                            <th style="width:85px;">Trạng thái</th>
                            <th style="width:160px;" data-orderable="false">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <asp:Repeater runat="server" ID="rptTieuChi">
                            <ItemTemplate>
                                <tr>
                                    <td data-label="Mã"><b><%# Server.HtmlEncode(NzStr(Eval("Ma"))) %></b></td>
                                    <td data-label="Tên tiêu chí" style="text-align:left;"><%# Server.HtmlEncode(NzStr(Eval("TenTieuChi"))) %></td>
                                    <td data-label="Trạng thái">
                                        <span class="rla-badge <%# If(Convert.ToBoolean(Eval("IsActive")), "m1", "m4") %>">
                                            <%# If(Convert.ToBoolean(Eval("IsActive")), "Hiện", "Ẩn") %>
                                        </span>
                                    </td>
                                    <td data-label="Thao tác">
                                        <asp:LinkButton runat="server" CssClass="rla-icon-btn" CommandName="toggle"
                                            CommandArgument='<%# Eval("Id") %>' OnCommand="TieuChi_Command"
                                            Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "🚫 Ẩn", "✅ Hiện") %>'
                                            OnClientClick="return confirmToggle(this);" />
                                        <asp:LinkButton runat="server" CssClass="rla-icon-btn rla-icon-btn--danger" CommandName="delete"
                                            CommandArgument='<%# Eval("Id") %>' OnCommand="TieuChi_Command"
                                            Text="🗑️ Xóa" OnClientClick="return confirmDelete(this);" />
                                    </td>
                                </tr>
                            </ItemTemplate>
                        </asp:Repeater>
                    </tbody>
                </table>
            </div>
        </div>

        <div class="bottom-nav">
            <button type="button" class="btn" onclick="history.back();">🔙 Quay lại</button>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <script type="text/javascript">
        var _addOk = false, _toggleOk = false, _deleteOk = false;

        function confirmAdd(btn) {
            if (_addOk) { _addOk = false; return true; }
            var ten = (document.getElementById('txtTen') || {}).value || '';
            ten = ten.trim();
            if (!ten) {
                Swal.fire({ icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng nhập tên tiêu chí.', confirmButtonColor: '#EB8023' });
                return false;
            }
            Swal.fire({
                icon: 'question', title: 'Xác nhận thêm tiêu chí?',
                html: 'Tên: <b>' + ten + '</b>',
                showCancelButton: true,
                confirmButtonText: '➕ Thêm', cancelButtonText: 'Hủy',
                confirmButtonColor: '#EB8023', cancelButtonColor: '#9ca3af'
            }).then(function (r) {
                if (r.isConfirmed) { _addOk = true; btn.click(); }
            });
            return false;
        }

        function confirmToggle(el) {
            if (_toggleOk) { _toggleOk = false; return true; }
            var action = el.innerText.trim();
            Swal.fire({
                icon: 'question', title: 'Xác nhận thay đổi trạng thái?',
                text: 'Thao tác: ' + action,
                showCancelButton: true,
                confirmButtonText: 'Xác nhận', cancelButtonText: 'Hủy',
                confirmButtonColor: '#EB8023', cancelButtonColor: '#9ca3af'
            }).then(function (r) {
                if (r.isConfirmed) { _toggleOk = true; el.click(); }
            });
            return false;
        }

        function confirmDelete(el) {
            if (_deleteOk) { _deleteOk = false; return true; }
            Swal.fire({
                icon: 'warning', title: 'Xóa tiêu chí?',
                text: 'Tiêu chí sẽ bị gỡ vĩnh viễn. Các phiếu đã gửi không bị ảnh hưởng.',
                showCancelButton: true,
                confirmButtonText: '🗑️ Xóa', cancelButtonText: 'Hủy',
                confirmButtonColor: '#dc2626', cancelButtonColor: '#9ca3af'
            }).then(function (r) {
                if (r.isConfirmed) { _deleteOk = true; el.click(); }
            });
            return false;
        }
    </script>

</asp:Content>
