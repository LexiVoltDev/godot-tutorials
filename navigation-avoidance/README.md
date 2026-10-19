# Navigation and Avoidance (NavigationAgent2D)

From the Lexi Volt Godot tutorial that aired **Tue Oct 20, 2026**. Video coming soon.

## What it shows

Three enemies path around a wall to a goal with `NavigationAgent2D`, while avoidance keeps them from bumping into each other. The navmesh is baked in code from source geometry, and the map-sync wait is done the safe way.

## Godot version

Godot 4.x (`NavigationAgent2D`, `NavigationMeshSourceGeometryData2D`). Tested on 4.3 and 4.8 beta 1.

## How to run

1. Open Godot (4.3 or newer).
2. In the Project Manager, click **Import** and pick `navigation-avoidance/project.godot`.
3. Press **Play** (F5).

## What to look for

Press Play, then turn on **Debug > Visible Navigation** and **Debug > Visible Avoidance**.
The three enemies leave the left side, arc over the top of the wall, keep their
avoidance circles apart, and stop on the yellow goal.

## Files

- `main.gd`: bakes the navmesh (`agent_radius` keeps bodies off the wall).
- `enemy.gd`: waits for the first map sync, follows the path, and moves only in
  `velocity_computed` (the tutorial code).
- `main.tscn`, `project.godot`: the level. `project.godot` turns off async navigation
  iterations; leave that as is.

## Good to know

Don't query the map before its first sync: on 4.8 you silently get an empty path.
Keep the `while ... map_get_iteration_id(...) == 0` loop instead of a single frame wait.

## Credits & licenses

No third-party assets. Everything on screen is built from plain Godot nodes. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
