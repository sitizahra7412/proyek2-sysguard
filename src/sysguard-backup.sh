LOG_FILE="$(dirname "$0")/../logs/sysguard.log"
mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
local type="$1"
local message="$2"
printf '[%s] [%s] %s\n' "$(date +'%Y-%m-%d %H:%M:%S')" "$type" "$message" | tee -a "$LOG_FILE"
}
if [ "$#" -lt 2 ]; then
printf 'Error: Parameter kurang! Penggunaan: %s <dir_sumber> <dir_tujuan>\n' "$0" >&2
log_message "ERROR" "Eksekusi gagal: Parameter kurang dari 2."
exit 1
fi

SRC_DIR="$1"
DEST_DIR="$2"

if [ ! -d "$SRC_DIR" ]; then
printf 'Error: Direktori sumber "%s" tidak ditemukan!\n' "$SRC_DIR" >&2
log_message "ERROR" "Eksekusi gagal: Direktori $SRC_DIR tidak ditemukan."
exit 2
fi

mkdir -p "$DEST_DIR"
BACKUP_NAME="backup_$(date +'%Y%m%d_%H%M%S').tar.gz"
log_message "INFO" "Memulai pengarsipan dari $SRC_DIR ke $DEST_DIR/$BACKUP_NAME..."

if tar -czf "$DEST_DIR/$BACKUP_NAME" -C "$SRC_DIR" . 2>/dev/null; then
log_message "SUCCESS" "Backup berhasil dibuat: $DEST_DIR/$BACKUP_NAME"
printf 'Proses pengarsipan selesai dengan sukses.\n'
exit 0
else
log_message "ERROR" "Gagal membuat berkas arsip tar."
printf 'Error: Gagal membuat arsip.\n' >&2
exit 3
fi
