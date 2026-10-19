extends CharacterBody2D
## Paces back and forth between two x positions.

@export var speed := 120.0
@export var left := 620.0
@export var right := 900.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if velocity.x == 0.0:
		velocity.x = speed
	if global_position.x > right:
		velocity.x = -speed
	elif global_position.x < left:
		velocity.x = speed
	move_and_slide()
