extends Node
## HitStop autoload: freeze, flash, shake, audio dip. Godot 4.4+.
## Call HitStop.hit(damage) or HitStop.hit(damage, true) for a parry.

# 4. Freeze length scales with damage.
@export var base_freeze := 0.04
@export var freeze_per_damage := 0.002
@export var max_freeze := 0.16
# 7. Parries and big hits get extra.
@export var big_hit_damage := 40.0
@export var big_hit_bonus := 1.5
@export var parry_bonus := 2.0
# 2. The docs say keep time_scale above 0.0, so freeze to "almost zero".
@export var frozen_scale := 0.02
# 5. Your own "Juice" slider: 0.0 is off, 2.0 is double.
@export_range(0.0, 2.0) var shake_scale := 1.0
# 6. Audio during the freeze.
@export var duck_bus := "Master"
@export var duck_db := -8.0
@export var audio_speed := 0.8

var camera: Camera2D
var flash: ColorRect
var _token := 0
var _pause_token := 0
var _ducked := false
var _saved_db := 0.0
var _flash_tween: Tween


func freeze_for(damage: float, parry := false) -> float:
	var sec := clampf(base_freeze + damage * freeze_per_damage, base_freeze, max_freeze)
	if damage >= big_hit_damage:
		sec *= big_hit_bonus
	if parry:
		sec *= parry_bonus
	return sec


# 8. One call per hit. The newest hit wins.
func hit(damage: float, parry := false) -> void:
	var sec: float = freeze_for(damage, parry)
	_token += 1
	var my_token := _token
	Engine.time_scale = frozen_scale
	_audio_dip(true)
	_flash(sec, parry)
	# 3. This timer ignores time_scale, so it wakes up on real time.
	await get_tree().create_timer(sec, true, false, true).timeout
	if my_token != _token:
		return
	Engine.time_scale = 1.0
	_audio_dip(false)
	_shake(clampf(damage * 0.25, 2.0, 12.0) * shake_scale, my_token)


# 2. The other way: pause the tree. Only PROCESS_MODE_ALWAYS nodes keep running.
func freeze_with_pause(sec: float) -> void:
	_pause_token += 1
	var my_pause := _pause_token
	get_tree().paused = true
	await get_tree().create_timer(sec, true).timeout
	if my_pause == _pause_token:
		get_tree().paused = false


# 5. Flash during the freeze, on a tween that ignores time_scale.
func _flash(sec: float, parry: bool) -> void:
	if flash == null:
		return
	if _flash_tween:
		_flash_tween.kill()
	flash.modulate.a = 1.0 if parry else 0.5
	_flash_tween = create_tween().set_ignore_time_scale()
	_flash_tween.tween_interval(sec)
	_flash_tween.tween_property(flash, "modulate:a", 0.0, 0.12)


# 5. Shake after the freeze, decaying every frame.
func _shake(strength: float, my_token: int) -> void:
	if camera == null:
		return
	for _i in 6:
		if my_token != _token:
			return
		camera.offset = Vector2(randf_range(-strength, strength), randf_range(-strength, strength))
		strength *= 0.6
		await get_tree().process_frame
	camera.offset = Vector2.ZERO


# 6. Duck the bus and slow the audio while frozen; restore on release.
func _audio_dip(on: bool) -> void:
	var bus := AudioServer.get_bus_index(duck_bus)
	if bus == -1 or on == _ducked:
		return
	_ducked = on
	if on:
		_saved_db = AudioServer.get_bus_volume_db(bus)
		AudioServer.set_bus_volume_db(bus, _saved_db + duck_db)
		AudioServer.playback_speed_scale = audio_speed
	else:
		AudioServer.set_bus_volume_db(bus, _saved_db)
		AudioServer.playback_speed_scale = 1.0
