extends Node2D
# Spawns a few coins at runtime. They have no owner, so keep_edits.gd leaves them out.

func _ready() -> void:
	for i in 3:
		var coin := Polygon2D.new()
		coin.name = "Coin%d" % i
		coin.color = Color(1.0, 0.85, 0.2)
		coin.polygon = PackedVector2Array([Vector2(0, -12), Vector2(12, 0), Vector2(0, 12), Vector2(-12, 0)])
		coin.position = Vector2(420 + i * 60, 360)
		add_child(coin)
