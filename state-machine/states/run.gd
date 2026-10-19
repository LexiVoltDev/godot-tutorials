extends State

@export var speed: float = 300.0


func physics_update(_delta: float) -> void:
	var direction: float = Input.get_axis(&"move_left", &"move_right")
	actor.velocity.x = direction * speed
	actor.move_and_slide()
	if not actor.is_on_floor():
		finished.emit(&"Fall")
	elif Input.is_action_just_pressed(&"jump"):
		finished.emit(&"Jump")
	elif is_zero_approx(direction):
		finished.emit(&"Idle")
