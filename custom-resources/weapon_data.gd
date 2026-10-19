class_name WeaponData
extends Resource

# 1. Export the data.
@export var display_name: String = "Sword"
@export_range(1, 999) var damage: int = 10
@export_range(0.1, 10.0, 0.1, "suffix:s")
var cooldown: float = 0.5

# 2. Setter clamps and announces.
@export var durability: int = 100:
	set(value):
		durability = maxi(value, 0)
		emit_changed()


# 3. Behavior lives with the data.
func hit() -> int:
	durability -= 1
	@warning_ignore("integer_division")
	return damage if durability > 0 else damage / 2
