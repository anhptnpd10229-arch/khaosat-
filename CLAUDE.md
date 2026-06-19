# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

KHAOSAT is an ASP.NET WebForms application built with Visual Basic .NET targeting .NET Framework 4.8.1. It is a Visual Studio Web Application project (`KHAOSAT.vbproj`) run via IIS Express.

## Build & Run

**Build** (from project root using MSBuild):
```
msbuild KHAOSAT.sln
```

**Run**: Open `KHAOSAT.sln` in Visual Studio and press F5, or use IIS Express. The app is configured to run at `http://localhost:61923/`.

There are no automated tests in this project.

## Architecture

### Code-behind pattern
Every `.aspx` page has two companion files:
- `.aspx.vb` — the code-behind class (logic, event handlers)
- `.aspx.designer.vb` — auto-generated control declarations (do not edit manually)

### Master Pages
- `Site.Master` / `Site.Master.vb` — desktop layout: navbar (Home, About, Contact), Bootstrap 5, jQuery 3.7.0, MS Ajax bundles
- `Site.Mobile.Master` / `Site.Mobile.Master.vb` — mobile layout
- `ViewSwitcher.ascx` — user control that lets users toggle between desktop/mobile views

Pages inject content via `<asp:Content ContentPlaceHolderID="MainContent">`.

### Startup & Configuration
- `Global.asax.vb` — `Application_Start` wires routes and bundles
- `App_Start/RouteConfig.vb` — enables FriendlyUrls with permanent redirects
- `App_Start/BundleConfig.vb` — defines JS bundles (`WebFormsJs`, `MsAjaxJs`, `modernizr`) and registers jQuery CDN mapping
- `Web.config` — compilation target (4.8.1), assembly binding redirects, Roslyn compiler config
- `Web.Debug.config` / `Web.Release.config` — config transforms applied during publish

### Static Assets
- `Content/` — Bootstrap 5 CSS (full, grid, reboot, utilities variants + RTL + minified)
- `Scripts/` — Bootstrap 5 JS, jQuery 3.7.0, Modernizr 2.8.3, WebForms framework scripts

### NuGet packages (in `packages/`)
Key dependencies: `Microsoft.AspNet.FriendlyUrls.Core`, `Microsoft.AspNet.Web.Optimization`, `Microsoft.AspNet.ScriptManager.MSAjax`, `Newtonsoft.Json 13.0.3`, `Microsoft.CodeDom.Providers.DotNetCompilerPlatform` (Roslyn compiler).

## VB.NET Project Settings
- `Option Explicit On`, `Option Strict Off`, `Option Infer On`, `Option Compare Binary`
- Root namespace: `KHAOSAT`

---

## CSS Standards — PROJECT_CSS.md

**All CSS for this project follows [`PROJECT_CSS.md`](PROJECT_CSS.md).** Read it before writing any UI code. Key points:

### Brand colors
- Primary: `#EB8023` (CSS var: `--rla-brand`)
- Dark/secondary: `#484848` (CSS var: `--rla-dark`)
- `border-radius` max **12px** everywhere.

### Every page must have a hero header
```html
<section class="rla-hero">
    <div class="rla-kicker" style="color:#fed7aa;font-weight:800;">🏷️ NHÓM CHỨC NĂNG</div>
    <h1 class="rla-title">Tiêu đề trang</h1>
    <div class="rla-subtitle">Mô tả ngắn.</div>
</section>
```

### Tables
- Use `<table id="tbl..." class="rla-table mobile-card-list">` — never `GridView` for new/rewritten pages.
- Apply **DataTables** on every data table. `lengthMenu: [[10,15,20,30,-1],[10,15,20,30,"Tất cả"]]`.
- `<thead th>` background `#484848`, white text.
- Each `<td>` needs `data-label="Column name"` for mobile card view.
- Desktop: action icons inline. Mobile: collapse all actions into one trigger using `~/Images/Menu/MENUALL.png` (class `row-action-wrap` / `row-action-menu`).

### Combobox / DropDownList
- **Never** use raw `<select>`. Always `asp:DropDownList` with `CssClass="... stable-select"`.
- JS (`setupStableSelects()`) auto-renders a Vietnamese-search combobox.
- After UpdatePanel partial postback: call `setupStableSelects()` again.
- Mobile search input inside combobox must stay `font-size: 16px` to prevent iOS Safari zoom.

### Icon paths (always use `ResolveUrl`)
| Action | Path |
|---|---|
| View | `~/Images/Control/INFO.png` |
| Edit | `~/Images/Control/EDIT.png` |
| Delete | `~/Images/Control/DELETE.png` |
| Approve | `~/Images/Control/APPROVED.png` |
| Excel | `~/Images/Control/EXCEL.png` |
| Add | `~/Images/Control/ADD.png` |
| Mobile menu | `~/Images/Menu/MENUALL.png` |

### Notifications
- **SweetAlert2** — confirmations, deletions, approvals, important alerts.
- **Toastify** — lightweight auto-dismiss toasts (save success, minor updates).

### Back button (every page)
```html
<div class="bottom-nav">
    <button type="button" class="btn" onclick="return goBackSafe();">🔙 Quay lại</button>
</div>
```
Never override CSS for `bottom-nav` or `btn` — Master Page manages them.

### VB.NET Code Behind structure
```vb
#Region "01. Page Load"
#Region "02. Load dữ liệu"
#Region "03. Xử lý thêm mới"
#Region "04. Xử lý cập nhật"
#Region "05. Xử lý xóa"
#Region "06. Xử lý xuất Excel"
#Region "07. Hàm tiện ích"
```
- Use `HttpUtility.HtmlEncode()` for all DB text rendered to HTML.
- Use `ResolveUrl("~/Images/...")` for all icon paths in code-behind.
- Serialize DataTable to JSON via `Newtonsoft.Json.JsonConvert.SerializeObject(dt)` when passing data to JS.
