class_name Rewindable
extends Node
## Time rewind (Braid-style). Add as a child of any 2D body to opt in. Godot 4.x.

# 3. Capped ring buffer: 5 s at 60 physics fps = 300 snapshots. Memory never grows.
const MAX_SNAPSHOTS := 300

# 4. One switch for every Rewindable. The scene flips it while "rewind" is held.
static var rewinding := false

var body: Node2D
var anim: AnimatedSprite2D
var _buffer: Array[Dictionary] = []
var _head := 0
var _count := 0
var _last := {}


func _ready() -> void:
	body = get_parent() as Node2D
	anim = body.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	_buffer.resize(MAX_SNAPSHOTS)
	add_to_group("rewindable")


# 1. Every physics frame: record, or play one snapshot backward.
func _physics_process(_delta: float) -> void:
	if rewinding:
		step_back()
	else:
		record()


func record() -> void:
	_buffer[_head] = _capture()
	_head = (_head + 1) % MAX_SNAPSHOTS
	_count = mini(_count + 1, MAX_SNAPSHOTS)


# 4. Pop the newest snapshot. At the oldest one, just hold.
func step_back() -> void:
	if _count == 0:
		return
	_head = (_head - 1 + MAX_SNAPSHOTS) % MAX_SNAPSHOTS
	_count -= 1
	_last = _buffer[_head]
	body.global_position = _last.pos
	body.global_rotation = _last.rot
	if anim:
		anim.frame = _last.frame


# 2. A snapshot: position, rotation, velocity, animation frame.
func _capture() -> Dictionary:
	var s := {"pos": body.global_position, "rot": body.global_rotation, "vel": Vector2.ZERO, "spin": 0.0, "frame": 0}
	if body is CharacterBody2D:
		s.vel = body.velocity
	elif body is RigidBody2D:
		s.vel = body.linear_velocity
		s.spin = body.angular_velocity
	if anim:
		s.frame = anim.frame
	return s


# 4. Freeze normal physics while rewinding; resume from the last popped state.
func set_frozen(on: bool) -> void:
	body.set_physics_process(not on)
	if anim:
		anim.speed_scale = 0.0 if on else 1.0
	if body is RigidBody2D:
		body.freeze = on
	if on or _last.is_empty():
		return
	if body is CharacterBody2D:
		body.velocity = _last.vel
	elif body is RigidBody2D:
		body.linear_velocity = _last.vel
		body.angular_velocity = _last.spin
	_last = {}


func snapshot_count() -> int:
	return _count
