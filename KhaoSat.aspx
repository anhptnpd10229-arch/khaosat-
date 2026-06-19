<%@ Page Title="Phiếu khảo sát chất lượng dịch vụ 2026" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="KhaoSat.aspx.vb" Inherits="KHAOSAT.KhaoSat" %>

<asp:Content ID="KhaoSatContent" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/rla-survey.css") %>' />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />

    <div class="rla-wrap">

        <%-- ===== Hero ===== --%>
        <section class="rla-hero">
            <div class="rla-kicker">📋 Khảo sát dịch vụ</div>
            <h1 class="rla-title">Phiếu khảo sát chất lượng dịch vụ 2026</h1>
            <div class="rla-subtitle">Ý kiến của Quý khách giúp chúng tôi nâng cao chất lượng dịch vụ. Vui lòng dành ít phút hoàn thành phiếu dưới đây.</div>
        </section>

        <%-- ===== Thanh tiến độ ===== --%>
        <div class="rla-progress">
            <div class="rla-progress__top">
                <span>Tiến độ đánh giá</span>
                <span><b id="progDone">0</b>/<span id="progTotal"><%= KHAOSAT.KhaoSatData.TongTieuChi() %></span> tiêu chí</span>
            </div>
            <div class="rla-progress__bar"><div class="rla-progress__fill" id="progFill"></div></div>
        </div>

        <%-- ===== I. Thông tin khách hàng ===== --%>
        <div class="rla-card rla-card--info">
            <div class="rla-card__head">
                <span class="rla-card__num">I</span>
                <div>
                    <h2 class="rla-card__title">Thông tin khách hàng</h2>
                    <p class="rla-card__desc">Vui lòng điền đầy đủ thông tin để chúng tôi có thể liên hệ nếu cần thiết.</p>
                </div>
            </div>
            <div class="rla-info-form">

                <div class="rla-field-group">
                    <p class="rla-group-label">Thông tin người đánh giá</p>
                    <div class="rla-field">
                        <label class="rla-label">Họ và tên <span class="req">*</span></label>
                        <asp:TextBox runat="server" ID="txtHoTen" CssClass="rla-input" ClientIDMode="Static" placeholder="Nguyễn Văn A" />
                    </div>
                    <div class="rla-field">
                        <label class="rla-label">Chức vụ</label>
                        <asp:TextBox runat="server" ID="txtChucVu" CssClass="rla-input" ClientIDMode="Static" placeholder="Trưởng phòng xuất nhập khẩu..." />
                    </div>
                </div>

                <div class="rla-field-group">
                    <p class="rla-group-label">Thông tin doanh nghiệp</p>
                    <div class="rla-field">
                        <label class="rla-label">Tên công ty <span class="req">*</span></label>
                        <asp:TextBox runat="server" ID="txtCongTy" CssClass="rla-input" ClientIDMode="Static" placeholder="Công ty TNHH / Cổ phần..." />
                    </div>
                    <div class="rla-field">
                        <label class="rla-label">Thời gian</label>
                        <asp:TextBox runat="server" ID="txtThoiGian" CssClass="rla-input" ClientIDMode="Static" TextMode="Date" />
                    </div>
                    <div class="rla-field">
                        <label class="rla-label">Số điện thoại / Email</label>
                        <asp:TextBox runat="server" ID="txtLienHe" CssClass="rla-input" ClientIDMode="Static" placeholder="0901 234 567 hoặc email@..." />
                    </div>
                    <div class="rla-field">
                        <label class="rla-label">Dịch vụ sử dụng tại NSIP</label>
                        <asp:TextBox runat="server" ID="txtDichVu" CssClass="rla-input" ClientIDMode="Static" placeholder="VD: Xếp dỡ, lưu bãi, giao nhận..." />
                    </div>
                </div>

                <div class="rla-field-group">
                    <p class="rla-group-label">Thông tin chuyến hàng</p>
                    <div class="rla-field">
                        <label class="rla-label">Tên tàu</label>
                        <asp:TextBox runat="server" ID="txtTenTau" CssClass="rla-input" ClientIDMode="Static" placeholder="VD: EVER GIVEN" />
                    </div>
                    <div class="rla-field">
                        <label class="rla-label">Loại hàng hóa</label>
                        <asp:TextBox runat="server" ID="txtLoaiHang" CssClass="rla-input" ClientIDMode="Static" placeholder="VD: Container 20ft, hàng rời..." />
                    </div>
                </div>

            </div>
        </div>

        <%-- ===== III. Đánh giá chi tiết (4 tiêu chí) ===== --%>
        <asp:Repeater runat="server" ID="rptNhom">
            <ItemTemplate>
                <div class="rla-card">
                    <div class="rla-card__head">
                        <span class="rla-card__num"><%# Eval("SoLaMa") %></span>
                        <h2 class="rla-card__title"><%# Server.HtmlEncode(Eval("Ten").ToString()) %></h2>
                    </div>
                    <p class="rla-section-label" style="margin-bottom:4px;">Khi chọn mức 3 hoặc 4, vui lòng diễn giải nội dung chưa đạt.</p>

                    <asp:Repeater runat="server" DataSource='<%# Eval("DanhSach") %>'>
                        <ItemTemplate>
                            <div class="rla-item">
                                <div class="rla-item__text"><span class="ma"><%# Eval("Ma") %>.</span><%# Server.HtmlEncode(Eval("NoiDung").ToString()) %></div>

                                <div class="rla-item__right">
                                    <div class="rla-rate" data-key='<%# Eval("Ma").ToString().Replace(".", "_") %>'>
                                        <input type="radio" name='<%# "diem_" & Eval("Ma").ToString().Replace(".", "_") %>' id='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_1" %>' value="1" />
                                        <label for='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_1" %>' title="Rất hài lòng"></label>

                                        <input type="radio" name='<%# "diem_" & Eval("Ma").ToString().Replace(".", "_") %>' id='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_2" %>' value="2" />
                                        <label for='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_2" %>' title="Hài lòng"></label>

                                        <input type="radio" name='<%# "diem_" & Eval("Ma").ToString().Replace(".", "_") %>' id='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_3" %>' value="3" />
                                        <label for='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_3" %>' title="Có thể chấp nhận được"></label>

                                        <input type="radio" name='<%# "diem_" & Eval("Ma").ToString().Replace(".", "_") %>' id='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_4" %>' value="4" />
                                        <label for='<%# "d" & Eval("Ma").ToString().Replace(".", "_") & "_4" %>' title="Không hài lòng"></label>
                                    </div>
                                    <span class="star-hint" id='<%# "sh_" & Eval("Ma").ToString().Replace(".", "_") %>'></span>
                                </div>

                                <div class="rla-dg" id='<%# "dgwrap_" & Eval("Ma").ToString().Replace(".", "_") %>'>
                                    <div class="rla-dg__hint">Diễn giải nội dung chưa đạt yêu cầu:</div>
                                    <textarea name='<%# "dg_" & Eval("Ma").ToString().Replace(".", "_") %>' rows="2" placeholder="Nhập diễn giải..."></textarea>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <%-- ===== IV. Đánh giá tổng thể ===== --%>
        <div class="rla-card rla-card--final">
            <div class="rla-card__head">
                <span class="rla-card__num">III</span>
                <h2 class="rla-card__title">Đánh giá tổng thể</h2>
            </div>

            <%-- Hai cột trên desktop, xếp dọc trên mobile --%>
            <div class="rla-final-top">
                <div class="rla-final-section">
                    <p class="rla-final-label">Mức độ hài lòng chung</p>
                    <div class="rla-seg">
                        <input type="radio" name="hailong" id="hl1" value="Rất hài lòng" /><label for="hl1">Rất hài lòng</label>
                        <input type="radio" name="hailong" id="hl2" value="Hài lòng" /><label for="hl2">Hài lòng</label>
                        <input type="radio" name="hailong" id="hl3" value="Bình thường" /><label for="hl3">Bình thường</label>
                        <input type="radio" name="hailong" id="hl4" value="Không hài lòng" /><label for="hl4">Không hài lòng</label>
                    </div>
                </div>
                <div class="rla-final-section">
                    <p class="rla-final-label">Khả năng tiếp tục sử dụng dịch vụ</p>
                    <div class="rla-seg">
                        <input type="radio" name="tieptuc" id="tt1" value="Có" /><label for="tt1">Có</label>
                        <input type="radio" name="tieptuc" id="tt2" value="Cân nhắc" /><label for="tt2">Cân nhắc</label>
                        <input type="radio" name="tieptuc" id="tt3" value="Không" /><label for="tt3">Không</label>
                    </div>
                </div>
            </div>

            <%-- Góp ý: full width --%>
            <div class="rla-final-section">
                <p class="rla-final-label">Đề xuất / Kiến nghị khác</p>
                <textarea name="dexuat" rows="3" class="rla-textarea" placeholder="Quý khách vui lòng chia sẻ thêm ý kiến đóng góp..."></textarea>
            </div>
        </div>

    </div>

    <%-- ===== Thanh gửi dính đáy ===== --%>
    <div class="rla-bottom">
        <div class="rla-bottom__inner">
            <a href='<%= ResolveUrl("~/KetQuaKhaoSat.aspx") %>' class="rla-btn rla-btn-ghost" title="Xem kết quả">📊</a>
            <asp:Button runat="server" ID="btnGui" CssClass="rla-btn rla-btn-primary"
                Text="Gửi khảo sát" OnClick="btnGui_Click" OnClientClick="return rlaValidate();" UseSubmitBehavior="false" />
        </div>
    </div>

    <%-- ===== Thư viện ===== --%>
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>

    <script type="text/javascript">
        (function () {
            var TOTAL = <%= KHAOSAT.KhaoSatData.TongTieuChi() %>;

            function answeredCount() {
                var groups = document.querySelectorAll('.rla-rate');
                var n = 0;
                groups.forEach(function (g) {
                    if (g.querySelector('input:checked')) n++;
                });
                return n;
            }

            function updateProgress() {
                var done = answeredCount();
                var pct = TOTAL > 0 ? Math.round(done / TOTAL * 100) : 0;
                document.getElementById('progDone').textContent = done;
                document.getElementById('progFill').style.width = pct + '%';
            }

            var HINT_LABELS = ['', 'Rất hài lòng', 'Hài lòng', 'Có thể chấp nhận được', 'Không hài lòng'];
            var HINT_COLORS = ['', 'var(--m1)', 'var(--m2)', 'var(--m3)', 'var(--m4)'];

            // Hiện/ẩn ô diễn giải + cập nhật tiến độ + hiện nhãn sao khi chọn điểm
            document.addEventListener('change', function (e) {
                if (e.target && e.target.matches('.rla-rate input[type=radio]')) {
                    var wrap = e.target.closest('.rla-rate');
                    var key = wrap.getAttribute('data-key');
                    var val = parseInt(e.target.value);

                    // Hiện/ẩn ô diễn giải
                    var dg = document.getElementById('dgwrap_' + key);
                    if (dg) {
                        if (val === 3 || val === 4) dg.classList.add('show');
                        else dg.classList.remove('show');
                    }

                    // Cập nhật nhãn mức điểm bên cạnh sao
                    var hint = document.getElementById('sh_' + key);
                    if (hint) {
                        hint.textContent = HINT_LABELS[val] || '';
                        hint.style.color = HINT_COLORS[val] || '';
                        hint.classList.add('show');
                    }

                    updateProgress();
                }
            });

            // Validate trước khi submit. Luôn trả về false và tự postback sau khi
            // người dùng xác nhận, vì SweetAlert hoạt động bất đồng bộ.
            window.rlaValidate = function () {
                var hoten = (document.getElementById('txtHoTen').value || '').trim();
                var congty = (document.getElementById('txtCongTy').value || '').trim();
                if (!hoten || !congty) {
                    Swal.fire({ icon: 'warning', title: 'Thiếu thông tin', text: 'Vui lòng nhập Họ và tên và Tên công ty.', confirmButtonColor: '#EB8023' });
                    return false;
                }
                var done = answeredCount();
                if (done < TOTAL) {
                    Swal.fire({
                        icon: 'warning',
                        title: 'Chưa đánh giá hết',
                        html: 'Còn <b>' + (TOTAL - done) + '</b> tiêu chí chưa được đánh giá.<br>Bạn vẫn muốn gửi phiếu?',
                        showCancelButton: true,
                        confirmButtonText: 'Vẫn gửi',
                        cancelButtonText: 'Quay lại kiểm tra',
                        confirmButtonColor: '#EB8023',
                        cancelButtonColor: '#9ca3af'
                    }).then(function (r) { if (r.isConfirmed) __doSubmit(); });
                    return false;
                }
                // Đã đánh giá đủ → hiện xác nhận trước khi gửi
                Swal.fire({
                    icon: 'success',
                    title: 'Xác nhận gửi phiếu',
                    html: 'Bạn đã đánh giá đầy đủ <b>' + TOTAL + '/' + TOTAL + '</b> tiêu chí.<br>Xác nhận gửi phiếu khảo sát?',
                    showCancelButton: true,
                    confirmButtonText: '✅ Gửi phiếu',
                    cancelButtonText: 'Kiểm tra lại',
                    confirmButtonColor: '#EB8023',
                    cancelButtonColor: '#9ca3af',
                    reverseButtons: false
                }).then(function (r) { if (r.isConfirmed) __doSubmit(); });
                return false;
            };

            // Postback thủ công tới nút Gửi
            window.__doSubmit = function () {
                __doPostBack('<%= btnGui.UniqueID %>', '');
            };

            updateProgress();
        })();
    </script>

</asp:Content>
