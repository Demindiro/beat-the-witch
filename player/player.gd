extends KinematicBody2D
class_name Wowie3_Player


signal died


export var speed := 32.0
export var gravity := 9.81
export var min_jump_height := 96.0

export var corpse: PackedScene

var vertical_velocity := 0.0


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

	move_and_slide(Vector2(move * speed, vertical_velocity), Vector2.UP)
	if vertical_velocity > 0.0 and is_on_floor():
		vertical_velocity = 0.0
	elif vertical_velocity < 0.0 and is_on_ceiling():
		vertical_velocity = 0.0
	else:
		vertical_velocity += delta * gravity


func kill() -> void:
	var n: Node2D = corpse.instance()
	n.position = get_node("Corpse").global_transform.origin
	n.vertical_velocity = vertical_velocity
	get_parent().add_child(n)
	queue_free()
	emit_signal("died")
