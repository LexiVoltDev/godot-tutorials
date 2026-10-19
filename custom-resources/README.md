# Custom Resources Done Right

From the Lexi Volt Godot tutorial that aired **Sat Oct 17, 2026**. [Watch on YouTube](https://youtu.be/dndLjBpfx2I)

## What it shows

A `WeaponData` custom Resource: exported stats, a setter that clamps and emits `changed`, behavior living with the data, and why you `duplicate()` a shared `.tres` before changing it.

## Godot version

Godot 4.x. Tested on 4.3 and 4.8 beta 1.

## How to run

1. Open Godot (4.x).
2. In the Project Manager, click **Import** and pick `custom-resources/project.godot`.
3. Press **Play** (F5).

## What to look for

The demo prints to the **Output** panel. Two enemies share `sword.tres`, but each
duplicates it in `_ready`, so EnemyA's hits only wear down its own copy:

```
EnemyA Neon Sword durability: 2
EnemyA Neon Sword durability: 1
EnemyA Neon Sword durability: 0
EnemyA: 0
EnemyB: 3
file: 3
```

Comment out the `weapon = weapon.duplicate()` line in `wielder.gd` to see the shared
resource bug: EnemyB's (and the file's) durability drops too.

## Files

- `weapon_data.gd`: the `WeaponData` Resource (class_name).
- `wielder.gd`: any node that uses a `WeaponData`.
- `sword.tres`: a saved WeaponData (Neon Sword). Open it to see the Inspector fields.
- `main.gd`, `main.tscn`: the demo.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
