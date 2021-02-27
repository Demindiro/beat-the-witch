extends KinematicBody2D


export var speed := 32.0
export var gravity := 9.81
export var min_jump_height := 96.0

var vertical_velocity := 0.0


func _physics_process(delta: float):
	var move := 0
	if Input.is_action_pressed("move_left"):
		move -= 1
	if Input.is_action_pressed("move_right"):
		move += 1
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
