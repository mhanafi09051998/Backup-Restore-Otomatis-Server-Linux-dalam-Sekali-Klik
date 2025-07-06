#!/bin/bash

# ==============================================================================
# Skrip Instalasi untuk Perintah Snapshot & Restore Server
# ==============================================================================
# Deskripsi:
# Skrip ini akan menginstal dua perintah baru di sistem Anda:
# 1. server-snapshot : Untuk membuat cadangan file server (default seluruh sistem).
# 2. server-restore : Untuk mengembalikan file dari cadangan terakhir.
#
# Skrip ini harus dijalankan dengan hak akses root (sudo).
# ==============================================================================

# -- Variabel Konfigurasi --
SNAPSHOT_BASE_DIR="/snapshots"
INSTALL_PATH="/usr/local/bin"
SNAPSHOT_CMD="server-snapshot"
RESTORE_CMD="server-restore"
EXCLUDE_FILE="/etc/snapshot_excludes.list"

# --- Pengecekan Hak Akses ---
if [ "$(id -u)" -ne 0 ]; then
  echo "Skrip ini harus dijalankan sebagai root atau dengan sudo." >&2
  echo "Contoh: sudo ./install.sh" >&2
  exit 1
fi

# --- Mulai Instalasi ---
echo "Memulai instalasi perintah snapshot server..."

# 1. Membuat direktori utama untuk snapshot
echo "-> Membuat direktori snapshot di $SNAPSHOT_BASE_DIR..."
mkdir -p "$SNAPSHOT_BASE_DIR"
if [ $? -ne 0 ]; then
    echo "Gagal membuat direktori $SNAPSHOT_BASE_DIR. Instalasi dibatalkan."
    exit 1
fi

# 2. Membuat file daftar pengecualian (exclude list)
echo "-> Membuat file pengecualian di $EXCLUDE_FILE..."
cat << EOF > "$EXCLUDE_FILE"
/dev/*
/proc/*
/sys/*
/tmp/*
/run/*
/mnt/*
/media/*
/lost+found
$SNAPSHOT_BASE_DIR/*
EOF

# 3. Membuat skrip perintah 'server-snapshot'
echo "-> Membuat perintah '$SNAPSHOT_CMD' di $INSTALL_PATH..."
cat << 'EOF' > "$INSTALL_PATH/$SNAPSHOT_CMD"
#!/bin/bash
SOURCE_DIRS="/"
SNAPSHOT_BASE_DIR="/snapshots"
EXCLUDE_FILE="/etc/snapshot_excludes.list"

echo "Membuat snapshot seluruh sistem..."
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
DESTINATION="$SNAPSHOT_BASE_DIR/$TIMESTAMP"
mkdir -p "$DESTINATION"
rsync -aAX --delete --exclude-from="$EXCLUDE_FILE" $SOURCE_DIRS "$DESTINATION/"
if [ $? -eq 0 ]; then
  echo ""
  echo "Snapshot berhasil dibuat di:"
  echo "$DESTINATION"
else
  echo ""
  echo "Terjadi kesalahan saat membuat snapshot."
  rm -rf "$DESTINATION"
fi
EOF

# 4. Membuat skrip perintah 'server-restore'
echo "-> Membuat perintah '$RESTORE_CMD' di $INSTALL_PATH..."
cat << 'EOF' > "$INSTALL_PATH/$RESTORE_CMD"
#!/bin/bash
SNAPSHOT_BASE_DIR="/snapshots"

echo "Mencari snapshot terakhir untuk proses restore..."
LATEST_SNAPSHOT=$(ls -1d $SNAPSHOT_BASE_DIR/*/ | sort -r | head -n 1)
if [ -z "$LATEST_SNAPSHOT" ]; then
  echo "Tidak ada snapshot yang ditemukan di $SNAPSHOT_BASE_DIR."
  exit 1
fi

echo "Snapshot terakhir yang ditemukan adalah: $LATEST_SNAPSHOT"
echo ""
echo "PERINGATAN: Proses ini akan menimpa file-file yang ada di server Anda"
echo "dengan file dari snapshot. Perubahan yang dibuat setelah snapshot"
echo "tersebut akan hilang. INI AKAN MENGEMBALIKAN KESELURUHAN SISTEM."
echo ""
read -p "Ketik 'YES' untuk melanjutkan proses restore: " CONFIRM
if [ "$CONFIRM" != "YES" ]; then
  echo "Proses restore dibatalkan."
  exit 0
fi

echo "Memulai proses restore. Ini mungkin memakan waktu..."
rsync -aAX --delete "$LATEST_SNAPSHOT" /
if [ $? -eq 0 ]; then
  echo ""
  echo "Proses restore dari $LATEST_SNAPSHOT telah selesai."
else
  echo ""
  echo "Terjadi kesalahan saat melakukan restore."
fi
EOF

# 5. Memberikan izin eksekusi
echo "-> Memberikan izin eksekusi..."
chmod +x "$INSTALL_PATH/$SNAPSHOT_CMD"
chmod +x "$INSTALL_PATH/$RESTORE_CMD"

# --- Selesai ---
echo ""
echo "======================================================"
echo "Instalasi Selesai!"
echo "======================================================"
echo ""
echo "Dua perintah baru telah ditambahkan ke sistem Anda:"
echo "  1. server-snapshot -> Untuk membuat cadangan KESELURUHAN sistem."
echo "  2. server-restore  -> Untuk mengembalikan dari cadangan terakhir."
echo ""
echo "CATATAN PENTING:"
echo "Secara default, perintah 'server-snapshot' akan mencadangkan SELURUH sistem Anda (dari '/')."
echo "Ini sudah diatur untuk Anda."
echo "Jika Anda ingin mengubahnya untuk mencadangkan direktori tertentu saja,"
echo "Anda dapat mengedit file '$INSTALL_PATH/$SNAPSHOT_CMD'."
echo "Contoh: sudo nano $INSTALL_PATH/$SNAPSHOT_CMD"
echo ""
