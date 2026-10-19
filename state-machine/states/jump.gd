extends State

@export var jump_velocity: float = -400.0


func enter() -> void:
	actor.velocity.y = jump_velocity


func physics_update(delta: float) -> void:
	actor.velocity += actor.get_gravity() * delta
	actor.move_and_slide()
	if actor.velocity.y >= 0.0:
		finished.emit(&"Fall")
