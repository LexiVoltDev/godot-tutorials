extends State


func enter() -> void:
	actor.velocity.x = 0.0


func physics_update(_delta: float) -> void:
	if not actor.is_on_floor():
		finished.emit(&"Fall")
	elif Input.is_action_just_pressed(&"jump"):
		finished.emit(&"Jump")
	elif not is_zero_approx(Input.get_axis(&"move_left", &"move_right")):
		finished.emit(&"Run")
