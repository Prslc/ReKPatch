MODDIR="${0%/*}"

# 判断并删除当前目录下的文件
[ -e "kernel" ] && rm "kernel"
[ -e "new-boot.img" ] && rm "new-boot.img"
[ -e "ramdisk.cpio" ] && rm "ramdisk.cpio"

# 判断并删除 MODDIR/kpm 目录下的文件
[ -e "$MODDIR/kpm/patched_kernel" ] && rm "$MODDIR/kpm/patched_kernel"
[ -e "$MODDIR/kpm/kernel" ] && rm "$MODDIR/kpm/kernel"

echo "[✓] 已成功清理修补产生的文件"