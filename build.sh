#!system//bin/sh

MODDIR="${0%/*}"

# 自定义密钥
key="aqmJau7K"

# 完整性检验文件
REQUIRED_ITEMS="
README.md
build.sh
clean.sh
kpm/kpimg-android
kpm/kptools-android
kpm/re_kernel_6.0.11.kpm
magiskboot
"

# 检查完整性
MISSING_ITEMS=""
for item in $REQUIRED_ITEMS; do
	if [ ! -e "$MODDIR/$item" ]; then
		MISSING_ITEMS="$MISSING_ITEMS\n[x] 缺失: $item"
	fi
done

# 输出完整性校验结果
if [ -n "$MISSING_ITEMS" ]; then
	printf "[!] 检查失败，以下文件/目录缺失：%b\n" "$MISSING_ITEMS"
	echo "[!] 完整性校验失败，请确认文件是否损坏"
	echo "[!] 如果下载文件出现了损坏，请重新下载"
	echo "[x] 脚本已退出"
	exit 1
else
	echo "[✓] 完整性校验已通过，继续执行..."
fi

# 检查 boot 是否存在
if [ ! -f "boot.img" ]; then
	echo "[!] 当前目录下未找到 boot.img"
	echo "[x] 脚本已退出，请认真阅读 README.md"
	exit 1
fi

# 判断是否处于拥有可执行权限的目录下
if echo "$MODDIR" | grep -qE "sdcard|storage/emulated"; then
	echo "[!] 请勿在 sdcard 以及它的子目录下执行该脚本"
	echo "[x] 脚本已退出，请认真阅读 README.md"
	exit 1
elif [ ! -x . ]; then
	echo "[x] 当前目录没有可执行权限，请使用其他目录"
	echo "[x] 脚本已退出，请认真阅读 README.md"
	exit 1
else
	echo "[✓] 当前处于拥有可执行权限目录下，继续执行..."
fi

# 解包 boot
echo "[-] 正在解包 boot 获取 kernel"
./magiskboot unpack boot.img >/dev/null 2>&1
[ -e "kernel" ] && echo "[✓] 已成功获取 kernel"
cp kernel kpm/
cd kpm

# 修补 Kernel
echo "[-] 正在对 kernel 执行修补"
./kptools-android -p -i kernel -k kpimg-android -M re_kernel_6.0.11.kpm -V pre-kernel-init -T kpm -s $key -o patched_kernel
is_rekernel=$(./kptools-android -l -i patched_kernel)
[ -e "patched_kernel" ] && echo "[✓] Kernel 修补已完成"
if echo "$is_rekernel" | grep -qE "re_kernel"; then
	echo "[✓] ReKernel 已成功修补进你的内核！"
else
	echo "[x] ReKernel 修补失败，脚本已退出"
	cd ..
	sh clean.sh
	echo "[x] 已清理修补产生的文件，尝试重新修补"
	exit 1
fi

cp -f patched_kernel ../kernel
cd ..

# 打包 boot
echo "[-] 正在打包 boot"
./magiskboot repack boot.img >/dev/null 2>&1
[ -e "new-boot.img" ] && echo "[✓] boot 已打包成功"
echo "[✓] 脚本已执行完毕，请确认当前目录下是否存在 new-boot.img"
echo "[✓] 最后刷入 new-boot.img，即可获得 Rekernel"
exit 1
