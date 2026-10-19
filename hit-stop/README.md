# Hit-Stop

From the Lexi Volt Godot tutorial that aired **Wed Oct 21, 2026**. Video coming soon.

## What it shows

A reusable `HitStop` autoload: a damage-scaled freeze, screen flash, camera shake and audio dip. Bigger hits and parries freeze longer.

## Godot version

Godot 4.4 or newer (`Tween.set_ignore_time_scale()`, `Timer.ignore_time_scale`). Tested on 4.8 beta 1.

## How to run

1. Open Godot (4.4 or newer).
2. In the Project Manager, click **Import** and pick `hit-stop/project.godot`.
3. Press **Play** (F5).

Controls, files and tips are in [SETUP.md](SETUP.md). Short version: J = light hit, K = big hit, L = parry.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).

## Not included

No music or sound effects are included. To hear the audio dip, add any looping `AudioStreamPlayer` on the Master bus with Autoplay on and press K.
