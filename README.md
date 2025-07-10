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
- 请将所有文件解压至具有可执行权限的目录（如 `/data/local/tmp/`）。
- 此脚本未在所有环境下测试，请仔细检查执行结果。
- 如遇 "修补失败"、"打包失败" 等提示，请勿刷入。

**❗使用本工具存在变砖风险，请确保已备份重要数据，并具备恢复设备的能力。**

## ❓ 常见问题

### 如何确认 ReKernel 是否已经修补成功

你可以通过以下三种方法来判断 ReKernel 是否修补成功：

#### （1）查看内核日志

在终端使用 Root 用户权限执行以下命令：

```bash
dmesg | grep Re:Kernel
```

如果看到类似下面的日志信息，说明 ReKernel 修补成功：

```bash
[    0.081653] [+] KP D     description: Re:Kernel, support 4.4 ~ 6.1
[    4.215369] Created Re:Kernel server! NETLINK UNIT: 26
```

#### （2）查看端口文件

修补成功后，你可以在 `/proc/rekernel/` 目录下看到一个文件，通常是 `26` 或 `22`，如能找到该文件，说明修补正常。

#### （3）通过墓碑应用来查看

使用墓碑应用查看是否有 ReKernel 的相关信息，正常情况下，日志会显示如下信息（以 NoActive 为例）：

```bash
2025-04-22 02:21:47 [信息] 屏蔽Millet远程调用成功
2025-04-22 02:21:50 [信息] 屏蔽加载用户最近任务成功
2025-04-22 02:22:31 [信息] ReKernel通用Binder通知正常
2025-04-22 02:22:31 [信息] 取消监听Millet成功
```

**如果上述三种方法都未能确认 ReKernel 的存在，说明该设备无法使用该方法获得 ReKernel。可能原因是内核拦截或魔改过于严重。已知 vivo 设备无法通过该方法获得 ReKernel，后续可能会出现更多类似的设备。**

## ❤️ 感谢以下项目

-  [Magisk](https://github.com/topjohnwu/Magisk)
-  [KernelPatch](https://github.com/bmax121/KernelPatch)
-  [Re-Kernel](https://github.com/Sakion-Team/Re-Kernel)
-  [Apatch](https://github.com/bmax121/APatch)
-  [APatch_kpm](https://github.com/lzghzr/APatch_kpm)
