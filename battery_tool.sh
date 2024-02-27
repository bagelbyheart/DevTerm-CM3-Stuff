#!/bin/bash

# This uses `upower` to check the battery state, then generates a tidy output
# to use in `screen`. To adapt this to another device you'll need to change the
# device it's pointing at. Belew is an example of listing devices:
#
# $ upower -e
# /org/freedesktop/UPower/devices/battery_axp20x_battery
# /org/freedesktop/UPower/devices/line_power_axp20x_usb
# /org/freedesktop/UPower/devices/DisplayDevice
#
# At the bottom of this script is an example of a dump of all device info.
# And here is my goal output:
# [battery: D(073%)] <- Discharging at 73%
# [battery: C(005%)] <- Charging at 5%
#

battery_device="/org/freedesktop/UPower/devices/battery_axp20x_battery"
battery_state=$(upower -i $battery_device | grep "state" | awk '{print $2}')
battery_state=$(tr '[:lower:]' '[:upper:]' <<< "$battery_state")
battery_level=$(upower -i $battery_device | grep "perce" | awk '{print $2}')
battery_level=${battery_level/\%/}

# Added this since it never seems to actually reach 100%
if [ "$battery_level" == "99" ] && [ "$battery_state" == "CHARGING" ]; then
 battery_state="Full"
 battery_level="100"
 fi

printf "batt: %c(%03d%%)\n" "$battery_state" "$battery_level"

# Here is an example of the dump command for `upower`:
#
# $ upower -d
# Device: /org/freedesktop/UPower/devices/battery_axp20x_battery
#   native-path:          axp20x-battery
#   power supply:         yes
#   updated:              Tue 27 Feb 2024 10:41:15 AM PST (4 seconds ago)
#   has history:          yes
#   has statistics:       yes
#   battery
#     present:             yes
#     rechargeable:        yes
#     state:               discharging
#     warning-level:       none
#     energy:              6.6 Wh
#     energy-empty:        0 Wh
#     energy-full:         8 Wh
#     energy-full-design:  0 Wh
#     energy-rate:         0.561 W
#     voltage:             3.922 V
#     time to empty:       11.8 hours
#     percentage:          76%
#     capacity:            100%
#     icon-name:          'battery-full-symbolic'
#   History (rate):
#     1709059275  0.561   discharging
#
# Device: /org/freedesktop/UPower/devices/line_power_axp20x_usb
#   native-path:          axp20x-usb
#   power supply:         yes
#   updated:              Tue 27 Feb 2024 10:21:13 AM PST (1206 seconds ago)
#   has history:          no
#   has statistics:       no
#   line-power
#     warning-level:       none
#     online:              no
#     icon-name:          'ac-adapter-symbolic'
#
# Device: /org/freedesktop/UPower/devices/DisplayDevice
#   power supply:         yes
#   updated:              Tue 27 Feb 2024 10:41:15 AM PST (4 seconds ago)
#   has history:          no
#   has statistics:       no
#   battery
#     present:             yes
#     state:               discharging
#     warning-level:       none
#     energy:              6.6 Wh
#     energy-full:         8 Wh
#     energy-rate:         0.561 W
#     time to empty:       11.8 hours
#     percentage:          76%
#     icon-name:          'battery-full-symbolic'
#
# Daemon:
#   daemon-version:  0.99.10
#   on-battery:      yes
#   lid-is-closed:   no
#   lid-is-present:  no
#   critical-action: PowerOff
#