#!/bin/bash
# Convert a segment of a video file to an animated WebP.
# Usage: ./video_to_webp.sh <input> [-s start] [-d duration] [-f fps] [-w width] [-q quality] [-l loop] [-o output]

set -euo pipefail

# Load defaults from config file
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$SCRIPT_DIR/config.conf"
if [[ -f "$CONFIG" ]]; then
  source "$CONFIG"
fi

# Fallbacks if config is missing values
START="${START:-0}"
DURATION="${DURATION:-5}"
FPS="${FPS:-15}"
WIDTH="${WIDTH:-480}"
QUALITY="${QUALITY:-80}"
LOOP="${LOOP:-0}"
OUTPUT=""

usage() {
  cat <<EOF
Usage: $(basename "$0") <input> [options]

Options:
  -s  Start time in seconds (default: $START)
  -d  Duration in seconds (default: $DURATION)
  -f  Frames per second (default: $FPS)
  -w  Width in pixels, height auto-scales (default: $WIDTH)
  -q  WebP quality 1-100 (default: $QUALITY)
  -l  Loop count, 0 = infinite (default: $LOOP)
  -o  Output file (default: <input>_clip.webp)
EOF
  exit 1
}

[[ $# -lt 1 ]] && usage

INPUT="$1"
shift

while getopts "s:d:f:w:q:l:o:h" opt; do
  case "$opt" in
  s) START="$OPTARG" ;;
  d) DURATION="$OPTARG" ;;
  f) FPS="$OPTARG" ;;
  w) WIDTH="$OPTARG" ;;
  q) QUALITY="$OPTARG" ;;
  l) LOOP="$OPTARG" ;;
  o) OUTPUT="$OPTARG" ;;
  h | *) usage ;;
  esac
done

if [[ ! -f "$INPUT" ]]; then
  echo "Error: file not found: $INPUT" >&2
  exit 1
fi

EXPORT_DIR="$SCRIPT_DIR/exports"
mkdir -p "$EXPORT_DIR"

if [[ -z "$OUTPUT" ]]; then
  BASENAME="$(basename "${INPUT%.*}")"
  OUTPUT="$EXPORT_DIR/${BASENAME}_clip.webp"
fi

echo "Input:    $INPUT"
echo "Segment:  ${START}s + ${DURATION}s"
echo "FPS:      $FPS"
echo "Width:    $WIDTH"
echo "Quality:  $QUALITY"
echo "Output:   $OUTPUT"

ffmpeg -y -ss "$START" -i "$INPUT" -t "$DURATION" \
  -vf "fps=$FPS,scale=$WIDTH:-1" \
  -vcodec libwebp -lossless 0 -compression_level 4 \
  -q:v "$QUALITY" -loop "$LOOP" \
  -an "$OUTPUT"

SIZE=$(du -h "$OUTPUT" | cut -f1)
echo "Saved $OUTPUT ($SIZE)"
