apt update
apt install -y git autoconf libtool make pkg-config libusb-1.0-0 libusb-1.0-0-dev telnet autotools-dev automake
git clone git://git.code.sf.net/p/openocd/code openocd-code
cd openocd-code
./bootstrap
./configure --enable-sysfsgpio --enable-bcm2835gpio
make
make install

echo "interface sysfsgpio

# minimal swd setup
sysfsgpio_swdio_num 24
sysfsgpio_swclk_num 25
sysfsgpio_srst_num 23

transport select swd

reset_config srst_only
reset_config srst_nogate
reset_config connect_assert_srst

source [find target/stm32f3x.cfg]

adapter_nsrst_delay 100
adapter_nsrst_assert_width 100

init
targets
reset halt" > /root/openocd-code/min_openocd_config.cfg

#kaktus do odpalania z eclipse'a
echo 'openocd -f /root/openocd-code/min_openocd_config.cfg -c "program fw.elf" -c reset -c shutdown
cp fw.elf /root/openocd-code/.flash_history/FW_$(date '+%Y-%m-%d_%H:%M:%S').elf' > /root/openocd-code/flash.sh
chmod +x /root/openocd-code/flash.sh

#dodaj klucz Stefana
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAojNKhPgYPXUyq8JDZCEG8F7yY03eBZVqxDyxfl46vJc9eowNcW+OavdUWliEPfVcXAWc0N5MN6lI34lnqLM9caRnjnRgxFHdtDXM08QQCxBJgIpK8UdoHhvYlCJebndHy7GnOl2k9Eoadqa3SqrZzK5futKJldhwf6CYhEslA1jJIre40SGyenx76DiRdNkfvAMh+sAuog48Y+/t+5h7AxTeqzLKsyxeKnyHCdmK7eVoGJWGx0L8H5wK37vnUKZgyHYqvxyCawX+3cUh/GQ8RH9ZjWsPDvYeRgP39/Nwy+InN59JvtvdnPfnZi5+h3Q6q2ATKIx0IAV0SpXg2nh9 stefan@DELEC' >> /root/.ssh/authorized_keys
#dodaj klucz z Acera
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDXlu99H4HvmqmdyVbYbI0s8W7VVSajDYNEiAYeuZe/7QXsBth0bRmfyCJhx4djzUyDoX7SMpe8QawJfjJjF6e0VIgw7A5d0QFQIOHy3/ptEFTOTZ5S2V35e/Csy6Q+/zBPOKfKiez/UZAW9o8CdShSiQRbYjCWNRKSw/2EUc4H6pRJ7q99z71Byt6tPsPdm5mIH6cACU2y7VrLvIO4Tfcexb37Y3BKcnzhqnbExDT0nQcL+OXOuKXqlyyJv5ENm92xoeo1uzjK/nrnOwdHljICVGIljzzaH4Ed/wJWl6RVeyxQnEnvthsfUvi8fxWiZM9SOC+vN3k3IMr98MUY8Lut madar@LAPTOP-2V00ECDB' >> /root/.ssh/authorized_keys

#folder na hitorie flashowania
mkdir /root/openocd-code/.flash_history