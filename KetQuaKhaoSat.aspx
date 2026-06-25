<%@ Page Title="Kết quả khảo sát" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" MaintainScrollPositionOnPostback="true" CodeBehind="KetQuaKhaoSat.aspx.vb" Inherits="KHAOSAT.KetQuaKhaoSat" %>

<asp:Content ID="KetQuaContent" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/rla-survey.css") %>' />
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/jquery.dataTables.min.css" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />

    <div class="rla-wrap" style="max-width:1100px;padding-bottom:40px;">

        <%-- ===== Hero ===== --%>
        <section class="rla-hero">
            <div class="rla-kicker">📊 Quản trị khảo sát</div>
            <h1 class="rla-title">Kết quả khảo sát chất lượng dịch vụ</h1>
            <div class="rla-subtitle">Tổng hợp các phiếu khảo sát đã thu thập. Nhấn "Chi tiết" để xem điểm từng tiêu chí.</div>
        </section>

        <%-- ===== Dashboard cards ===== --%>
        <div class="rla-cards">
            <div class="rla-stat">
                <div class="rla-stat__label">Tổng số phiếu</div>
                <div class="rla-stat__value brand"><asp:Literal runat="server" ID="litTong" Text="0" /></div>
            </div>
            <div class="rla-stat">
                <div class="rla-stat__label">Điểm TB (1 tốt → 4 kém)</div>
                <div class="rla-stat__value"><asp:Literal runat="server" ID="litDiemTB" Text="—" /></div>
            </div>
            <div class="rla-stat">
                <div class="rla-stat__label">% Hài lòng (mức 1–2)</div>
                <div class="rla-stat__value"><asp:Literal runat="server" ID="litPctHaiLong" Text="—" /></div>
            </div>
            <div class="rla-stat">
                <div class="rla-stat__label">% Sẽ tiếp tục dùng</div>
                <div class="rla-stat__value"><asp:Literal runat="server" ID="litPctTiepTuc" Text="—" /></div>
            </div>
        </div>

        <%-- ===== Bảng phiếu ===== --%>
        <div class="rla-card">
            <div style="display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:10px;">
                <h2 class="rla-card__title" style="margin:0;">Danh sách phiếu</h2>
                <div style="display:flex;gap:8px;flex-wrap:wrap;">
                    <asp:LinkButton runat="server" ID="btnExcel" CssClass="rla-icon-btn" OnClick="btnExcel_Click">
                        <span>⬇️</span> Xuất Excel
                    </asp:LinkButton>
                    <a href='<%= ResolveUrl("~/MaQR") %>' class="rla-icon-btn">📱 Mã QR</a>
                    <a href='<%= ResolveUrl("~/QuanTriKhaoSat/ThemTieuChi") %>' class="rla-icon-btn rla-icon-btn--orange">➕ Thêm tiêu chí</a>
                </div>
            </div>

            <asp:Panel runat="server" ID="pnlEmpty" Visible="false">
                <div class="rla-empty">
                    <div class="ico">📭</div>
                    <div class="t">Chưa có phiếu khảo sát nào</div>
                    <div class="s">Dữ liệu sẽ hiển thị khi có khách hàng gửi phiếu.</div>
                </div>
            </asp:Panel>

            <asp:Panel runat="server" ID="pnlTable">
                <div style="overflow-x:auto;">
                    <table id="tblPhieu" class="rla-table mobile-card-list" style="width:100%;">
                        <thead>
                            <tr>
                                <th>Ngày gửi</th>
                                <th>Họ tên</th>
                                <th>Công ty</th>
                                <th>Tàu</th>
                                <th>Hài lòng chung</th>
                                <th data-orderable="false">Chi tiết</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:Repeater runat="server" ID="rptPhieu">
                                <ItemTemplate>
                                    <tr>
                                        <td data-label="Ngày gửi"><%# Eval("NgayGui", "{0:dd/MM/yyyy HH:mm}") %></td>
                                        <td data-label="Họ tên"><%# Server.HtmlEncode(NzStr(Eval("HoTen"))) %></td>
                                        <td data-label="Công ty"><%# Server.HtmlEncode(NzStr(Eval("CongTy"))) %></td>
                                        <td data-label="Tàu"><%# Server.HtmlEncode(NzStr(Eval("TenTau"))) %></td>
                                        <td data-label="Hài lòng chung">
                                            <span class="rla-badge <%# BadgeClass(NzStr(Eval("HaiLongChung"))) %>"><%# Server.HtmlEncode(NzStr(Eval("HaiLongChung"))) %></span>
                                        </td>
                                        <td data-label="Chi tiết">
                                            <button type="button" class="rla-icon-btn" onclick="showDetail(<%# Eval("Id") %>)">👁️ Xem</button>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </asp:Panel>
        </div>

        <div class="bottom-spacer" style="height:8px;"></div>
        <a href='<%= ResolveUrl("~/KhaoSat.aspx") %>' class="rla-btn rla-btn-ghost" style="display:inline-flex;">⬅️ Về trang khảo sát</a>
    </div>

    <%-- ===== Modal chi tiết ===== --%>
    <div class="rla-modal-overlay" id="detailOverlay" onclick="if(event.target===this)closeDetail()">
        <div class="rla-modal">
            <div class="rla-modal__head">
                <h3 id="mdTitle">Chi tiết phiếu</h3>
                <button type="button" class="rla-modal__close" onclick="closeDetail()">&times;</button>
            </div>
            <div class="rla-modal__body" id="mdBody"></div>
        </div>
    </div>

    <%-- ===== Dữ liệu chi tiết (JSON) ===== --%>
    <script type="text/javascript">
        var KS_DATA = <asp:Literal runat="server" ID="litJson" Text="{}" />;
    </script>

    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <script type="text/javascript">
        // Xác nhận xóa tiêu chí bằng SweetAlert2 rồi mới postback
        function confirmDeleteTc(el) {
            Swal.fire({
                icon: 'warning',
                title: 'Xóa tiêu chí?',
                text: 'Tiêu chí sẽ bị gỡ khỏi danh sách. Các phiếu đã gửi trước đó không bị ảnh hưởng.',
                showCancelButton: true,
                confirmButtonText: 'Xóa',
                cancelButtonText: 'Hủy',
                confirmButtonColor: '#dc2626',
                cancelButtonColor: '#9ca3af'
            }).then(function (r) {
                if (r.isConfirmed) {
                    var href = el.getAttribute('href');
                    if (href && href.indexOf('javascript:') === 0) { eval(href.substring(11)); }
                }
            });
            return false;
        }
    </script>

    <script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript">
        var MUC = ["", "Rất hài lòng", "Hài lòng", "Có thể chấp nhận được", "Không hài lòng"];

        function badgeClass(d) { return d >= 1 && d <= 4 ? "m" + d : ""; }

        function esc(s) {
            if (s == null) return "";
            return String(s).replace(/[&<>"]/g, function (c) {
                return { "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;" }[c];
            });
        }

        function showDetail(id) {
            var p = KS_DATA[id];
            if (!p) return;
            document.getElementById("mdTitle").textContent = "Phiếu #" + id + " — " + (p.HoTen || "");

            var h = "";
            h += "<div class='rla-grid' style='grid-template-columns:1fr 1fr;gap:6px 14px;margin-bottom:12px;'>";
            h += info("Họ tên", p.HoTen) + info("Chức vụ", p.ChucVu);
            h += info("Công ty", p.CongTy) + info("SĐT/Email", p.LienHe);
            h += info("Dịch vụ", p.DichVu) + info("Tên tàu", p.TenTau);
            h += info("Loại hàng", p.LoaiHangHoa) + info("Thời gian", p.ThoiGian);
            h += "</div>";

            h += "<p class='rla-section-label'>Đánh giá tổng thể</p>";
            h += "<div style='margin-bottom:12px;font-size:13px;'>";
            h += "<div>Hài lòng chung: <b>" + esc(p.HaiLongChung || "—") + "</b></div>";
            h += "<div>Tiếp tục sử dụng: <b>" + esc(p.TiepTucSuDung || "—") + "</b></div>";
            if (p.DeXuat) h += "<div style='margin-top:4px;'>Đề xuất: <i>" + esc(p.DeXuat) + "</i></div>";
            h += "</div>";

            h += "<p class='rla-section-label'>Chi tiết " + (p.Details ? p.Details.length : 0) + " tiêu chí</p>";
            h += "<table class='rla-table' style='width:100%;'><thead><tr><th>Mã</th><th>Nội dung</th><th>Điểm</th><th>Diễn giải</th></tr></thead><tbody>";
            (p.Details || []).forEach(function (d) {
                var dm = d.Diem ? "<span class='rla-badge " + badgeClass(d.Diem) + "'>" + d.Diem + " - " + esc(MUC[d.Diem]) + "</span>" : "—";
                h += "<tr><td>" + esc(d.MaTieuChi) + "</td><td style='text-align:left;'>" + esc(d.NoiDung) + "</td><td>" + dm + "</td><td style='text-align:left;'>" + esc(d.DienGiai || "") + "</td></tr>";
            });
            h += "</tbody></table>";

            document.getElementById("mdBody").innerHTML = h;
            document.getElementById("detailOverlay").classList.add("open");
        }

        function info(label, val) {
            return "<div class='rla-field'><span class='rla-label'>" + label + "</span><span>" + (val ? esc(val) : "—") + "</span></div>";
        }

        function closeDetail() { document.getElementById("detailOverlay").classList.remove("open"); }

        document.addEventListener("keydown", function (e) { if (e.key === "Escape") closeDetail(); });

        // DataTables
        (function () {
            if (window.jQuery && document.getElementById("tblPhieu") && KS_DATA && Object.keys(KS_DATA).length) {
                jQuery(function ($) {
                    $('#tblPhieu').DataTable({
                        order: [[0, 'desc']],
                        lengthMenu: [[10, 15, 20, 30, -1], [10, 15, 20, 30, "Tất cả"]],
                        language: {
                            search: "Tìm:", lengthMenu: "Hiện _MENU_ dòng", info: "_START_–_END_ / _TOTAL_",
                            infoEmpty: "Không có dữ liệu", zeroRecords: "Không tìm thấy",
                            paginate: { previous: "Trước", next: "Sau" }
                        }
                    });
                });
            }
        })();
    </script>

</asp:Content>
