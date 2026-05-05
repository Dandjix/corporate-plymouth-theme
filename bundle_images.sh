#!/usr/bin/env bash
set -euo pipefail

# ── paths ────────────────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
IMAGES_DIR="$SCRIPT_DIR/images"
WORK_DIR="$SCRIPT_DIR/.bundle_tmp"
OUTPUT_ARCHIVE="$SCRIPT_DIR/images.tar.gz"

# ── helpers ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# ── pre-flight checks ────────────────────────────────────────────────────────
if [[ ! -d "$IMAGES_DIR" ]]; then
  error "Folder '$IMAGES_DIR' not found next to the script."
  exit 1
fi

if ! command -v gimp &>/dev/null; then
  error "GIMP is not installed or not in PATH."
  exit 1
fi

if ! command -v file &>/dev/null; then
  error "'file' command is required but not found."
  exit 1
fi

# ── collect files & validate ─────────────────────────────────────────────────
mapfile -t ALL_FILES < <(find "$IMAGES_DIR" -maxdepth 1 -type f | sort)

if [[ ${#ALL_FILES[@]} -eq 0 ]]; then
  error "The images folder is empty."
  exit 1
fi

info "Validating ${#ALL_FILES[@]} file(s) in '$IMAGES_DIR' …"
BAD_FILES=()
VALID_FILES=()

for f in "${ALL_FILES[@]}"; do
  mime="$(file --brief --mime-type "$f")"
  if [[ "$mime" == image/* ]]; then
    VALID_FILES+=("$f")
  else
    BAD_FILES+=("$f")
  fi
done

if [[ ${#BAD_FILES[@]} -gt 0 ]]; then
  error "The following file(s) are NOT images:"
  for bf in "${BAD_FILES[@]}"; do
    error "  • $(basename "$bf")  ($(file --brief --mime-type "$bf"))"
  done
  exit 1
fi

info "All ${#VALID_FILES[@]} file(s) are valid images."

# ── prepare work directory ───────────────────────────────────────────────────
rm -rf "$WORK_DIR"
mkdir -p "$WORK_DIR"

# ── build GIMP Script-Fu batch ───────────────────────────────────────────────
# We feed one big Script-Fu expression to gimp -b so we only launch GIMP once.
SCRIPT_FU="(let* () "
INDEX=1
for f in "${VALID_FILES[@]}"; do
  OUT="$WORK_DIR/${INDEX}.png"
  # Escape the path for Scheme strings
  ESC_IN="${f//\\/\\\\}"
  ESC_IN="${ESC_IN//\"/\\\"}"
  ESC_OUT="${OUT//\\/\\\\}"
  ESC_OUT="${ESC_OUT//\"/\\\"}"

  SCRIPT_FU+="
    (let* (
      (image    (car (gimp-file-load RUN-NONINTERACTIVE \"${ESC_IN}\" \"${ESC_IN}\")))
      (orig-w   (car (gimp-image-width  image)))
      (orig-h   (car (gimp-image-height image)))
      (scale    (min (/ 224 orig-w) (/ 224 orig-h)))
      (new-w    (round (* orig-w scale)))
      (new-h    (round (* orig-h scale)))
    )
      (gimp-image-scale-full image new-w new-h INTERPOLATION-LINEAR)
      (file-png-save RUN-NONINTERACTIVE image
                     (car (gimp-image-get-active-drawable image))
                     \"${ESC_OUT}\" \"${ESC_OUT}\"
                     0 9 1 1 1 1 1)
      (gimp-image-delete image)
    )"
  (( INDEX++ ))
done
SCRIPT_FU+=" (gimp-quit 0))"

info "Launching GIMP to resize & export ${#VALID_FILES[@]} image(s) (max 224×224, aspect ratio preserved) …"
gimp -i -b "$SCRIPT_FU" 2>/dev/null

# ── verify output & warn on missing ─────────────────────────────────────────
TOTAL=${#VALID_FILES[@]}
MISSING=0
for (( i=1; i<=TOTAL; i++ )); do
  if [[ ! -f "$WORK_DIR/${i}.png" ]]; then
    warn "Output missing for image #${i}"
    (( MISSING++ ))
  fi
done

if [[ $MISSING -gt 0 ]]; then
  error "$MISSING output file(s) were not produced by GIMP."
  exit 1
fi

info "All images exported: 1.png … ${TOTAL}.png"

# ── create archive ────────────────────────────────────────────────────────────
info "Creating archive '$OUTPUT_ARCHIVE' …"
tar -czf "$OUTPUT_ARCHIVE" -C "$WORK_DIR" .

# ── cleanup ───────────────────────────────────────────────────────────────────
rm -rf "$WORK_DIR"

info "Done!  Archive: $OUTPUT_ARCHIVE  (${TOTAL} image(s))"