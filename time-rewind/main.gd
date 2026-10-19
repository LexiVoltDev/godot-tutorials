extends Node2D
## Demo: arrows move, Space jumps, hold R (or Shift) to rewind.

@onready var fx: ColorRect = $FX/Desaturate
@onready var died: Label = $UI/Died
@onready var cap: Label = $UI/Cap
@onready var player: CharacterBody2D = $Player


func _ready() -> void:
	if not InputMap.has_action("rewind"):
		InputMap.add_action("rewind")
		for key in [KEY_R, KEY_SHIFT]:
			var ev := InputEventKey.new()
			ev.physical_keycode = key
			InputMap.action_add_event("rewind", ev)


# 4. Main runs before its children, so the switch flips before anyone records.
func _physics_process(_delta: float) -> void:
	set_rewinding(Input.is_action_pressed("rewind"))
	died.visible = player.global_position.y > 600.0
	cap.text = "buffer %d / %d" % [$Player/Rewindable.snapshot_count(), Rewindable.MAX_SNAPSHOTS]


func set_rewinding(on: bool) -> void:
	if on == Rewindable.rewinding:
		return
	Rewindable.rewinding = on
	get_tree().call_group("rewindable", "set_frozen", on)
	# 5. Polish: desaturate the screen and drop the audio pitch.
	fx.material.set_shader_parameter("amount", 1.0 if on else 0.0)
	AudioServer.playback_speed_scale = 0.6 if on else 1.0
