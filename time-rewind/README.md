# Time Rewind (Braid-style)

From the Lexi Volt Godot tutorial that aired **Mon Oct 19, 2026**. [Watch on YouTube](https://youtu.be/OX466Os7FH4)

## What it shows

Hold a key and everything runs backward: the player, falling crates, even the enemy's walk animation. A `Rewindable` node records each body into a fixed-size ring buffer.

## Godot version

Godot 4.1 or newer (`static var`). Tested on 4.3 and 4.8 beta 1.

## How to run

1. Open Godot (4.1 or newer).
2. In the Project Manager, click **Import** and pick `time-rewind/project.godot`.
3. Press **Play** (F5).

Controls, files and tips are in [SETUP.md](SETUP.md). Short version: arrows to move, Space to jump, hold R (or Shift) to rewind.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes, gradients and a small shader. Code, scenes and shader: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).

## Not included

No music is included. To hear the 0.6x rewind pitch drop, add any looping `AudioStreamPlayer` with Autoplay on.
