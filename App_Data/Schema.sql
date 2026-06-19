/* =========================================================================
   Schema.sql — Tạo CSDL cho module Khảo sát chất lượng dịch vụ
   Chạy 1 lần trên SQL Server. Đảm bảo connection string trong Web.config
   (name="KhaoSatDb") trỏ đúng Data Source / Initial Catalog.
   ========================================================================= */

-- CREATE DATABASE KHAOSAT;
-- GO
-- USE KHAOSAT;
-- GO

IF OBJECT_ID('dbo.KS_ChiTiet', 'U') IS NOT NULL DROP TABLE dbo.KS_ChiTiet;
IF OBJECT_ID('dbo.KS_Phieu',   'U') IS NOT NULL DROP TABLE dbo.KS_Phieu;
GO

CREATE TABLE dbo.KS_Phieu (
    Id            INT IDENTITY(1,1) PRIMARY KEY,
    HoTen         NVARCHAR(200)  NULL,
    ChucVu        NVARCHAR(200)  NULL,
    CongTy        NVARCHAR(300)  NULL,
    LienHe        NVARCHAR(200)  NULL,   -- SĐT / Email
    DichVu        NVARCHAR(300)  NULL,   -- Dịch vụ sử dụng tại NSIP
    TenTau        NVARCHAR(200)  NULL,
    LoaiHangHoa   NVARCHAR(300)  NULL,
    ThoiGian      NVARCHAR(100)  NULL,
    HaiLongChung  NVARCHAR(50)   NULL,   -- Rất hài lòng / Hài lòng / Bình thường / Không hài lòng
    TiepTucSuDung NVARCHAR(20)   NULL,   -- Có / Cân nhắc / Không
    DeXuat        NVARCHAR(MAX)  NULL,
    NgayGui       DATETIME       NOT NULL DEFAULT GETDATE(),
    IPClient      NVARCHAR(50)   NULL
);
GO

CREATE TABLE dbo.KS_ChiTiet (
    Id        INT IDENTITY(1,1) PRIMARY KEY,
    PhieuId   INT            NOT NULL,
    MaTieuChi VARCHAR(20)    NULL,        -- "1.1", "5.7", ...
    Nhom      NVARCHAR(200)  NULL,
    NoiDung   NVARCHAR(500)  NULL,
    Diem      TINYINT        NULL,        -- 1..4
    DienGiai  NVARCHAR(1000) NULL,
    CONSTRAINT FK_KSChiTiet_Phieu FOREIGN KEY (PhieuId)
        REFERENCES dbo.KS_Phieu(Id) ON DELETE CASCADE
);
GO

CREATE INDEX IX_KSChiTiet_PhieuId ON dbo.KS_ChiTiet(PhieuId);
GO
