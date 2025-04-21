MODDIR="${0%/*}"

# 判断并删除当前目录下的文件
[ -e "$MODDIR/magiskboot/kernel" ] && rm "$MODDIR/magiskboot/kernel"
[ -e "$MODDIR/magiskboot/new-boot.img" ] && rm "$MODDIR/magiskboot/new-boot.img"
[ -e "$MODDIR/magiskboot/ramdisk.cpio" ] && rm "$MODDIR/magiskboot/ramdisk.cpio"

# 判断并删除 MODDIR/kpm 目录下的文件
[ -e "$MODDIR/kpm/patched_kernel" ] && rm "$MODDIR/kpm/patched_kernel"
[ -e "$MODDIR/kpm/kernel" ] && rm "$MODDIR/kpm/kernel"

echo "[✓] 已成功清理修补产生的文件"
