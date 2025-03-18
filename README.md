# ReKPatch

## 项目介绍

本项目使用 Magiskboot 解包 boot.img 获取 Kernel，并通过 kptools 修补 KPM 为 Kernel 增加 ReKernel KPM 功能。

## 🔧 修补说明

1. 从当前设备提取 boot 镜像，并将其命名为 boot.img。
2. 将 boot.img 放入此目录下。
3. 运行 build.sh 脚本完成修补过程。
4. 运行完成后，new-boot.img 应出现在当前目录中。
5. 使用 Fastboot 或其他工具刷入 new-boot.img 以获得带有 ReKernel KPM 的 boot。

## 🧹 清理说明

若需清理修补过程中产生的文件，运行 clean.sh 即可。

## 🔑 密钥说明

您可以在 build.sh 中修改 key 变量以更改密钥。

默认密钥（建议修改以提升安全性）：`aqmJau7K`

## ⚠️ 注意事项

- 请勿直接在压缩包内运行脚本。
- 请不要在 `/sdcard/` 以及它的子目录下执行。
- 请将所有文件解压至具有可执行权限的目录（如 `/data/tmp/`）。
- 此脚本未在所有环境下测试，请仔细检查执行结果。
- 如遇 "修补失败"、"打包失败" 等提示，请勿刷入。

### ❗使用本工具存在变砖风险，请确保已备份重要数据，并具备恢复设备的能力。

## ❤️ 感谢以下项目

-  [Magisk/magiskboot](https://github.com/topjohnwu/Magisk)
-  [KernelPatch](https://github.com/bmax121/KernelPatch)
-  [Re-Kernel](https://github.com/Sakion-Team/Re-Kernel)
-  [Apatch](https://github.com/bmax121/APatch)
-  [APatch_kpm](https://github.com/lzghzr/APatch_kpm)
