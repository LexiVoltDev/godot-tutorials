extends CharacterBody2D

const SPEED := 300.0


# 5. The name is the peer id. Hand that peer authority in _enter_tree, before anything syncs.
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		$Body.color = Color.SPRING_GREEN


# 6. Only the authority reads input and moves. Everyone else just receives position.
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
