extends Node2D
## Visual effects only (no gameplay): variant label, JUMP button light-up,
## red X for an ignored early press, landing dust, and squash & stretch.

@export var player: CharacterBody2D

const CYAN := Color(0.1, 0.95, 1.0)
const PINK := Color(1.0, 0.35, 0.6)
const GREEN := Color(0.45, 1.0, 0.4)

var _was_pressed := false
var _was_on_floor := false
var _air_press := false
var _check_frames := -1
var _button: Panel
var _button_style: StyleBoxFlat
var _button_label: Label
var _button_light := 0.0
var _tween: Tween
@onready var _visual: Node2D = player.get_node("Visual")

func _ready() -> void:
	# AFTER when the player uses the buffered script, BEFORE otherwise.
	var after: bool = "_jump_buffer_timer" in player
	var ui := CanvasLayer.new()
	add_child(ui)
	_make_label(ui, "AFTER" if after else "BEFORE", 110, CYAN if after else PINK, 140)
	_make_label(ui, "0.15s jump buffer" if after else "no buffer", 50, Color.WHITE, 270)
	_button = Panel.new()
	_button.position = Vector2(390, 360)
	_button.size = Vector2(300, 120)
	_button_style = StyleBoxFlat.new()
	_button_style.set_corner_radius_all(28)
	_button_style.set_border_width_all(6)
	_button.add_theme_stylebox_override("panel", _button_style)
	ui.add_child(_button)
	_button_label = _make_label(_button, "JUMP", 64, Color.WHITE, 0)
	_button_label.size = _button.size
	_set_button(0.0)

func _make_label(parent: Node, text: String, font_size: int, color: Color, y: float) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color(0.05, 0.03, 0.1))
	l.add_theme_constant_override("outline_size", 14)
	l.position = Vector2(0, y)
	l.size = Vector2(1080, font_size * 1.3)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	parent.add_child(l)
	return l

func _set_button(k: float) -> void:
	_button_style.bg_color = Color(0.15, 0.1, 0.25).lerp(Color(1.0, 0.85, 0.15), k)
	_button_style.border_color = Color(0.5, 0.45, 0.6).lerp(Color.WHITE, k)
	_button_label.add_theme_color_override("font_color", Color(0.75, 0.7, 0.85).lerp(Color(0.1, 0.05, 0.15), k))
	_button.scale = Vector2.ONE * (1.0 + 0.08 * k)
	_button.pivot_offset = _button.size / 2.0

func _physics_process(delta: float) -> void:
	var pressed := Input.is_action_pressed(&"jump")
	var on_floor := player.is_on_floor()
	if pressed and not _was_pressed:
		_button_light = 1.0
		if not on_floor:
			_air_press = true
	_was_pressed = pressed
	_button_light = maxf(_button_light - delta * 2.5, 0.0)
	_set_button(_button_light)

	if on_floor and not _was_on_floor:
		_land()
		if _air_press:
			_check_frames = 3
		_air_press = false
	elif not on_floor and _was_on_floor and player.velocity.y < 0.0:
		_squash(Vector2(0.75, 1.3))
	_was_on_floor = on_floor

	if _check_frames > 0:
		_check_frames -= 1
		if _check_frames == 0:
			if player.is_on_floor():
				_popup("X", Color(1.0, 0.2, 0.25), 20)
			else:
				_popup("JUMP!", GREEN, 9)

func _land() -> void:
	_squash(Vector2(1.4, 0.65))
	var dust := CPUParticles2D.new()
	dust.position = player.position
	dust.one_shot = true
	dust.explosiveness = 0.9
	dust.amount = 14
	dust.lifetime = 0.45
	dust.direction = Vector2.UP
	dust.spread = 80.0
	dust.initial_velocity_min = 25.0
	dust.initial_velocity_max = 55.0
	dust.gravity = Vector2(0, 60)
	dust.scale_amount_min = 1.5
	dust.scale_amount_max = 3.0
	dust.color = Color(0.95, 0.9, 0.8, 0.9)
	dust.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	dust.emission_rect_extents = Vector2(8, 1)
	add_child(dust)
	dust.emitting = true
	get_tree().create_timer(1.0).timeout.connect(dust.queue_free)

func _squash(s: Vector2) -> void:
	if _tween:
		_tween.kill()
	_visual.scale = s
	_tween = create_tween()
	_tween.tween_property(_visual, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _popup(text: String, color: Color, font_size: int) -> void:
	# Text is rasterised large, then scaled down in world space so it stays crisp under camera zoom.
	var is_x := text == "X"
	var raster := 1.0 if is_x else 10.0
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", int(font_size * raster))
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color.WHITE if is_x else Color(0.05, 0.03, 0.1))
	l.add_theme_constant_override("outline_size", 4 if is_x else 16)
	l.size = Vector2(80, 40) * raster
	l.scale = Vector2.ONE / raster
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	l.position = player.position + Vector2(-40, -52)
	l.z_index = 20
	add_child(l)
	var tw := create_tween()
	tw.tween_interval(0.5)
	tw.tween_property(l, "modulate:a", 0.0, 0.3)
	tw.tween_callback(l.queue_free)
