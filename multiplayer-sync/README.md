# Multiplayer Sync: MultiplayerSpawner + MultiplayerSynchronizer (Godot 4.8 beta 1)

From the Lexi Volt Godot tutorial on two-window multiplayer with zero hand-written RPCs. Video coming soon.

## What it shows

One window hosts, another joins, and each player moves their own square in both windows.
Your own square is green. Two nodes do all the networking: a `MultiplayerSpawner` creates
the players on every peer, and a `MultiplayerSynchronizer` sends each player's position from
its owner to everyone else. There is no `rpc()` anywhere in the project.

## Godot version

Tested on **Godot 4.8 beta 1** (4.8.beta1.official.4d10419ca), Compatibility renderer, two
instances on one machine. The spawner, synchronizer and ENet code is plain Godot 4 API. The
one 4.8-only bit is the project setting
`input_devices/joypads/ignore_joypad_on_unfocused_application` (on here), which 4.8 turns on
for new projects. 4.8 is a beta, so names can still change.

## How to run

1. Open Godot 4.8 beta 1.
2. In the Project Manager, click **Import** and pick `multiplayer-sync/project.godot`.
3. Open **Debug > Customize Run Instances...**, tick **Enable Multiple Instances**, and set it to 2.
4. Press **Play** (F5). Two windows open.
5. Click **Host** in one window and **Join** in the other.
6. Click a window to focus it and use the **arrow keys** to move your green square.

It uses UDP port 7000 on 127.0.0.1 (your own machine). If your firewall asks when you host,
allow it for the local test.

## Files

- `main.gd`: host, join and spawning (steps 1 to 4 in the video).
- `player.gd`: authority and movement (steps 5 and 6).
- `main.tscn`: Main with Players, MultiplayerSpawner (Spawn Path = Players, Auto Spawn List
  left empty on purpose, since the spawn function handles it) and the Host / Join menu.
- `player.tscn`: the player square with a MultiplayerSynchronizer syncing `position`
  (Spawn and Replicate on).

## The code

```gdscript
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
```

```gdscript
extends CharacterBody2D

const SPEED := 300.0


# 5. The name is the peer id. Hand that peer authority in _enter_tree, before anything syncs.
func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	if is_multiplayer_authority():
		$Body.color = Color.SPRING_GREEN


# 6. Only the authority reads input and moves. Everyone else just receives position.
func _physics_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return
	velocity = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down") * SPEED
	move_and_slide()
```

## Good to know

- Set the authority in `_enter_tree`, not `_ready`. In `_ready` the client prints an error that
  the MultiplayerSynchronizer "has no network ID", because the spawn has already happened.
- Skipping the spawn function (Auto Spawn List plus `position` and `add_child` on the server)
  looks like less code, but in our test the client's square ignored its start position and
  ended up off-screen at the top-left, in both windows.
- Only the focused window gets keyboard input.

## Credits & licenses

No third-party assets. All visuals are built-in nodes (ColorRects and default-theme buttons);
no fonts, images or audio. Code and scenes: Lexi Volt, MIT (see the repo [LICENSE](../LICENSE)).
