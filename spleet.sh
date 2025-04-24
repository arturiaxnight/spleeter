#!/bin/bash

# 檢查是否提供了輸入檔案參數
if [ -z "$1" ]; then
  echo "用法: $0 <輸入 MP3 檔案>"
  exit 1
fi

# 輸入的 MP3 檔案路徑 (取得絕對路徑)
INPUT_FILE_ARG="$1"
INPUT_FILE_ABS_PATH=$(realpath "$INPUT_FILE_ARG")

# 檢查輸入檔案是否存在
if [ ! -f "$INPUT_FILE_ABS_PATH" ]; then
  echo "錯誤: 輸入檔案 '$INPUT_FILE_ARG' (解析為 '$INPUT_FILE_ABS_PATH') 不存在。"
  exit 1
fi

# 建立輸出目錄 (如果不存在)
OUTPUT_DIR="$(pwd)/output"
mkdir -p "$OUTPUT_DIR"

# 容器內固定的輸入檔案路徑
CONTAINER_INPUT_PATH="/input/audio.mp3"

# 執行 Docker 命令
echo "正在處理檔案: $INPUT_FILE_ARG"
docker run --rm --gpus all \
  -v "$OUTPUT_DIR:/output" \
  -v "$INPUT_FILE_ABS_PATH:$CONTAINER_INPUT_PATH:ro" \
  deezer/spleeter-gpu:3.8-5stems separate -p spleeter:5stems -o /output "$CONTAINER_INPUT_PATH"

echo "處理完成，輸出檔案位於 $OUTPUT_DIR 目錄中。" 