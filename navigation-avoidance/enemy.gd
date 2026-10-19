extends CharacterBody2D

@export var speed: float = 200.0
@export var goal: Vector2 = Vector2(1000, 100)
# 5. Tuning.
@export var path_desired_distance: float = 24.0
@export var target_desired_distance: float = 40.0
@export var radius: float = 14.0
@export var max_speed: float = 200.0

var agent: NavigationAgent2D


func _ready() -> void:
	agent = $NavigationAgent2D as NavigationAgent2D
	agent.avoidance_enabled = true
	agent.path_desired_distance = path_desired_distance
	agent.target_desired_distance = target_desired_distance
	agent.radius = radius
	agent.max_speed = max_speed
	agent.velocity_computed.connect(_on_velocity_computed)
	# 2. Wait for the navigation map to sync. One physics frame isn't always enough.
	while NavigationServer2D.map_get_iteration_id(agent.get_navigation_map()) == 0:
		await get_tree().physics_frame
	agent.target_position = goal


func _physics_process(_delta: float) -> void:
	# 3. Follow the path: stop when finished, else steer to the next point.
	if agent.is_navigation_finished():
		agent.velocity = Vector2.ZERO
		return
	var next: Vector2 = agent.get_next_path_position()
	var desired: Vector2 = global_position.direction_to(next) * speed
	# 4. Avoidance: hand the agent our desired velocity, move with the safe one.
	agent.velocity = desired


func _on_velocity_computed(safe_velocity: Vector2) -> void:
	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return
	velocity = safe_velocity
	move_and_slide()
