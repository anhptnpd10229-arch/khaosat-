<%@ Page Title="Mã QR Khảo sát" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MaQR.aspx.vb" Inherits="KHAOSAT.MaQR" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <link rel="stylesheet" href='<%= ResolveUrl("~/Content/rla-survey.css") %>' />

    <style>
        .qr-page { max-width: 520px; margin: 0 auto; padding: 0 8px 60px; }

        .qr-card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 28px 24px 24px;
            text-align: center;
            box-shadow: 0 4px 18px rgba(0,0,0,.08);
        }
        .qr-logo {
            display: inline-flex; align-items: center; gap: 7px;
            background: #fff7ed; border: 1.5px solid #fcd9b6;
            border-radius: 10px; padding: 6px 14px;
            font-size: 13px; font-weight: 800; color: #c4661a;
            margin-bottom: 18px;
        }
        #qrBox {
            display: inline-block;
            padding: 14px;
            background: #fff;
            border: 2px solid #484848;
            border-radius: 12px;
        }
        .qr-url {
            margin: 14px 0 0;
            font-size: 12px; color: #6b7280;
            word-break: break-all; line-height: 1.5;
        }
        .qr-hint {
            margin-top: 6px;
            font-size: 11px; color: #9ca3af; font-style: italic;
        }
        .qr-actions {
            display: flex; justify-content: center; gap: 10px;
            flex-wrap: wrap; margin-top: 20px;
        }
        .qr-btn {
            display: inline-flex; align-items: center; gap: 6px;
            height: 44px; padding: 0 20px;
            border-radius: 10px; border: none; cursor: pointer;
            font-size: 13.5px; font-weight: 700;
            transition: opacity .15s, transform .12s;
        }
        .qr-btn:hover { opacity: .88; transform: translateY(-1px); }
        .qr-btn--primary { background: #EB8023; color: #fff; }
        .qr-btn--outline { background: #fff; color: #484848; border: 1.5px solid #d1d5db; }
        .qr-btn--print   { background: #484848; color: #fff; }

        /* ===== Print ===== */
        @media print {
            .rla-hero, .qr-actions, .bottom-nav, nav, footer,
            .navbar, .navbar-brand, #navigation { display: none !important; }
            body, .qr-page { margin: 0 !important; padding: 0 !important; }
            .qr-card { box-shadow: none !important; border: none !important; padding: 0 !important; }
        }
    </style>

    <div class="qr-page">

        <section class="rla-hero" style="margin-bottom:14px;">
            <div class="rla-kicker" style="color:#fed7aa;font-weight:800;">📱 MÃ QR KHẢO SÁT</div>
            <h1 class="rla-title">Mã QR phiếu khảo sát dịch vụ</h1>
            <div class="rla-subtitle">Quét mã bằng điện thoại để mở thẳng trang khảo sát, hoặc tải PNG để gửi cho khách hàng.</div>
        </section>

        <div class="qr-card">
            <div class="qr-logo">🏛️ NSIP — Khảo sát chất lượng dịch vụ</div>

            <%-- QR code render target --%>
            <div id="qrBox"></div>

            <div class="qr-url" id="qrUrlText"></div>
            <div class="qr-hint">Dùng camera điện thoại hoặc ứng dụng quét mã QR</div>

            <div class="qr-actions">
                <button class="qr-btn qr-btn--primary" onclick="downloadQr('png')">⬇️ Tải PNG</button>
                <button class="qr-btn qr-btn--outline"  onclick="copyUrl()">📋 Sao chép link</button>
                <button class="qr-btn qr-btn--print"    onclick="window.print()">🖨️ In mã QR</button>
            </div>
        </div>

        <div class="bottom-nav" style="margin-top:14px;">
            <a href='<%= ResolveUrl("~/KetQuaKhaoSat") %>' class="btn">🔙 Quay lại</a>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/toastify-js"></script>
    <link  rel="stylesheet" href="https://cdn.jsdelivr.net/npm/toastify-js/src/toastify.min.css" />
    <script type="text/javascript">
        var SURVEY_URL = (function () {
            var origin = window.location.protocol + '//' + window.location.host;
            return origin + '<%= ResolveUrl("~/KhaoSat.aspx") %>';
        })();

        document.getElementById('qrUrlText').textContent = SURVEY_URL;

        var qr = new QRCode(document.getElementById('qrBox'), {
            text: SURVEY_URL,
            width: 280, height: 280,
            colorDark: '#484848',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });

        function downloadQr(fmt) {
            var canvas = document.querySelector('#qrBox canvas');
            if (!canvas) { alert('Vui lòng chờ QR render xong.'); return; }

            // Tạo canvas lớn hơn để chất lượng tốt hơn khi in
            var size = 600;
            var out = document.createElement('canvas');
            out.width = size; out.height = size;
            var ctx = out.getContext('2d');
            ctx.imageSmoothingEnabled = false;
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(0, 0, size, size);
            ctx.drawImage(canvas, 0, 0, size, size);

            var a = document.createElement('a');
            a.download = 'NSIP-KhaoSat-QR.png';
            a.href = out.toDataURL('image/png');
            a.click();
        }

        function copyUrl() {
            if (navigator.clipboard) {
                navigator.clipboard.writeText(SURVEY_URL).then(function () { toast('Đã sao chép link khảo sát!'); });
            } else {
                var t = document.createElement('textarea');
                t.value = SURVEY_URL;
                document.body.appendChild(t);
                t.select();
                document.execCommand('copy');
                document.body.removeChild(t);
                toast('Đã sao chép link khảo sát!');
            }
        }

        function toast(msg) {
            Toastify({
                text: msg, duration: 2500, gravity: 'top', position: 'right',
                style: { background: '#16a34a', borderRadius: '10px', fontWeight: '600' }
            }).showToast();
        }
    </script>

</asp:Content>
