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

# 音量键检测
key_check() {
	while true; do
		key_check=$(/system/bin/getevent -qlc 1)
		key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
		key_status=$(echo "$key_check" | awk '{ print $4 }')
		if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
			keycheck="$key_event"
			break
		fi
	done
	while true; do
		key_check=$(/system/bin/getevent -qlc 1)
		key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
		key_status=$(echo "$key_check" | awk '{ print $4 }')
		if [[ "$key_event" == *"KEY_"* && "$key_status" == "UP" ]]; then
			break
		fi
	done
	echo "$keycheck"
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
	./kptools-android -p -i kernel -k kpimg-linux -M $1.kpm -V pre-kernel-init -T kpm -s $key -o patched_kernel
	is_rekernel=$(./kptools-android -l -i patched_kernel)
	[ -e "patched_kernel" ] && echo "[✓] Kernel 修补已完成"
	if echo "$is_rekernel" | grep -qE "re_kernel"; then
		echo "[✓] $kpm 已成功修补进你的内核！"
	else
		echo "[x] $kpm 修补失败，脚本已退出"
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
	echo "[=] 请按音量键选择修补是否带网络解冻的版本"
	echo "[?] 如果你不知道你使用的墓碑是否拥有网络解冻功能，请阅读你使用的墓碑文档"
	echo "[+] 音量 +，ReKernel (无网络解冻)"
	echo "[-] 音量 -，ReKernel_network (带网络解冻)"
	key_event=$(key_check)
	if [ "$key_event" == "KEY_VOLUMEUP" ]; then
		echo "你按了音量上键，开始修补 Re-kernel"
		kpm="Re-Kernel"
	elif [ "$key_event" == "KEY_VOLUMEDOWN" ]; then
		echo "你按了音量下键，开始修补 Re-kernel(network)"
		kpm="Re-Kernel_network"
	else
		echo "未检测到你按的音量键，脚本退出"
		echo "如果你认为这是一个问题请提交 issue"
		echo "key_event = $key_event"
		exit 1
	fi
	boot_unpack
	Kernel_patching $kpm
	boot_repack
	exit 0
}

main
