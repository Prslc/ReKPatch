#!system//bin/sh

MODDIR="${0%/*}"

# 自定义密钥
key="aqmJau7K"

Basic_Check() {
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
}

# 解包 boot
boot_unpack() {
	echo "[-] 正在解包 boot 获取 kernel"
	./magiskboot unpack boot.img >/dev/null 2>&1
	[ -e "kernel" ] && echo "[✓] 已成功获取 kernel"
	cp kernel kpm/
	cd kpm
}

# 修补 Kernel
Kernel_patching() {
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
}

boot_repack() {
	echo "[-] 正在打包 boot"
	./magiskboot repack boot.img >/dev/null 2>&1
	[ -e "new-boot.img" ] && echo "[✓] boot 已打包成功"
	echo "[✓] 脚本已执行完毕，请确认当前目录下是否存在 new-boot.img"
	echo "[✓] 最后刷入 new-boot.img，即可获得 Rekernel"
}

main() {
	Basic_Check
	boot_unpack
	Kernel_patching
	boot_repack
	exit 0
}

main
