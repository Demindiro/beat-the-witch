extends Node


signal corpses_cleared


# I don't know why, but class_name flat out doesn't work :/
const Wowie3_Level = preload("levels/level.gd")
const Wowie3_Player = preload("player/player.gd")

export var level_width := 512
export var player_scene: PackedScene
export var corpse_scene: PackedScene

onready var level: Wowie3_Level = get_node("Level")
onready var player: Wowie3_Player = get_node("Player")

onready var old_player_position := player.position

var corpses_per_level := {}


func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("clear_corpses"):
		clear_corpses()


func change_level(to: String, direction: int) -> void:
	print("Changing level to ", to)

	var corpses := []
	for c in get_tree().get_nodes_in_group("corpses"):
		corpses.push_back([c.position, c.flip_h])
		c.queue_free()
	corpses_per_level[level.filename] = corpses

	# Deferred to prevent teleporting the player into a wall from the previous level
	old_player_position = player.position - Vector2(direction * level_width, 0)
	player.set_deferred("position", old_player_position)

	level.queue_free()
	level = load(to).instance()
	var e := level.connect("change_level", self, "change_level")
	assert(e == OK)
	call_deferred("add_child", level)

	for p in corpses_per_level.get(to, PoolVector2Array()):
		var c: Node2D = corpse_scene.instance()
		c.position = p[0]
		c.flip_h = p[1]
		c.play_sound = false
		call_deferred("add_child", c)


func respawn() -> void:
	yield(get_tree().create_timer(1.5), "timeout")
	player = player_scene.instance()
	player.position = old_player_position
	add_child(player)
	var e := player.connect("died", self, "respawn")
	assert(e == OK)


func clear_corpses() -> void:
	var cleared_something := false
	for c in get_tree().get_nodes_in_group("corpses"):
		c.queue_free()
		cleared_something = true
	if cleared_something:
		emit_signal("corpses_cleared")
