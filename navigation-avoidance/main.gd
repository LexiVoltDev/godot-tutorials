extends Node2D

func _ready() -> void:
	# 1. Bake the navmesh. agent_radius keeps bodies off the walls.
	var region: NavigationRegion2D = $NavigationRegion2D as NavigationRegion2D
	var polygon := NavigationPolygon.new()
	polygon.agent_radius = 16.0
	var outer := PackedVector2Array([
		Vector2(0, 0),
		Vector2(1152, 0),
		Vector2(1152, 648),
		Vector2(0, 648),
	])
	# Wall hole. Same rectangle as the solid body.
	var wall := PackedVector2Array([
		Vector2(500, 200),
		Vector2(652, 200),
		Vector2(652, 648),
		Vector2(500, 648),
	])
	var geometry := NavigationMeshSourceGeometryData2D.new()
	geometry.add_traversable_outline(outer)
	geometry.add_obstruction_outline(wall)
	NavigationServer2D.bake_from_source_geometry_data(polygon, geometry)
	polygon.add_outline(outer)
	polygon.add_outline(wall)
	region.navigation_polygon = polygon
