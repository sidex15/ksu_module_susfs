# A KernelSU module for SUSFS patched kernel #

This module installs a userspace helper tool called **ksu_susfs** and **sus_su** into /data/adb/ksu and provides a script to communicate with SUSFS kernel.
This module provides root hiding for KernelSU on the kernel level.

## Notes
- Make sure you have a custom kernel with SUSFS patched in it. Check the custom kernel source to see if it has SUSFS.
- Make sure the kernel is using SUSFS 1.5.2 or later for effective hide.
- Shamiko v1.2.1 or later is acceptable
- HideMyApplist is acceptable
- ReVanced root module compatible
- Recommended to use [bindhosts](https://github.com/backslashxx/bindhosts) if you want to use systemless hosts

## Adding ro.boot.vbmeta.digest value
This module will now have a directory called `VerifiedBootHash` in `/data/adb` containing `VerifiedBootHash.txt` for users with missing `ro.boot.vbmeta.digest` value to prevent partition modified and abnormal boot state detection. 
- Copy your VerifiedBootHash in the Key Attestation demo and paste it to `/data/adb/VerifiedBootHash/VerifiedBootHash.txt`

## Credits
susfs4ksu: https://gitlab.com/simonpunk/susfs4ksu/

## Buy us some coffee ☕
### simonpunk
PayPal: `kingjeffkimo@yahoo.com.tw`
<br>BTC: `bc1qgkwvsfln02463zpjf7z6tds8xnpeykggtgk4kw`
### sidex15
PayPal: `sidex15.official@gmail.com`
<br>ETH (ERC20): `0xa52151ebd2718a00af9e1dfcacfb30e1d3a94860`
<br>USDT (TRC20): `TAUbxzug7cygExFunhFBiG6ntmbJwz7Skn`
<br>USDT (ERC20): 
`0xa52151ebd2718a00af9e1dfcacfb30e1d3a94860`
