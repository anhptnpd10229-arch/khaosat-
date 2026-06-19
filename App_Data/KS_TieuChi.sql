-- Bảng danh mục tiêu chí khảo sát (lookup table)
-- Chạy trên database Tester @ 113.160.181.14,1433

IF OBJECT_ID('dbo.KS_TieuChi','U') IS NOT NULL DROP TABLE dbo.KS_TieuChi;
GO

CREATE TABLE dbo.KS_TieuChi (
    Id         INT IDENTITY(1,1) PRIMARY KEY,
    Ma         VARCHAR(10)    NOT NULL UNIQUE,
    TenTieuChi NVARCHAR(300)  NOT NULL,
    ThuTu      INT            NOT NULL DEFAULT 0,
    IsActive   BIT            NOT NULL DEFAULT 1,
    NgayTao    DATETIME       NOT NULL DEFAULT GETDATE()
);
GO

INSERT INTO dbo.KS_TieuChi (Ma, TenTieuChi, ThuTu) VALUES
(N'1', N'Kế hoạch, điều độ cầu bến', 1),
(N'2', N'An ninh - an toàn', 2),
(N'3', N'Công tác khai thác', 3),
(N'4', N'Thương vụ', 4);
GO

SELECT Ma, TenTieuChi, ThuTu FROM dbo.KS_TieuChi ORDER BY ThuTu;
GO
