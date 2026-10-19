extends State


func physics_update(delta: float) -> void:
	actor.velocity += actor.get_gravity() * delta
	actor.move_and_slide()
	if actor.is_on_floor():
		finished.emit(&"Idle")
