# Tablet mode detection and setup scripts for linux

## What it does

It uses two accelerometers to detect an angle between the screen and the keyboard,
decides if that angle corresponds to laptop or tablet mode, and if mode have changed,
it executes commands for switching into that mode, which are specified in
a config file. Generally you would put there commands to disable/enable a
keyboard/touchpad/trackpoint, show/hide an on-screen keyboard, toggle some desktop
environment panels, and the like.

## Supported devices

Supposedly any 2-in-1s that have 2 accelerometers. Tested devices:

- ThinkPad X1 Yoga Gen2 (it was developed for it)

If it works on your device, please tell me and I'll add it to the list (or just submit a pull request yourself).

## Installation

1. Install ruby (most likely you already have it preinstalled)
2. Clone it somewhere, and optionally symlink `watch_tablet` into any directory in your $PATH
3. Copy a config file into `~/.config/watch_tablet.yml`
4. Adjust the config (see below)
5. Add `watch_tablet &` to your `~/.xinitrc`
6. Restart your desktop session and enjoy

## Configuration

`display_accel_id`, `keyboard_accel_id` - ids of your iio accelerometer devices. Look
for `iio:device[id]` folders in `/sys/bus/iio/devices/` directory. Directories for
accelerometer sensors should have `name` file in them with a text `accel_3d`. For this scripts
to work you must have at least two of those - one in a screen and one in a base/keyboard.
Most likely a device with a lower id is a screen accelerometer, and device with higher id is
a keyboard accelerometer.

Example:

```yaml
display_accel_id: 1
keyboard_accel_id: 6
```

`modes.laptop`, `modes.tablet` - this contain commands that will be executed when mode changes.
Most likely this will contain `xinput enable` and `xinput disable` commands to enable/disable
kb/touchpad/trackpoint (just run `xinput` to look them up). You may use any other commands
to adjust your desktop environment (e.g. hide or show additional panels, increase button size,
hide/show onscreen keyboard etc.)

Example:

```yaml
modes:
  laptop:
    - xinput enable 9   # touch
    - xinput enable 12  # keyboard
    - xinput enable 13  # touchpad
    - xinput enable 14  # trackpoint
  tablet:
    - xinput disable 12  # keyboard
    - xinput disable 13  # touchpad
    - xinput disable 14  # trackpoint
```
