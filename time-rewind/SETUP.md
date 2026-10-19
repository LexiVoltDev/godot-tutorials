# Time Rewind (Braid-style)

Hold a key and everything runs backward: the player, falling crates, even the
enemy's walk animation. Die in the pit, rewind, and undo your death.

**Needs Godot 4.1 or newer** (it uses a `static var`). Tested on 4.3 and 4.8.

## Run it

Open `project.godot` in Godot and press Play (F5).

| Key | Action |
| --- | --- |
| Left / Right arrows | Move |
| Space | Jump |
| Hold R (or Shift) | Rewind |

Try this: walk right into the pit, then hold R until you're back on the ledge.
The label in the corner shows how full the rewind buffer is (up to 300 frames,
which is 5 seconds at 60 physics ticks per second).

## Files

- `rewindable.gd`: the `Rewindable` node. Add it as a child of any 2D body
  (CharacterBody2D, RigidBody2D, ...) to make that body rewindable. It records
  position, rotation, velocity and the animation frame every physics tick into a
  fixed-size ring buffer, so memory never grows.
- `main.gd`: adds the `rewind` input action (R or Shift), flips the global rewind
  switch and adds the polish: a grayscale screen shader and lower audio pitch.
- `player.gd`, `enemy.gd`: a simple player and a pacing enemy.
- `desaturate.gdshader`: the grayscale rewind look.
- `main.tscn`, `project.godot`: the demo level and project settings.

## Use it in your game

1. Copy `rewindable.gd` into your project.
2. Add a `Rewindable` node as a child of each body you want to rewind.
3. While your rewind button is held, set `Rewindable.rewinding = true` and call
   `get_tree().call_group("rewindable", "set_frozen", true)`. On release, set it
   back to `false` and call `set_frozen(false)`. See `set_rewinding()` in `main.gd`.

## Hearing the audio effect

The project ships with no sound files. Add any looping `AudioStreamPlayer` with
Autoplay on, then hold R: playback drops to 0.6x while rewinding.

## Good to know

- `Rewindable.rewinding` is static. If you change scenes while rewinding, set it
  back to `false`.
- Teleports (like a respawn) should clear the buffer, or a rewind will walk back
  through the teleport.
- Rigid bodies are frozen while rewinding, so setting their position doesn't fight
  the physics solver.
- Rewind only goes back as far as the buffer: 5 seconds by default. Change
  `MAX_SNAPSHOTS` for more.
