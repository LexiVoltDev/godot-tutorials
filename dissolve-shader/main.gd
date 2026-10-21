extends Node2D

# Press Space (ui_accept) to burn the next card, left to right.


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		for card in $Cards.get_children():
			if not card.is_queued_for_deletion():
				card.burn()
				return
