# 🧊 Server Snapshot & Restore

Backup & restore *seluruh sistem Linux* secara otomatis hanya dengan dua perintah: `server-snapshot` dan `server-restore`.  
Cocok untuk *VPS, server produksi, atau workstation penting* Anda. ⚡

---

## ✨ Fitur Utama

- 🔁 **Snapshot seluruh sistem** (default: `/`)
- 🔄 **Restore otomatis** dari snapshot terbaru
- 📁 Simpan backup di `/snapshots`
- 📦 Dukungan rsync dengan ACL & extended attributes
- 🛡️ Pengecualian direktori penting seperti `/proc`, `/sys`, dll.

---

## ⚙️ Instalasi

Jalankan dengan root:

```bash
sudo bash install.sh
```

Perintah berikut akan terinstal:

- `server-snapshot` → Membuat snapshot seluruh sistem
- `server-restore` → Mengembalikan ke snapshot terakhir

---

## 🚀 Cara Implementasi

1. **Jalankan snapshot rutin via cron:**

   ```bash
   sudo crontab -e
   ```

   Tambahkan, contoh: backup harian pukul 02:00:

   ```
   0 2 * * * /usr/local/bin/server-snapshot >> /var/log/snapshot.log 2>&1
   ```

2. **Simpan hasil snapshot ke disk eksternal / lokasi lain:**

   Edit `install.sh` atau file `/usr/local/bin/server-snapshot`:

   ```bash
   SNAPSHOT_BASE_DIR="/mnt/backup/snapshots"
   ```

   Pastikan `/mnt/backup` sudah ter-mount.

3. **Restore jika sistem rusak:**

   ```bash
   sudo server-restore
   ```

   Ketik `YES` saat konfirmasi.

---

## 🛠️ Kustomisasi

Edit file `server-snapshot`:

```bash
sudo nano /usr/local/bin/server-snapshot
```

Ubah baris:

```bash
SOURCE_DIRS="/"
```

Menjadi:

```bash
SOURCE_DIRS="/etc /home /var/www"
```

---

## 🗂️ Lokasi Penting

- Snapshot: `/snapshots`
- Exclude list: `/etc/snapshot_excludes.list`
- Perintah:
  - `/usr/local/bin/server-snapshot`
  - `/usr/local/bin/server-restore`

---

## 🧪 Contoh Output

```bash
$ sudo server-snapshot
Membuat snapshot seluruh sistem...
Snapshot berhasil dibuat di:
/snapshots/2025-07-06_15-00-00
```

---

## 🙏 Kontribusi & Lisensi

Proyek open-source bebas digunakan dan dimodifikasi.  
Silakan fork, modifikasi, atau kolaborasi 👍

Lisensi: MIT

---
