# Trail3D (Godot 4.8 beta 1)

From the Lexi Volt Godot tutorial on the new `Trail3D` node. Video coming soon.

## What it shows

Three trails from one node type: a sword swipe that fades over time, a dash streak that
only draws while dashing, and a curving projectile with a length-capped tail. Width taper,
color gradient and additive glow are all set in code.

## Godot version

**Godot 4.8 beta 1** only (`Trail3D` is new in 4.8, GH-117107). This is a beta: property
names may still change before 4.8 is final. Tested on 4.8 beta 1 (4.8.beta1.official.4d10419ca),
Compatibility renderer.

## How to run

1. Open Godot 4.8 beta 1 (or newer).
2. In the Project Manager, click **Import** and pick `trail3d/project.godot`.
3. Press **Play** (F5).

## What to look for

- The blade swings back and forth. Its trail is wide and cyan at the tip and thins out
  to clear magenta behind it, then fades after 0.25 s (**Limit Mode: Time**).
- Every 2 seconds the left ball dashes right and leaves a streak. The streak is cleared
  before each dash, so the reset jump never draws a line.
- The other ball circles the scene. Its trail never gets longer than 3 m
  (**Limit Mode: Length**).

## Files

- `trails.gd`: all the tutorial code (steps 1 to 7 match the video).
- `main.tscn`: the scene. Each moving object has a `Trail3D` child; the sword's sits on a
  `Marker3D` at the blade tip.
- `project.godot`: Compatibility renderer.

## The code

```gdscript
extends Node3D
## Sword, dash and projectile trails with Trail3D (Godot 4.8 beta 1)

@onready var sword_trail: Trail3D = $Pivot/Blade/Tip/Trail3D
@onready var dash_trail: Trail3D = $Dasher/Trail3D
@onready var shot_trail: Trail3D = $Shot/Trail3D

var t := 0.0
var last_dash := -1


func _ready() -> void:
	# 1. Sword: fade by time
	sword_trail.limit_mode = Trail3D.LIMIT_MODE_LIFETIME
	sword_trail.lifetime = 0.25
	sword_trail.width = 0.4
	# 2. Taper with a width curve
	var taper := Curve.new()
	taper.add_point(Vector2(0.0, 1.0))
	taper.add_point(Vector2(1.0, 0.0))
	sword_trail.width_curve = taper
	# 3. Color with a gradient, glow with additive
	var glow := Gradient.new()
	glow.set_color(0, Color(0.0, 1.0, 1.0, 1.0))
	glow.set_color(1, Color(1.0, 0.0, 1.0, 0.0))
	sword_trail.color_gradient = glow
	sword_trail.material_mode = Line3D.MATERIAL_MODE_ADD
	# 4. Dash and projectile: cap by length
	for trail: Trail3D in [dash_trail, shot_trail]:
		trail.limit_mode = Trail3D.LIMIT_MODE_MAX_LENGTH
		trail.max_length = 3.0
		trail.color_gradient = glow
		trail.material_mode = Line3D.MATERIAL_MODE_ADD


func _process(delta: float) -> void:
	t += delta
	# 5. Swing the blade
	$Pivot.rotation.y = sin(t * 4.0) * 2.0
	# 6. Dash: emit only while dashing, clear on reset
	var dash := int(t / 2.0)
	if dash != last_dash:
		last_dash = dash
		dash_trail.clear()
	var cycle := fmod(t, 2.0)
	dash_trail.emitting = cycle < 0.3
	$Dasher.position.x = -2.0 + minf(cycle, 0.3) * 15.0
	# 7. Curving projectile
	$Shot.position = Vector3(sin(t * 2.0) * 3.0, 1.0, cos(t * 2.0) * 3.0)
```

## Good to know

- Along the trail, **x = 0 of the Width Curve and offset 0 of the Color Gradient are the head**
  (the end at the node). x = 1 is the oldest end. So a curve from 1 down to 0 tapers to a point.
- Put the trail on the part that moves fastest (the tip). On the blade's middle it barely shows.
- Call `clear()` after a teleport or respawn, or the trail draws a streak across the jump.
- In Time mode, `get_current_length()` reads 0 in beta 1; it reports a length in Length mode.

## Credits & licenses

No third-party assets in this folder. Everything is built from plain Godot nodes and primitive
meshes. The sword in the Short is KayKit by Kay Lousberg (CC0) and isn't included here. Code, scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
Trail3D is by QbieShay (GH-117107), based on Zi Ye's Cozy Cube Godot Addons.
