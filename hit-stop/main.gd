extends Node2D
## Demo arena. J = light hit (10), K = big hit (60), L = parry (10, parry).

var enemy_speed := 220.0
var enemy_dir := 1.0

@onready var camera: Camera2D = $Camera2D
@onready var enemy: ColorRect = $Enemy
@onready var flash: ColorRect = $UI/Flash
@onready var combo_label: Label = $UI/ComboLabel
@onready var combo_timer: Timer = $UI/ComboTimer

var combo := 0


func _ready() -> void:
	HitStop.camera = camera
	HitStop.flash = flash
	# 3. UI timers should run on real time, or the combo window freezes too.
	combo_timer.ignore_time_scale = true
	combo_timer.timeout.connect(_on_combo_timeout)


func _process(delta: float) -> void:
	# Moves on scaled delta, so it visibly freezes during hit-stop.
	enemy.position.x += enemy_speed * enemy_dir * delta
	if enemy.position.x > 900.0 or enemy.position.x < 200.0:
		enemy_dir = -enemy_dir


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.keycode:
			KEY_J:
				_attack(10.0, false)
			KEY_K:
				_attack(60.0, false)
			KEY_L:
				_attack(10.0, true)


func _attack(damage: float, parry: bool) -> void:
	combo += 1
	combo_label.text = "COMBO x%d" % combo
	combo_timer.start()
	HitStop.hit(damage, parry)


func _on_combo_timeout() -> void:
	combo = 0
	combo_label.text = ""
