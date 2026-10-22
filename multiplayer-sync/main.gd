extends Node2D

const PORT := 7000
const ADDRESS := "127.0.0.1"

@export var player_scene: PackedScene

@onready var spawner: MultiplayerSpawner = $MultiplayerSpawner


# 1. Every peer builds players the same way, from the same small piece of data.
func _ready() -> void:
	spawner.spawn_function = _build_player


# 2. Host: open a server, then spawn a player for every peer, starting with yourself.
func _on_host_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	multiplayer.peer_disconnected.connect(_remove_player)
	_add_player(multiplayer.get_unique_id())
	$Menu.hide()


# 3. Join: connect as a client. No spawning here. The server does that.
func _on_join_pressed() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = peer
	$Menu.hide()


# 4. Server only: spawn() runs _build_player here AND on every client.
func _add_player(id: int) -> void:
	spawner.spawn([id, Vector2(240 + 160 * $Players.get_child_count(), 270)])


func _build_player(data: Array) -> Node:
	var player := player_scene.instantiate()
	player.name = str(data[0])
	player.position = data[1]
	return player


func _remove_player(id: int) -> void:
	var player := $Players.get_node_or_null(str(id))
	if player:
		player.queue_free()
