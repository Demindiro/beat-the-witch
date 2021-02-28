extends KinematicBody2D
class_name Wowie3_Player


signal died
signal jumped
signal stepped

export var speed := 32.0
export var gravity := 9.81
export var min_jump_height := 96.0

export var corpse: PackedScene

onready var sprite: AnimatedSprite = get_node("AnimatedSprite")
onready var corpse_position: Node2D = get_node("Corpse")

var vertical_velocity := 0.0
var killed := false

var _is_on_floor_buffer := 0


func _physics_process(delta: float):
	if Input.is_action_pressed("suicide"):
		kill()
		return

	var move := 0
	if Input.is_action_pressed("move_left"):
		move -= 1
	if Input.is_action_pressed("move_right"):
		move += 1
	# TODO is_on_floor() is actually incorrect in this case but what can I do?
	if Input.is_action_pressed("jump") and is_on_floor():
		# v - g * t = 0 <=> t = v / g
		#
		# x = v * t - g * t^2 / 2
		#   = v * v / g - g * (v^2 / g^2) / 2
		#   = v^2 / g - v^2 / g / 2
		#   = v^2 / g / 2
		# <=> v = sqrt(2 * x * g)
		vertical_velocity = -sqrt(2 * min_jump_height * gravity)
		emit_signal("jumped")

	move_and_slide(Vector2(move * speed, vertical_velocity), Vector2.UP)

	# >:( godot pls
	if is_on_floor():
		_is_on_floor_buffer = 2
	elif _is_on_floor_buffer > 0:
		_is_on_floor_buffer -= 1
	
	if move != 0:
		sprite.flip_h = move < 0
		corpse_position.position.x = move * abs(corpse_position.position.x)

	var next_anim: String
	if move != 0 and _is_on_floor_buffer:
		next_anim = "walking"
	elif not _is_on_floor_buffer:
		next_anim = "jumping"
	else:
		next_anim = "idle"
	if sprite.animation != next_anim:
		sprite.animation = next_anim
		frame_changed()

	if vertical_velocity > 0.0 and is_on_floor():
		vertical_velocity = 0.0
	elif vertical_velocity < 0.0 and is_on_ceiling():
		vertical_velocity = 0.0
	else:
		vertical_velocity += delta * gravity


func kill(spawn_corpse := true) -> void:
	if killed:
		return
	killed = true
	if spawn_corpse:
		var n: Node2D = corpse.instance()
		n.position = get_node("Corpse").global_transform.origin
		n.vertical_velocity = vertical_velocity
		n.flip_h = sprite.flip_h
		get_parent().call_deferred("add_child", n)
	queue_free()
	emit_signal("died")


func frame_changed() -> void:
	if sprite.animation == "walking" and sprite.frame % 2 == 0:
		emit_signal("stepped")


func disable_movement(value: bool) -> void:
	set_physics_process(not value)
	if value:
		sprite.animation = "idle"
