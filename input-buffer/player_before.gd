extends CharacterBody2D

@export var jump_velocity: float = -400.0

func _physics_process(delta: float) -> void:
	# Jump only if the press happens while already on the floor.
	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		velocity.y = jump_velocity

	# Normal gravity and movement.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
