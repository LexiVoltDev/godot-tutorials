# Input Buffering (Fix Early Jumps)

From the Lexi Volt Godot tutorial that aired **Wed Oct 14, 2026**. [Watch on YouTube](https://youtube.com/shorts/_SLvEyjhQzo)

## What it shows

A jump buffer: if the player presses jump a split second before landing, the press is remembered for 0.15 s and the jump fires on touchdown. The on-screen bar shows `_jump_buffer_timer` counting down live, and the JUMP button lights up on every press.

## Godot version

Godot 4.3 or newer (uses `get_gravity()`). Tested on 4.3 and 4.8 beta 1.

## How to run

1. Open Godot (4.3 or newer).
2. In the Project Manager, click **Import** and pick `input-buffer/project.godot`.
3. Press **Play** (F5).

## Controls

| Key | Action |
| --- | --- |
| Space (or gamepad A) | Jump |

Mash jump just before you land: every early press still turns into a jump.

## Before / after

`player.gd` is the fixed version (the code from the video). `player_before.gd` is the
broken version that only checks the button on the exact frame you press it. To see the
difference, select **Player** in `main.tscn` and swap its script to `player_before.gd`.
The label switches to BEFORE, and early presses get a red X.

## Files

- `player.gd`: the buffered jump (the tutorial code).
- `player_before.gd`: the unbuffered version, for comparison.
- `fx.gd`: visual feedback only (label, JUMP button, red X, dust, squash and stretch).
- `buffer_readout.gd`: the live buffer timer bar.
- `main.tscn`, `project.godot`: the level and settings (Input Map has `jump`, `move_left`, `move_right`).

## Credits & licenses

- Code and scene: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
- **Pixel Platformer** by Kenney (www.kenney.nl): character, tiles and background art.
  License: CC0 1.0, http://creativecommons.org/publicdomain/zero/1.0/
  Source: https://kenney.nl/assets/pixel-platformer (original `License.txt` in `assets/kenney/`).

## Not included

The automated input driver used to record the video's gameplay clips is not included, so you play it yourself. No audio is included.
