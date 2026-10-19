extends CharacterBody2D
## Arrows move, Space jumps. Falls into the pit if you let it.

const SPEED := 260.0
const JUMP := -520.0
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP
	velocity.x = Input.get_axis("ui_left", "ui_right") * SPEED
	move_and_slide()
