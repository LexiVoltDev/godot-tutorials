extends CanvasLayer
## Debug overlay: shows the player's _jump_buffer_timer counting down live.

@export var player: CharacterBody2D

@onready var value_label: Label = $Value
@onready var bar: ColorRect = $Bar

func _process(_delta: float) -> void:
	if player == null or not "_jump_buffer_timer" in player:
		return
	var b: float = player._jump_buffer_timer
	value_label.text = "_jump_buffer_timer = %.3f s" % b
	bar.size.x = 800.0 * b / player.jump_buffer_time
