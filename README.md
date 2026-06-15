# WEBP Animation Creator

Convert a segment of a video file to an animated WebP.

## Dependencies

- ffmpeg

## Usage

```bash
./video_to_webp.sh <input> [options]
```

### Examples

```bash
# Convert first 5 seconds using config defaults
./video_to_webp.sh clips/clip1.mkv

# Override start time and duration
./video_to_webp.sh clips/clip1.mkv -s 30 -d 10

# Custom output path, resolution and quality
./video_to_webp.sh clips/clip1.mkv -s 30 -d 10 -w 640 -q 90 -o exports/custom.webp
```

### Options

| Flag | Description              | Default              |
| ---- | ------------------------ | -------------------- |
| `-s` | Start time in seconds    | `0`                  |
| `-d` | Duration in seconds      | `5`                  |
| `-f` | Frames per second        | `15`                 |
| `-w` | Width (height auto-scales) | `480`              |
| `-q` | WebP quality (1-100)     | `80`                 |
| `-l` | Loop count (0 = infinite)| `0`                  |
| `-o` | Output file path         | `exports/<input>_clip.webp` |

## Configuration

Edit `config.conf` to change default values:

```conf
START=0
DURATION=5
FPS=15
WIDTH=480
QUALITY=80
LOOP=0
```

Command-line flags override config values.

## Output

Animated WebP files are saved to the `exports/` directory by default.

## Project Structure

```
clips/          # source video files
exports/        # output animations
config.conf     # default parameters
video_to_webp.sh
```
