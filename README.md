# A KernelSU module for SUS-FS patched kernel #

This module is used for installing a userspace helper tool called **ksu_susfs** and **sus_su** into /data/adb/ and provides a script to communicate with SUS-FS kernel

## Notes
- Make sure you have a custom kernel with SUS-FS patched in the kernel. Check the custom kernel source if it has SUS-FS.'
- Make sure the kernel is using SUS-FS 1.4.2 for effective hide.
- Do not mix/install with other root-hiding modules such as shamiko or zygisk assistant.
- HideMyApplist is acceptable
- Revanced root module compatible
- Recommended to use [systemless-hosts-KernelSU-module by symbuzzer](https://github.com/symbuzzer/systemless-hosts-KernelSU-module) if you want to use systemless hosts
