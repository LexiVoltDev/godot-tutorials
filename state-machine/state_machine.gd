# state_machine.gd: owns the states and runs exactly one at a time.
class_name StateMachine
extends Node

signal state_changed(from: StringName, to: StringName)

@export var initial_state: State

var current: State
var _states: Dictionary[StringName, State] = {}


func _ready() -> void:
	# 2. Collect child states by node name and listen for their requests.
	for child: Node in get_children():
		if child is State:
			var state := child as State
			state.actor = owner as CharacterBody2D
			state.finished.connect(_transition_to)
			_states[state.name] = state
	# 3. Wait until the owner is ready, then enter the first state.
	await owner.ready
	current = initial_state
	current.enter()


func _physics_process(delta: float) -> void:
	# 4. Only the current state runs.
	if current:
		current.physics_update(delta)


func _transition_to(next_state: StringName) -> void:
	# 5. Exit, swap, enter. One place, every time.
	if not _states.has(next_state):
		push_error("Unknown state: %s" % next_state)
		return
	var previous: StringName = current.name
	current.exit()
	current = _states[next_state]
	current.enter()
	state_changed.emit(previous, next_state)
