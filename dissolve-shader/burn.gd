extends Sprite2D

@export var burn_time: float = 1.2


func _ready() -> void:
	# Give every copy its own material, or they all burn together.
	material = material.duplicate()


func burn() -> void:
	# 6. Burn it: tween progress from 0 to 1, then free the node.
	var tween := create_tween()
	tween.tween_property(material, "shader_parameter/progress", 1.0, burn_time)
	tween.tween_callback(queue_free)
