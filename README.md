# 🛡️ Microsoft Genuine License Audit & Recovery Tool

> **Công cụ kiểm toán & phục hồi bản quyền Microsoft toàn diện** - Kiểm tra Windows, Office, Project, Visio, Visual Studio, SQL Server, Microsoft 365... Phát hiện kích hoạt không hợp lệ, gỡ bỏ KMS/crack, chuẩn hóa hệ thống, và xuất báo cáo chi tiết.

**CÔNG TY CỔ PHẦN GIẢI PHÁP CÔNG NGHỆ VÀ PHẦN MỀM PHỔ TUỆ**

---

## 🚀 Sử dụng ngay (1 lệnh duy nhất)

Mở **PowerShell với quyền Administrator** và chạy:

```powershell
irm https://irm-genuine-license-windows.hitechcloud.vn | iex
```

Tool sẽ tự động tải về và chạy ngay trên máy tính của bạn!

---

## 📋 Chức năng (v3.0)

### 🔍 Kiểm toán toàn diện Microsoft

| Sản phẩm | Kiểm tra |
|----------|----------|
| **Windows** | Edition, Build, Channel, License Status, OEM Key, KMS, Activation ID |
| **Office** | Office 365, 2024, LTSC, 2021, 2019, 2016 - License, KMS, Channel |
| **Project** | Standard, Professional, LTSC - License status |
| **Visio** | Standard, Professional, LTSC - License status |
| **Visual Studio** | Professional, Enterprise, Community - qua vswhere + Registry |
| **SQL Server** | Instances, Services, Edition |
| **Microsoft 365** | Subscription, Shared Computer Activation, Channel |
| **Exchange Server** | Services detection |
| **Remote Desktop** | RD Licensing status |
| **Windows Server** | Edition, License |

### 🛡️ Phát hiện & Xử lý

| # | Chức năng | Mô tả |
|---|-----------|--------|
| 1 | **Kiem toan toan dien** | Audit + Cleanup + Activate + Report (10 phases) |
| 2 | **Phat hien KMS** | KMS Server, DNS KMS, Registry, Scheduled Tasks |
| 3 | **Phat hien crack** | KMSpico, KMSAuto, HEU_KMS, Microsoft Toolkit... |
| 4 | **Phan loai rui ro** | HOP_LE / CAN_XEM_XET / CAN_XU_LY |
| 5 | **Xac nhan truoc khi sua** | Hien thi chi tiet, yeu cau xac nhan |
| 6 | **Lam sach he thong** | Go key, xoa KMS, khoi phuc Defender, sua Hosts |
| 7 | **Chuyen edition** | Home→Pro va cac edition khac |
| 8 | **Kich hoat** | OEM, Retail, MAK, Phone |
| 9 | **Windows 11** | TPM, Secure Boot, GPT, UEFI, RAM, CPU |
| 10 | **Bao cao** | HTML (dashboard), JSON, TXT, CSV |

### 📊 Bao cao HTML Dashboard

Bao cao HTML bao gom:
- **Stats cards**: Edition, License Status, Issues, Win11 Ready
- **System Info**: CPU, RAM, Disk, TPM, Secure Boot, BIOS
- **License Details**: Windows, Office, Project, Visio, VS, SQL
- **Issues Table**: Severity, Type, Product, Detail
- **Win11 Compatibility**: Pass/Fail cho moi tieu chi
- **Health Check**: Services, Defender, Firewall, Disk

---

## 🔧 Triển khai trên VPS Linux (Khuyến nghị)

### Setup tự động (1 lệnh duy nhất)

SSH vào VPS Linux, chạy:

```bash
curl -sSL https://raw.githubusercontent.com/thanhan92-f1/Windows-Genuine-License-Tool/main/vps-deploy/bootstrap.sh | sudo bash
```

Script sẽ tự động:
- ✅ Cài đặt Python3 (nếu chưa có)
- ✅ Download scripts từ GitHub
- ✅ Mở firewall port 8888
- ✅ Tạo systemd service (tự khởi động khi reboot)
- ✅ Khởi động server ngay

### Quản lý service

```bash
systemctl status pho-tue-scripts      # Xem trạng thái
systemctl restart pho-tue-scripts      # Khởi động lại
systemctl stop pho-tue-scripts         # Dừng service
journalctl -u pho-tue-scripts -f       # Xem log realtime
```

### Cập nhật (1 lệnh duy nhất)

Khi có phiên bản mới, SSH vào VPS chạy:

```bash
curl -sSL https://raw.githubusercontent.com/thanhan92-f1/Windows-Genuine-License-Tool/main/vps-deploy/update.sh | sudo bash
```

Script sẽ tự động:
- ✅ Backup phiên bản hiện tại
- ✅ Download phiên bản mới nhất từ GitHub
- ✅ Cập nhật domain
- ✅ Restart service
- ✅ Kiểm tra kết quả
- ✅ Xóa backup cũ (giữ 5 bản gần nhất)

---

## 📡 Cách hoạt động

```
Client (Máy trạm)                    VPS (Server)
       │                                    │
       │  irm https://domain | iex          │
       ├───────────────────────────────────►│
       │                                    │
       │  ← Microsoft-License-Audit-Tool.ps1│
       │◄───────────────────────────────────┤
       │                                    │
       │  Tool chay tu dong tren may        │
       │  (kiem toan, lam sach, kich hoat)  │
```

---

## 🏗️ Kiến trúc Tool v3.0

```
Microsoft Genuine License Audit & Recovery Tool
│
├── Phase 1: Thu thap thong tin he thong
│   ├── Windows Version, Build, Edition
│   ├── CPU, RAM, Disk, BIOS, Mainboard
│   ├── TPM, Secure Boot, Boot Mode
│   └── Network, Windows Update
│
├── Phase 2: Kiem tra dieu kien Windows 11
│   ├── TPM 2.0, Secure Boot, GPT, UEFI
│   ├── RAM >= 4GB, Storage >= 64GB
│   └── CPU ho tro
│
├── Phase 3: Kiem tra ban quyen Microsoft
│   ├── Windows License (Channel, KMS, OEM)
│   ├── Office (Click-to-Run, OSPP)
│   ├── Project, Visio
│   ├── Visual Studio (vswhere)
│   ├── SQL Server
│   ├── Microsoft 365
│   ├── Exchange Server
│   └── Remote Desktop
│
├── Phase 4: Phat hien kich hoat khong hop le
│   ├── KMS Server, DNS KMS
│   ├── Scheduled Tasks, Services
│   ├── Startup, Installed Programs
│   ├── Defender Status, Exclusions
│   ├── KMS Files & Directories
│   ├── Registry Entries
│   ├── Hosts File
│   ├── Certificates
│   └── Event Logs
│
├── Phase 5: Xac nhan va lam sach
│   ├── Phan loai: HOP_LE / CAN_XEM_XET / CAN_XU_LY
│   ├── Hien thi chi tiet, yeu cau xac nhan
│   ├── Tao backup truoc khi thay doi
│   └── Lam sach tung phan theo lua chon
│
├── Phase 6: Chuyen Edition
│   ├── Generic Key
│   ├── Key rieng
│   └── DISM
│
├── Phase 7: Kich hoat
│   ├── OEM, Retail, MAK
│   ├── Online, Phone
│   └── DISM
│
├── Phase 8: Xac minh ket qua
│
├── Phase 9: Suc khoe he thong
│
└── Phase 10: Xuat bao cao
    ├── HTML (Dashboard)
    ├── JSON
    ├── TXT
    └── CSV
```

---

## ⚠️ Lưu ý

- Tool **không cung cấp** giấy phép phần mềm
- Tool chỉ **gỡ bỏ** các công cụ crack và **chuẩn hóa** hệ thống
- Sau khi gỡ xong, cần **nhập key bản quyền** chính hãng để kích hoạt Windows
- Nên chạy trên **Image đang mở Super** (đối với hệ thống Bootrom)

---

## 📞 Liên hệ

**CÔNG TY CỔ PHẦN GIẢI PHÁP CÔNG NGHỆ VÀ PHẦN MỀM PHỔ TUỆ**

- 🌐 Website: [hitechcloud.vn](https://hitechcloud.vn)
- 🌐 Website: [hitechcloud.vn](https://hitechcloud.vn)

- 📧 Email: info@photuesoftware.com
- ☎️ Hotline: 0865.920.041
- 📍 Địa chỉ: 128 Đường Bình Mỹ, xã Bình Mỹ, Thành phố Hồ Chí Minh, Việt Nam
- 📍 Văn phòng làm việc Q. Bình Thạnh: Căn hộ OT03, Tòa nhà The Landmark 81, 720A Đ. Điện Biên Phủ, Vinhomes Tân Cảng, P. Thạnh Mỹ Tây, Tp. Hồ Chí Minh

---

## 📄 License

This tool is provided for system maintenance and standardization purposes only.
