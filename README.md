# Tablet mode detection and setup scripts for linux

## What it does

It uses `libinput debug-events` to detect switches to normal and tablet mode,
and executes commands for switching into that mode, which are specified in
a config file. Generally you would put there commands to disable/enable a
keyboard/touchpad/trackpoint, show/hide an on-screen keyboard, toggle some desktop
environment panels, and the like.

## Supported devices

All devices that have a tablet mode switch supported by libinput. As far as I understand
this is a standard mechanism for this functionality nowadays. Tested devices:

- ThinkPad X1 Yoga Gen2 (it was developed for it)
- Thinkpad X1 Yoga Gen3
- Thinkpad X1 Yoga Gen4
- Samsung Galaxy Book Flex2 5G

If it works on your device, please tell me and I'll add it to the list (or just submit a pull request yourself).

## Installation

1. Add your user to the `input` group (`sudo gpasswd --add username input`) and relogin to apply group membership.
2. Install ruby and stdbuf (most likely you already have them preinstalled)
3. Clone this repo somewhere, and optionally symlink `watch_tablet` into any directory in your $PATH
4. Copy a config file into `~/.config/watch_tablet.yml`
5. Adjust the config (see below)
6. Test it by running `watch_tablet` in a terminal and flipping your laptop to tablet and back. You should see commands from the config being executed. Press Ctrl+C to terminate it.
7. After you confirmed that everything works, add `watch_tablet &` to your `~/.xinitrc`
8. Restart your desktop session and enjoy

### Arch Linux

If you have an Arch-based distribution, you can install it using [this AUR package](https://aur.archlinux.org/packages/detect-tablet-mode-git/)


## Configuration

`input_device` is a path to the device that provides the tablet mode switch. To find it you
may run `stdbuf -oL libinput debug-events|grep switch` and notice something like `event4` in
the leftmost column. That would correspond to /dev/input/event4. Device numbers may be unstable
across reboots, so you may consider doing `ls -lh /dev/input/by-path` and finding a symlink to
that device. For X1 Yoga Gen2 it's `/dev/input/by-path/platform-thinkpad_acpi-event`.

`modes.laptop`, `modes.tablet` - this contain commands that will be executed when mode changes.
Most likely this will contain `xinput enable` and `xinput disable` commands to enable/disable
kb/touchpad/trackpoint (just run `xinput` to look them up). You may use any other commands
to adjust your desktop environment (e.g. hide or show additional panels, increase button size,
hide/show onscreen keyboard etc.)

Example:

```yaml
input_device: /dev/input/by-path/platform-thinkpad_acpi-event
modes:
  laptop:
    # - xinput enable "Wacom Pen and multitouch sensor Finger"
    - xinput enable "AT Translated Set 2 keyboard"
    - xinput enable "SynPS/2 Synaptics TouchPad"
    - xinput enable "TPPS/2 IBM TrackPoint"
  tablet:
    # - xinput disable "Wacom Pen and multitouch sensor Finger"
    - xinput disable "AT Translated Set 2 keyboard"
    - xinput disable "SynPS/2 Synaptics TouchPad"
    - xinput disable "TPPS/2 IBM TrackPoint"
```

