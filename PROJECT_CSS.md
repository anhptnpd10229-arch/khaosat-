# PROJECT_CSS.md

CSS chuẩn áp dụng cho toàn bộ dự án ASP.NET Web Forms.  
Màu chủ đạo: **#EB8023** — Màu phụ/xám đậm: **#484848**

---

## 1. CSS Variables

```css
:root {
    --rla-brand:  #EB8023;
    --rla-dark:   #484848;

    /* stable-select */
    --stable-brand:  #EB8023;
    --stable-dark:   #484848;
    --stable-border: #d1d5db;
    --stable-soft:   #fff7ed;
    --stable-text:   #111827;
    --stable-muted:  #6b7280;
}
```

---

## 2. Hero / Page Header

Mỗi trang bắt đầu bằng `<section class="rla-hero">`.

```css
.rla-hero {
    position: relative;
    overflow: hidden;
    border-radius: 10px;
    padding: 14px 16px 12px;
    margin-bottom: 8px;
    color: #fff;
    background: var(--rla-dark, #484848);
    box-shadow: 0 6px 18px rgba(15,23,42,.12);
}
.rla-hero:before {
    content: "";
    position: absolute;
    left: 0; top: 0; bottom: 0;
    width: 5px;
    background: var(--rla-brand, #EB8023);
}
.rla-hero:after {
    content: "";
    position: absolute;
    right: -70px; top: -70px;
    width: 180px; height: 180px;
    border-radius: 50%;
    background: rgba(235,128,35,.20);
    pointer-events: none;
}

.rla-kicker {
    position: relative; z-index: 1;
    display: inline-flex; align-items: center; gap: 5px;
    min-height: 20px;
    border-radius: 6px;
    padding: 2px 7px;
    margin-bottom: 5px;
    background: rgba(255,255,255,.12);
    color: #fed7aa;
    font-size: 11px; font-weight: 800; line-height: 1.2;
    text-transform: uppercase;
}
.rla-title {
    position: relative; z-index: 1;
    margin: 0;
    color: #fff;
    font-size: 19px; font-weight: 900; line-height: 1.28;
    word-break: break-word;
}
.rla-subtitle {
    position: relative; z-index: 1;
    max-width: 900px;
    margin-top: 4px;
    color: rgba(255,255,255,.78);
    font-size: 12px; font-weight: 500; line-height: 1.45;
}

@media (max-width: 767.98px) {
    .rla-hero    { padding: 10px 12px 10px; margin-bottom: 6px; }
    .rla-kicker  { min-height: 18px; font-size: 10px; padding: 2px 6px; }
    .rla-title   { font-size: 16px; line-height: 1.3; }
    .rla-subtitle{ font-size: 11px; margin-top: 3px; }
}
```

---

## 3. Utilities — Mật độ thông tin

```css
/* Số liệu không nhảy khi cập nhật */
.tabular-nums { font-variant-numeric: tabular-nums; }

/* Text overflow chuẩn cho cell bảng */
.cell-ellipsis {
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
}

/* Badge trạng thái */
.badge-status { letter-spacing: 0.02em; }

/* Hiệu ứng hover toàn dự án */
.hover-transition { transition: all 0.18s ease; }

/* Card/panel shadow */
.card-shadow { box-shadow: 0 2px 8px rgba(0,0,0,0.08); }

/* Focus ring cam */
.focus-ring:focus {
    outline: none;
    box-shadow: 0 0 0 3px rgba(235,128,35,0.25);
}
```

---

## 4. Custom Scrollbar

Áp dụng class `custom-scroll` cho container có scroll nội bộ.

```css
.custom-scroll::-webkit-scrollbar        { width: 5px; height: 5px; }
.custom-scroll::-webkit-scrollbar-thumb  { background: #EB8023; border-radius: 4px; }
.custom-scroll::-webkit-scrollbar-track  { background: rgba(0,0,0,0.05); }
```

---

## 5. Table — Mobile Card View

Thêm class `mobile-card-list` vào `<table>`.  
Mỗi `<td>` cần `data-label="Tên cột"`.

```css
@media (max-width: 767.98px) {
    .mobile-card-list table,
    .mobile-card-list thead {
        display: none;
    }

    .mobile-card-list tbody tr {
        display: block;
        margin-bottom: 8px;
        border: 0.5px solid #e0e0e0;
        border-radius: 10px;
        padding: 10px 12px;
        background: #fff;
        box-shadow: 0 1px 4px rgba(0,0,0,0.06);
    }

    .mobile-card-list tbody td {
        display: flex;
        justify-content: space-between;
        font-size: 12px;
        padding: 3px 0;
        border: none;
    }

    .mobile-card-list tbody td::before {
        content: attr(data-label);
        color: #888;
        font-size: 11px;
        font-weight: 600;
        min-width: 100px;
        flex-shrink: 0;
    }
}
```

---

## 6. Action Menu — Desktop & Mobile

Desktop: icon nằm ngang. Mobile: 1 nút trigger `~/Images/Menu/MENUALL.png`.

```css
.action-desktop {
    display: inline-flex;
    align-items: center;
    gap: 4px;
}
.action-mobile { display: none; }

.row-action-wrap {
    position: relative;
    display: inline-flex;
}

.row-action-trigger {
    width: 38px; height: 38px; min-width: 38px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    background: #fff;
    display: inline-flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    transition: all 0.18s ease;
}
.row-action-trigger:hover,
.row-action-trigger:focus {
    border-color: #EB8023;
    box-shadow: 0 0 0 3px rgba(235,128,35,0.25);
    outline: none;
}
.row-action-trigger img { width: 20px; height: 20px; object-fit: contain; }

.row-action-menu {
    position: fixed;
    z-index: 99990;
    display: none;
    min-width: 150px;
    padding: 5px;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    background: #fff;
    box-shadow: 0 14px 32px rgba(15,23,42,0.18);
}
.row-action-menu.is-open { display: grid; gap: 3px; }

.row-action-menu button {
    width: 100%;
    min-height: 38px;
    border: 0; border-radius: 8px;
    background: transparent;
    color: #374151;
    padding: 7px 9px;
    font-size: 12px;
    text-align: left;
    cursor: pointer;
    transition: all 0.18s ease;
}
.row-action-menu button:hover  { background: #fff7ed; color: #9a3412; }
.row-action-menu button.danger { color: #dc2626; }

@media (max-width: 767.98px) {
    .action-desktop { display: none; }
    .action-mobile  { display: inline-flex; }

    .row-action-trigger { width: 44px; height: 44px; min-width: 44px; }
    .row-action-menu button { min-height: 42px; font-size: 12px; }
}
```

---

## 7. Skeleton Loading

```css
.skeleton {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: shimmer 1.2s infinite;
    border-radius: 4px;
}
@keyframes shimmer {
    0%   { background-position:  200% 0; }
    100% { background-position: -200% 0; }
}
```

---

## 8. Stable Combobox

`asp:DropDownList` với `CssClass="... stable-select"`. JS tự render combobox có tìm kiếm tiếng Việt.

```css
select.stable-select.stable-select-native {
    position: absolute !important;
    width: 1px !important; height: 1px !important;
    min-height: 1px !important;
    opacity: 0 !important;
    pointer-events: none !important;
}

.stable-combobox {
    position: relative;
    width: 100%; min-width: 0;
    font-size: 12.5px;
}

.stable-combobox__control {
    width: 100%;
    min-height: 34px; height: 34px;
    display: flex; align-items: center;
    justify-content: space-between; gap: 7px;
    padding: 4px 8px;
    border: 1px solid var(--stable-border);
    border-radius: 10px;
    background: #fff;
    color: var(--stable-text);
    text-align: left;
    cursor: pointer;
    transition: all 0.18s ease;
}
.stable-combobox__control:hover,
.stable-combobox__control:focus,
.stable-combobox.is-open .stable-combobox__control {
    border-color: var(--stable-brand);
    box-shadow: 0 0 0 3px rgba(235,128,35,0.25);
    outline: none;
}

.stable-combobox__value {
    min-width: 0;
    overflow: hidden; text-overflow: ellipsis; white-space: nowrap;
}
.stable-combobox__arrow { color: var(--stable-brand); font-size: 12px; flex: 0 0 auto; }

.stable-combobox__panel {
    position: fixed;
    z-index: 99999;
    display: none; flex-direction: column;
    max-height: 280px; overflow: hidden;
    border: 1px solid rgba(235,128,35,0.35);
    border-radius: 10px;
    background: #fff;
    box-shadow: 0 12px 32px rgba(15,23,42,0.18);
}
.stable-combobox.is-open .stable-combobox__panel { display: flex; }

.stable-combobox__search-wrap { padding: 6px; border-bottom: 1px solid #f1f5f9; }
.stable-combobox__search {
    width: 100%; height: 32px;
    border: 1px solid var(--stable-border);
    border-radius: 8px;
    padding: 4px 8px;
    font-size: 12.5px; outline: none;
}
.stable-combobox__search:focus {
    border-color: var(--stable-brand);
    box-shadow: 0 0 0 3px rgba(235,128,35,0.18);
}

.stable-combobox__list {
    overflow: auto; -webkit-overflow-scrolling: touch; padding: 4px;
}
.stable-combobox__list::-webkit-scrollbar        { width: 5px; height: 5px; }
.stable-combobox__list::-webkit-scrollbar-thumb  { background: var(--stable-brand); border-radius: 4px; }
.stable-combobox__list::-webkit-scrollbar-track  { background: rgba(0,0,0,0.05); }

.stable-combobox__option {
    width: 100%; min-height: 30px;
    border: 0; border-radius: 8px;
    background: transparent; color: var(--stable-text);
    padding: 6px 8px; font-size: 12px;
    text-align: left; cursor: pointer;
    transition: all 0.18s ease;
}
.stable-combobox__option:hover,
.stable-combobox__option:focus    { background: var(--stable-soft); color: #9a3412; outline: none; }
.stable-combobox__option.is-selected { background: var(--stable-brand); color: #fff; font-weight: 800; }

.stable-combobox__empty {
    padding: 10px; color: var(--stable-muted);
    font-size: 12px; text-align: center; font-weight: 700;
}

@media (max-width: 767.98px) {
    .stable-combobox { font-size: 12px; }

    .stable-combobox__control {
        min-height: 40px; height: 40px;
        padding: 4px 8px; font-size: 12px !important;
    }
    .stable-combobox__value  { font-size: 12px !important; line-height: 1.25; }
    .stable-combobox__search { height: 38px; font-size: 16px !important; padding: 4px 8px; }
    .stable-combobox__option { min-height: 38px; padding: 7px 9px; font-size: 12px !important; line-height: 1.25; }

    /* Trong modal nhỏ hơn một chút */
    .modal-overlay .stable-combobox,
    .modal         .stable-combobox             { font-size: 11.5px; }

    .modal-overlay .stable-combobox__control,
    .modal         .stable-combobox__control    { min-height: 38px; height: 38px; font-size: 11.5px !important; }

    .modal-overlay .stable-combobox__value,
    .modal         .stable-combobox__value      { font-size: 11.5px !important; }

    .modal-overlay .stable-combobox__option,
    .modal         .stable-combobox__option     { min-height: 36px; font-size: 11.5px !important; padding: 6px 8px; }

    .modal-overlay .stable-combobox__search,
    .modal         .stable-combobox__search     { font-size: 16px !important; }
}
```

---

## 9. Quy định kích thước & khoảng cách

### Font size

| Ngữ cảnh | Desktop | Mobile |
|---|---|---|
| Chữ thân bài, dữ liệu bảng | 12–13px | 12px |
| Dữ liệu bảng đặc biệt | — | 11.5–12px |
| Label, caption, ghi chú | 11–12px | 11px |
| Tiêu đề card / section | 13–15px | 13px |
| Tiêu đề trang `.rla-title` | 18–20px | 15–16px |
| Nút bấm | 12–13px | 12px |
| Header bảng `th` | 11–12px | 11px |
| Ô tìm kiếm DataTables | 12–13px | 11–12px |
| Badge / trạng thái | 10–11px | 10px |
| `input`, `select`, `textarea` | — | **16px** (chống iOS Safari zoom) |
| Combobox hiển thị | 12–12.5px | 11.5–12px |
| Search input trong combobox | 12.5px | **16px** (chống iOS zoom) |

### Padding / Margin / Gap

| Thành phần | Desktop | Mobile |
|---|---|---|
| Card/panel `padding` | 10px 14px | 8px 10px |
| Section `margin-bottom` | 8–10px | 6–8px |
| Row form `margin-bottom` | 6–8px | 4–6px |
| Gap giữa card summary | 8–10px | 6–8px |
| Input `padding` | 4px 8px | 4px 7px |
| Nút bấm `padding` | 4px 10px | 3px 8px |
| Hero `padding` | 14px 16px | 10px 12px |
| Toolbar DataTables `padding` | 4px 0 | 3px 0 |
| `td` | 5px 8px | 4px 6px |
| `th` | 6px 8px | 5px 7px |

### Line-height

| Ngữ cảnh | Giá trị |
|---|---|
| Chữ thân bài | 1.35–1.45 |
| Tiêu đề | 1.2–1.3 |
| Badge / trạng thái | 1.2 |

---

## 10. Table Header

```css
thead th {
    background: #484848;
    color: #fff;
    font-size: 11px;
    padding: 6px 8px;
    white-space: nowrap;
}
```

---

## 11. Dashboard Summary Card

```css
.dashboard-cards-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 8px;
}

@media (max-width: 767.98px) {
    .dashboard-cards-grid {
        grid-template-columns: repeat(2, 1fr);
        gap: 6px;
    }
}

.dashboard-sumary-card {
    border-radius: 12px;
    width: 100%; min-width: 0;
    box-shadow: 0 2px 8px rgba(0,0,0,0.08);
    transition: all 0.18s ease;
    cursor: pointer;
}
.dashboard-sumary-card[data-clickable="true"]:active {
    transform: scale(0.97);
}
```

---

## 12. Modal

```css
.modal-body-scroll {
    overflow-y: auto;
    -webkit-overflow-scrolling: touch;
    max-height: 60vh;
}

.modal-close-btn {
    width: 44px; height: 44px; min-width: 44px;
    display: inline-flex; align-items: center; justify-content: center;
    border: 0; border-radius: 8px;
    background: transparent;
    cursor: pointer;
    transition: all 0.18s ease;
}

@media (max-width: 767.98px) {
    .modal-dialog { max-height: 92dvh; }
}
```

---

## 13. Empty State

```css
.rla-empty-state {
    text-align: center;
    padding: 40px 20px;
    color: #888;
}
```

HTML mẫu:
```html
<div class="rla-empty-state">
    <div style="font-size:40px;margin-bottom:12px;">📭</div>
    <div style="font-size:14px;font-weight:600;color:#484848;">Không có dữ liệu</div>
    <div style="font-size:12px;margin-top:4px;">Thử thay đổi bộ lọc hoặc thêm dữ liệu mới</div>
</div>
```
