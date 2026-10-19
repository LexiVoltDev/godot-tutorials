# Grid Snap: Your First Editor Plugin (EditorDock)

From the Lexi Volt Godot tutorial that aired **Mon Oct 19, 2026**. [Watch on YouTube](https://youtu.be/hYf4oCjITXU)

## What it shows

A small editor plugin that adds a **Grid Snap** dock with one button: snap every selected Node2D to a 16 px grid, as a single undoable action (Ctrl+Z restores all of them).

## Godot version

Godot 4.6 or newer (uses `EditorDock`). Tested on 4.8 beta 1; 4.3 fails to parse.

## How to run

1. Open Godot (4.6 or newer).
2. In the Project Manager, click **Import** and pick `grid-snap/project.godot`.
3. Press **Play** (F5).

## Try it

This one runs in the **editor**, not in the game:

1. The plugin ships enabled (Project > Project Settings > Plugins > Grid Snap).
2. A **Grid Snap** dock appears in the top-right dock slot.
3. Open `main.tscn` and select SpriteA, SpriteB and SpriteC.
4. Click **Snap selection to grid**: (13, 37), (50, 7), (101, 66) become (16, 32), (48, 0), (96, 64).
5. Press Ctrl+Z: all three jump back in one step.

## Use it in your game

Copy `addons/grid_snap/` into your project's `addons/` folder and enable it under
Project Settings > Plugins.

## Files

- `addons/grid_snap/plugin.cfg`: plugin name, description and script.
- `addons/grid_snap/plugin.gd`: the `@tool` EditorPlugin (the tutorial code).
- `main.tscn`: three sprites to snap.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
