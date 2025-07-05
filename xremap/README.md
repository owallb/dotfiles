Setup:

1. install xremap
2. run these commands:
```sh
echo 'KERNEL=="uinput", GROUP="input", TAG+="uaccess"' \
    | sudo tee -a /etc/udev/rules.d/99-input.rules
echo 'uinput' \
    | sudo tee -a /etc/modules-load.d/uinput.conf
sudo usermod -aG input <user>
```
3. reboot
4. run xremap with:
```sh
xremap ~/repos/dotfiles/xremap/<config>.yml --device '<device_name>'
```
