extends CharacterBody2D

## How long an early jump press is remembered, in seconds.
@export var jump_buffer_time: float = 0.15
@export var jump_velocity: float = -400.0

var _jump_buffer_timer: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Count the buffer down, stopping at zero.
	_jump_buffer_timer = move_toward(_jump_buffer_timer, 0.0, delta)

	# 2. Remember a fresh jump press.
	if Input.is_action_just_pressed(&"jump"):
		_jump_buffer_timer = jump_buffer_time

	# 3. On the floor with time left? Jump once.
	if _jump_buffer_timer > 0.0 and is_on_floor():
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0

	# 4. Normal gravity and movement.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
