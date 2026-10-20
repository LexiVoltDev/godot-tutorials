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
