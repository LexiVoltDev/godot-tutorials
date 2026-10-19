# Node-Based State Machine

From the Lexi Volt Godot tutorial that aired **Sun Oct 18, 2026**. [Watch on YouTube](https://youtu.be/NhaQOS6NTbI)

## What it shows

A node-based state machine for a platformer player: a `StateMachine` node runs exactly one child `State` at a time (Idle, Run, Jump, Fall), and states request transitions with a signal.

## Godot version

Godot 4.4 or newer (typed `Dictionary`). Tested on 4.8 beta 1; 4.3 fails to parse.

## How to run

1. Open Godot (4.4 or newer).
2. In the Project Manager, click **Import** and pick `state-machine/project.godot`.
3. Press **Play** (F5).

## Controls

| Key | Action |
| --- | --- |
| A / D | Run left / right |
| Space | Jump |

The cyan box is the player. Open the **Remote** scene tree while it runs, or connect to
`StateMachine.state_changed`, to watch Idle -> Run -> Jump -> Fall -> Idle.

## Files

- `state.gd`: the base `State` class.
- `state_machine.gd`: the `StateMachine` (collects child states by node name).
- `states/idle.gd`, `run.gd`, `jump.gd`, `fall.gd`: one script per state.
- `player.tscn`, `main.tscn`, `project.godot`: player, floor and Input Map.

## Good to know

States are looked up by **node name**. Rename the `Run` node and you'll get
`Unknown state: Run` in the Debugger.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
