extends Node2D


func _ready() -> void:
	var a := load("res://sword.tres")
	var b := load("res://sword.tres")
	print("same object: ", a == b)
	for i in 3:
		$EnemyA.attack()
	print("EnemyA: ", $EnemyA.weapon.durability)
	print("EnemyB: ", $EnemyB.weapon.durability)
	print("file: ", a.durability)
