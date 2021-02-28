extends KinematicBody2D


export var gravity := 9.81
export var vertical_velocity := 0.0
export var max_vertical_velocity := 300.0


func _physics_process(delta: float) -> void:
	vertical_velocity += gravity * delta
	move_and_slide(Vector2.DOWN * vertical_velocity, Vector2.UP)
	if is_on_floor():
		vertical_velocity = 0.0
