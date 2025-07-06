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
