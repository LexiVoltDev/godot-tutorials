extends Node2D

@export var weapon: WeaponData


func _ready() -> void:
	# 4. Duplicate before you change it.
	weapon = weapon.duplicate()
	# 5. React to changes, no polling.
	weapon.changed.connect(_on_changed)


func attack() -> int:
	return weapon.hit()


func _on_changed() -> void:
	var w := weapon
	print(name, " ", w.display_name,
		" durability: ", w.durability)
