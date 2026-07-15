# Compilation of BShield Security Checks & Detection Mechanisms on Android

This document lists all known BShield security checks and detection mechanisms on Android devices, along with possible bypass methods as of July 15th, 2026. If you discover additional detection mechanisms, feel free to report them in the Issues tab.

> [!CAUTION]
> **This project is for educational purposes only. The goal is to highlight weaknesses in current security solutions and encourage the development of better, more reliable alternatives. Use this information responsibly. DO NOT use it for malicious purposes. I am not responsible for any actions taken by users of this module or project.**

**Table of Contents:**

<!-- TOC -->
- [JNI Crash in A16 QPR1 device or newer version (app immediately crash)](#jni-crash-in-a16-qpr1-device-or-newer-version-app-immediately-crash)
- [Error Code 1 (Modified Application Detected)](#error-code-1-modified-application-detected)
- [Error Code 2 (Virtual Machine / Emulator Detected)](#error-code-2-virtual-machine--emulator-detected)
- [Error Code 3 (Application List Detection and PIF inject by KOW)](#error-code-3-application-list-detection-and-pif-inject-by-kow)
- [Error Code 4 (Debug Tool Detection, Rare)](#error-code-4-debug-tool-detection-rare)
- [Error Code 5 (Root Detection)](#error-code-5-root-detection)
  - [System Properties](#system-properties)
  - [Injected Memory Map Detection](#injected-memory-map-detection)
  - [Kernel Enforcing Status](#kernel-enforcing-status)
  - [Root Manager Package Name Detection](#root-manager-package-name-detection)
  - [Custom Launcher Modification Module Detection](#custom-launcher-modification-module-detection)
  - [Bootloader Unlock Check](#bootloader-unlock-check)
  - [Suspicious Mounts](#suspicious-mounts)
  - [[UNCONFIRMED] KSU/AP Module Proc Image Loop Detection](#unconfirmed-ksuap-module-proc-image-loop-detection)
- [Error Code 6 (Unlocked Bootloader Detected) Currently Unused or Possibly Merged into Code 5 Bootloader Check](#error-code-6-unlocked-bootloader-detected-currently-unused-or-possibly-merged-into-code-5-bootloader-check)
- [Error Code 7 (Suspicious Application Detected) Rarely Appears](#error-code-7-suspicious-application-detected-rarely-appears)
- [Error Code 8 (Application Running in a Different Space Than the Original Device Space)](#error-code-8-application-running-in-a-different-space-than-the-original-device-space)
- [Error Code 10 (ADB Debug Mode Detected)](#error-code-10-adb-debug-mode-detected)
- [Error Code 11 (Developer Mode Detected)](#error-code-11-developer-mode-detected)
- [Error Code 12 (Custom ROM Detected)](#error-code-12-custom-rom-detected)
- [Error Code 13 (Accessibility Service Running Detected)](#error-code-13-accessibility-service-running-detected)
- [Error Code 14 (Application Installed from Unknown Source Detected)](#error-code-14-application-installed-from-unknown-source-detected)
- [Error Code 15 (Malicious Application Detected)](#error-code-15-malicious-application-detected)
- [Error Code 16 (Virtual Keyboard Not in Trusted List)](#error-code-16-virtual-keyboard-not-in-trusted-list)
- [Error Code 17 (Application Installed in Work Profile)](#error-code-17-application-installed-in-work-profile)
- [Error Code 18 (Simulated Input Detected)](#error-code-18-simulated-input-detected)
- [Error Code 19 (Proxy Mode Enabled on Device)](#error-code-19-proxy-mode-enabled-on-device)
- [Error Code 20 (Application Does Not Support MacOS)](#error-code-20-application-does-not-support-macos)
- [Error Code 21 (Possible Root Compromise Detected)](#error-code-21-possible-root-compromise-detected)
- [Error Code 22 (System Hook Detected)](#error-code-22-system-hook-detected)
- [Error Code 23 (VPN Connection Detected)](#error-code-23-vpn-connection-detected)
<!-- /TOC -->

## JNI Crash in A16 QPR1 device or newer version (app immediately crash)

> [!NOTE]
> Recently, we noticed a weird crash on BShield when we update android version to A16 QPR1+. After 3 months of research, we can finally find the first cause for this problem is from old custom recovery. 
>
> In A16 QPR1+ update, we believe how A16 QPR1 handles storage now different from older recovery which causing a problem not only BShield but also other apps.
>
> If you know more about this JNI crash, let us know in the [Issues](https://github.com/DeepLunaria/BShieldExperimentation) tab.

This crash occurs when device use older custom recovery to flash A16 QPR1+ rom, kernel,....

If you're already flash A16 QPR1+ with old custom recovery, we suggest you have to clean flash the ROM using recovery that comes with ROM to resolve the issue.

## Error Code 1 (Modified Application Detected)

**Reference link:** <https://s.bshield.io/?code=1>

This error occurs when you install an application using BShield protection mechanisms that has not been signed or has been modified. For developers who patched the application, I currently have not found a working method to make it function properly. You may try, but it will be extremely difficult to succeed.

**Fix:**  
Uninstall the modified or unsigned application using BShield protection from your system and reinstall it from Google Play.

## Error Code 2 (Virtual Machine / Emulator Detected)

**Reference link:** <https://s.bshield.io/?code=2>

This error occurs when you install the application inside a virtual machine or emulator.

**Fix:**  
Do not install the application inside a virtual machine or emulator (obviously :v).

## Error Code 3 (Application List Detection and PIF inject by KOW)

**Reference link:** <https://s.bshield.io/?code=3>

This error occurs when you install a root manager, suspicious applications, LSPosed modules or using PIF Inject on your current device. 

Below is a list of applications currently detected by BShield (there may be more; these are only the ones confirmed through testing. You can request updates in the Issues tab):

```txt
com.topjohnwu.magisk
com.drdisagree.iconify
<most lsposed modules>
```

**Fix:**
Use the following KSU/Magisk and LSPosed modules (preferably FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

to hide these applications.

Or, if you do not use root, simply avoid installing root managers on the device.

## Error Code 4 (Debug Tool Detection, Rare)

**Reference link:** <https://s.bshield.io/?code=4>

This error occurs when running applications protected by BShield using Google's debugging tools. This error does not appear in production builds of the application. If you encounter this issue, contact the application developer or report it to me.

## Error Code 5 (Root Detection)

**Reference link:** <https://s.bshield.io/?code=5>

This is the hardest BShield detection mechanism to bypass when using rooted devices or devices running custom ROMs. It includes multiple root detection methods and various system property checks. Below are some confirmed mechanisms:

### System Properties

BShield detects the following Android system properties (commonly found in AOSP custom ROMs). Known examples include:

- `init.svc.adb_root`
- `service.adb.root`

**Fix:**
These properties can be fixed by overriding them, for example:

```sh
resetprop -n -p init.svc.adb_root ""
resetprop -n -p service.adb.root ""
```

**Note:** These properties will revert after reboot. You can use my module from the Releases tab to automatically apply the fix after each boot.

### Injected Memory Map Detection

BShield detects whether memory maps have been injected.

You can check this using the **Native Detector** tool ([download here](https://github.com/reveny/Android-Native-Root-Detector/releases/latest)).

For example, it may report an "Injection Detection" error.

**Some possible fixes:**

- If your kernel supports KernelSU + SuSFS (with SUS_MAP enabled), you can add the detected injected memory map paths to the SuSFS map list (SUS_MAP).
- If you use a font replacement module, it may also cause injected memory maps. Remove it or add its paths to SUS_MAP as mentioned above.
- You may also try Pedro's TreatWheel module to hide injected memory maps, though its effectiveness is limited compared to SUS_MAP and it requires ReZygisk.

**Note regarding `/system/framework/framework-res.apk` memory map detection**

You may see **Found Injection** in **Native Detector**, with results similar to:

```txt
7982fef000-7983031000 r--s 00000000 fd:00 1549 /system/framework/framework-res.apk
7988432000-7988448000 r--s 00344000 fd:01 1631 /system/framework/framework-res.apk
7988538000-7988546000 r--s 00000000 fd:03 3165 /system/framework/framework-res.apk
798bf3d000-798bf3e000 r--s 00055000 fd:00 1549 /system/framework/framework-res.apk
798bf3e000-798bf3f000 r--s 00000000 fd:03 3166 /system/framework/framework-res.apk
798bf4d000-798bf4e000 r--s 00002000 fd:03 3166 /system/framework/framework-res.apk
798bf4e000-798bf4f000 r--s 00000000 fd:27 518  /system/framework/framework-res.apk
7992736000-799273c000 r--s 0035d000 fd:01 1631 /system/framework/framework-res.apk
7992826000-7992827000 r--s 00000000 fd:27 503  /system/framework/framework-res.apk
7992976000-799297c000 r--s 00013000 fd:03 3165 /system/framework/framework-res.apk
79929ef000-79929f0000 r--s 00000000 fd:27 500  /system/framework/framework-res.apk
```

This happens because your custom kernel may contain a patch that hides LineageOS files in `task_mmu.c`. See [reference commit (MoonWake@bea4fe4)](https://github.com/RainyXeon/moonwake_kernel_xiaomi_ruby/commit/bea4fe4ecfa41edb52f26ce9254a16643dda57ea).

The purpose of this patch is to replace actual LineageOS file paths with `framework-res.apk`. If a VMA-mapped file contains `lineage` in its name, then `/proc/<pid>/map_files/<start>-<end>` points to `framework-res.apk` instead of the real file to avoid root detection tools.

However, this mechanism is now outdated and unintentionally triggers **Found Injection** in **Native Detector**, because the fake VMA header can still be detected. This may happen because only the file path is replaced instead of the entire VMA metadata.

If you are a custom kernel developer, you can revert the commit containing the LineageOS file hiding code. If you are a user, there is nothing you can do unless you change kernels or ask the kernel developer to modify it.

### Kernel Enforcing Status

This is a common detection method. Using ROMs with **SELinux permissive** is not recommended, as they are considered insecure by modern standards.

BShield requires **SELinux** to be in **Enforcing** mode to function properly.

**Fix:**

- Set SELinux to **Enforcing**

```sh
setenforce 1
```

- Use a kernel or ROM with **SELinux Enforcing**

### Root Manager Package Name Detection

BShield checks the installed application list for applications commonly associated with root or considered suspicious, similar to [Error Code 3](#error-code-3-application-list-detection). However, for some reason, apps like `me.bmax.apatch` or `com.rifsxd.ksunext` trigger Error Code 5 instead of 3.

Detected applications:

```txt
com.topjohnwu.magisk
com.drdisagree.iconify
com.rifsxd.ksunext
me.bmax.apatch
me.weishu.kernelsu
```

**Fix:**
Use the following KSU/Magisk and LSPosed modules (preferably FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

to hide these applications.

### Custom Launcher Modification Module Detection

BShield may detect many custom launcher modification modules, possibly through mounts, memory maps, or other indicators.

**Fix:**
The easiest method is to remove the custom launcher and use the system default launcher, or use a standard launcher from the Play Store.

### Bootloader Unlock Check

I can confirm that BShield checked bootloader status in early 2026. It only checks the lock status, and AOSP keyboxes or revoked keyboxes currently still work.

**Fix:**
Install [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), then add the package name to `target.txt`:

```txt
com.vnid
```

### Suspicious Mounts

BShield has long checked mounts to detect root. This occurs when modules use mount mechanisms to modify system files.

You can check this using **Native Detector**.

For example, it may report "Suspicious Mount".

**Fix:**

- If the module ZIP contains `mount --bind`, be careful because it may trigger this error. Ask the developer to use [this alternative method](https://kernelsu.org/guide/module.html).
- KSU 3.0 and some newer versions of APatch and Magisk handle this issue better.
- On some devices, ReZygisk cannot unmount certain paths. If you encounter this issue, report it to me.

### [UNCONFIRMED] KSU/AP Module Proc Image Loop Detection

According to a recent report from [@Hzzmonet](https://t.me/Hzzmonet), BShield may detect KSU/AP proc image loops. The reason is that older KSU/AP versions used OverlayFS mount mechanisms, leading to detection.

You can check this using **Native Detector**.

For example, it may report "KSU/AP loop".

**Fix:**

- If you use the original KernelSU and older versions, use Pedro's TreatWheel module + ReZygisk to hide it.
- If you use older KernelSU-Next versions, disable the Use OverlayFS option in settings. Remember to back up modules beforehand because all modules will be removed.
- Newer original KSU v3 forks and recent APatch versions have already fixed this issue.

## Error Code 6 (Unlocked Bootloader Detected) Currently Unused or Possibly Merged into Code 5 Bootloader Check

**Reference link:** <https://s.bshield.io/?code=6>

This error occurs when the bootloader is unlocked. Currently, most applications using BShield have not enabled this detection. If it becomes active in the future, you can refer to the workaround below.

**Fix:**
Install [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), then add the package name to `target.txt`:

```txt
com.vnid
```

## Error Code 7 (Suspicious Application Detected) Rarely Appears

**Reference link:** <https://s.bshield.io/?code=7>

This error occurs when suspicious applications exist in the installed app list. Rarely encountered in practice.

**Fix:**
Same as [Error Code 3](#error-code-3-application-list-detection).

## Error Code 8 (Application Running in a Different Space Than the Original Device Space)

**Reference link:** <https://s.bshield.io/?code=8>

This error occurs when using applications protected by BShield inside private spaces or secondary spaces instead of the device's original user space.

**Fix:**
Do not run the application inside third-party space/container applications.

## Error Code 10 (ADB Debug Mode Detected)

**Reference link:** <https://s.bshield.io/?code=10>

This error occurs when ADB debugging is enabled on the device.

**Fix:**
Use the following KSU/Magisk and LSPosed modules (preferably FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

to hide ADB debugging.

## Error Code 11 (Developer Mode Detected)

**Reference link:** <https://s.bshield.io/?code=11>

This error occurs when Developer Mode is enabled on the device.

**Fix:**
Use the following KSU/Magisk and LSPosed modules (preferably FOSS):

- [ReLSPosed](https://github.com/ThePedroo/ReLSPosed)
- [HMA-OSS](https://github.com/frknkrc44/HMA-OSS)

to hide Developer Mode and ADB debugging.

Or preferably, simply disable Developer Mode when not needed.

## Error Code 12 (Custom ROM Detected)

**Reference link:** <https://s.bshield.io/?code=12>

This error occurs when using a custom ROM on the device.

Currently, FPT Shop, NCB iziMobile, and MyVIB app additionally checks this (<https://play.google.com/store/apps/details?id=vn.frt.fptshop.app&hl=vi>)

**Fix:**
Install [JingMatrix/TEESimulator](https://github.com/JingMatrix/TEESimulator), then add the package name to `target.txt`.

Based on [FPT Night-Wolf team's suggestion](https://blogs.night-wolf.io/ai-assisted-on-rasp-analysis), it appears that code 12 also check for `ro.build.display.id` and `ro.build.keys` to see if any test keys. You can use our module as a temporary fix for this issues.

## Error Code 13 (Accessibility Service Running Detected)

**Reference link:** <https://s.bshield.io/?code=13>

This error occurs when using applications that rely on accessibility services.

**Fix:**
Install [Nitsuya/DoNotTryAccessibility](https://github.com/Nitsuya/DoNotTryAccessibility), open LSPosed, then configure the DoNotTryAccessibility module to hook into `System Framework`.

## Error Code 14 (Application Installed from Unknown Source Detected)

**Reference link:** <https://s.bshield.io/?code=14>

**Fix:**

Install the app from Google Play Store or Aurora Store.

You may also try enabling `Spoof Installation Source` in `HMA-OSS`.

## Error Code 15 (Malicious Application Detected)

**Reference link:** <https://s.bshield.io/?code=15>

This error occurs when applications with malicious indicators are present on the device.

**Fix:**
We recommend reviewing your installed applications. If you do not want to uninstall the app and only want to bypass this error, refer to [Error Code 3 (Application List Detection)](#error-code-3-application-list-detection).

## Error Code 16 (Virtual Keyboard Not in Trusted List)

**Reference link:** <https://s.bshield.io/?code=16>

This error occurs when using third-party keyboard applications that are not in BShield's trusted list.

**Fix:**
We recommend using keyboards from trusted publishers, such as GBoard from Google.

## Error Code 17 (Application Installed in Work Profile)

**Reference link:** <https://s.bshield.io/?code=17>

This error occurs when the application is installed inside a work profile.

**Fix:**
Reinstall the application outside the work profile.  
Currently, there is no known method to hide this feature.

## Error Code 18 (Simulated Input Detected)

**Reference link:** <https://s.bshield.io/?code=18>

This error occurs when using simulated input for the application.

**Fix:**
We recommend avoiding autoclickers or any applications/software that simulate input (such as keyboard simulation) within this application.

## Error Code 19 (Proxy Mode Enabled on Device)

**Reference link:** <https://s.bshield.io/?code=19>

This error occurs when using a proxy configured in the Wi-Fi SSID settings.

**Fix:**
We recommend temporarily disabling the proxy, or preferably not using one at all.

## Error Code 20 (Application Does Not Support MacOS)

**Reference link:** <https://s.bshield.io/?code=20>

This is a special error code related to using iPhone virtualization environments on MacOS systems.

Currently, this error rarely appears, but if it does, it indicates that you should not use this application inside iPhone virtualization environments.

## Error Code 21 (Possible Root Compromise Detected)

**Reference link:** <https://s.bshield.io/?code=21>

Based on current findings, this error works identically to Error Code 5.  
You can read more [by clicking here](#error-code-5-root-detection)

## Error Code 22 (System Hook Detected)

**Reference link:** <https://s.bshield.io/?code=22>

This error occurs when using hooking modules such as LSPosed or Xposed.

**Fix:**
Use the official LSPosed 2.0 release (<https://lsposed.zip>) or LSPosed forks such as Irena, IrenaX, or Vector.

## Error Code 23 (VPN Connection Detected)

**Reference link:** <https://s.bshield.io/?code=23>

This error occurs when connected to a VPN.

**Fix:**
Install [RuslanUC/NoVPNDetect](https://github.com/RuslanUC/NoVPNDetect), open LSPosed, then configure the NoVPNDetect module to hook into the application detecting the VPN.
