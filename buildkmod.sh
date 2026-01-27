# 提取并打包 kmod 软件源
if [ -f "$BASE_PATH/extract_kmod_repo.sh" ]; then
  chmod +x "$BASE_PATH/extract_kmod_repo.sh"
  "$BASE_PATH/extract_kmod_repo.sh" "$BASE_PATH/$BUILD_DIR"
fi
# 复制 kmod 压缩包到 firmware 目录，便于发布
find "$BASE_PATH/$BUILD_DIR/bin/targets/qualcommax/ipq60xx" -name "kmod-repo-*.tar.gz" -exec cp {} "$FIRMWARE_DIR/" \;

if [[ -d $BASE_PATH/action_build ]]; then
    make clean
fi
