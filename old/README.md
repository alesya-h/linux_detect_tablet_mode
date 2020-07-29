# Tablet mode detection and setup scripts for linux

## What this is

It's an older version of tablet mode detection scripts. Unlike the main version, it uses
a pair of accelerometers instead of mode switch events. Mode switch events are the right
way to handle tablet mode on linux, but it might be that some laptops don't support it (yet?).
This set of scripts is more complicated, less reliable, and requires the device to be in
laptop mode when the script is started. On the other hand, due its low-level nature, it
allows you to customize the angle between the screen and a keyboard that is treated as a
tablet mode.

## What it does

It uses two accelerometers to detect an angle between the screen and the keyboard,
decides if that angle corresponds to laptop or tablet mode, and if mode have changed,
it executes commands for switching into that mode, which are specified in
a config file. Generally you would put there commands to disable/enable a
keyboard/touchpad/trackpoint, show/hide an on-screen keyboard, toggle some desktop
environment panels, and the like.

## Supported devices

Supposedly any 2-in-1s that have 2 accelerometers. Tested devices:

- ThinkPad X1 Yoga Gen2 (it was developed for it, but it doesn't work anymore, because its accelerometers aren't exposed anymore)

If it works on your device, please tell me and I'll add it to the list (or just submit a pull request yourself).

## Installation

1. Install ruby (most likely you already have it preinstalled)
2. Clone it somewhere, and optionally symlink `watch_tablet` into any directory in your $PATH
3. Copy a config file into `~/.config/watch_tablet.yml`
4. Adjust the config (see below)
5. Add `watch_tablet &` to your `~/.xinitrc`
6. Restart your desktop session and enjoy

## Configuration

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

## Bugs

Because IIO device ids are not stable across reboots, we can't put them in a config, meaning we have
to detect them. Current autodetection logic is very simplistic and just grabs first 2 accelerometers,
and arranges them assuming that the laptop is currently in a laptop mode. For proper autodetection
we need PLD (Physical Location of Device) information to be available in the userspace, but at this
point patches for that are not in a mainline kernel (https://patchwork.kernel.org/patch/4464341/).
