# Builds res://level.tscn plus 10 star chunks in res://chunks/. Heavy on purpose (20,000 stars),
# so the load takes about a second and the progress bar has real steps to show.
# Run once from the project folder: godot --headless -s res://tools/make_level.gd
extends SceneTree

const CHUNKS := 10
const STARS_PER_CHUNK := 2000


func _init() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 24
	DirAccess.make_dir_recursive_absolute("res://chunks")
	var level := Node2D.new()
	level.name = "Level"
	var sky := ColorRect.new()
	sky.name = "Sky"
	sky.color = Color(0.05, 0.02, 0.12)
	sky.size = Vector2(1152, 648)
	_own(level, sky)
	var stars := Node2D.new()
	stars.name = "Stars"
	_own(level, stars)
	for c in CHUNKS:
		var chunk := Node2D.new()
		chunk.name = "Chunk%d" % c
		for i in STARS_PER_CHUNK:
			var star := Polygon2D.new()
			var r := rng.randf_range(1.0, 3.5)
			var points := PackedVector2Array()
			for k in 6:
				points.append(Vector2.from_angle(TAU * k / 6.0) * r)
			star.polygon = points
			star.position = Vector2(rng.randf_range(0, 1152), rng.randf_range(0, 648))
			star.color = Color.from_hsv(rng.randf_range(0.5, 0.9), 0.6, 1.0)
			_own(chunk, star)
		var path := "res://chunks/chunk_%d.tscn" % c
		var packed := PackedScene.new()
		packed.pack(chunk)
		ResourceSaver.save(packed, path)
		chunk.free()
		var inst: Node = load(path).instantiate()
		stars.add_child(inst)
		inst.owner = level
	var label := Label.new()
	label.name = "Title"
	label.text = "LEVEL LOADED"
	label.position = Vector2(470, 300)
	label.add_theme_font_size_override("font_size", 40)
	_own(level, label)
	var scene := PackedScene.new()
	scene.pack(level)
	print("saved level: ", ResourceSaver.save(scene, "res://level.tscn"))
	level.free()
	quit()


func _own(parent: Node, child: Node) -> void:
	parent.add_child(child)
	child.owner = parent
