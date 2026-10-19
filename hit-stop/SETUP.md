# Hit-Stop

A tiny arena that shows a reusable `HitStop` autoload. Every hit briefly freezes
the game, flashes the screen, shakes the camera and dips the audio. Bigger hits
and parries freeze longer.

**Needs Godot 4.4 or newer.** (It uses `Tween.set_ignore_time_scale()` and
`Timer.ignore_time_scale`, which arrived in 4.4.)

## Run it

Open `project.godot` in Godot and press Play (F5).

| Key | Action | Freeze |
| --- | --- | --- |
| J | Light hit (10 damage) | 60 ms, half flash |
| K | Big hit (60 damage) | 240 ms |
| L | Parry (10 damage) | 120 ms, full white flash |

Watch for:
- the pink enemy stops dead during the freeze,
- the flash holds for the freeze, then fades,
- the camera shakes for a few frames after release,
- the combo counter keeps ticking in real time (its timer ignores `time_scale`).

## Files

- `hit_stop.gd`: the `HitStop` autoload. Drop it into your own project and register
  it under Project Settings > Globals > Autoload as `HitStop`.
- `main.gd` / `main.tscn`: the demo arena.
- `project.godot`: project settings, with the autoload already registered.

## Use it in your game

```gdscript
func _ready():
    HitStop.camera = $Camera2D   # optional, for shake
    HitStop.flash = $UI/Flash    # optional, a full-screen white ColorRect

func on_enemy_hit(damage):
    HitStop.hit(damage)          # or HitStop.hit(damage, true) for a parry
```

Tweak the exported values on the autoload (freeze lengths, bonuses, shake strength,
audio duck) to taste.

## Hearing the audio dip

The project ships with no sound files. Add any looping `AudioStreamPlayer` on the
Master bus with Autoplay on, then press K: the volume drops 8 dB and playback slows
to 0.8x for the length of the freeze.

## Good to know

`Engine.time_scale` is global. If you change scenes in the middle of a freeze, the
new scene starts frozen too. `HitStop` always sets it back to 1.0 when its last
timer fires, and that timer keeps running even while the tree is paused.
