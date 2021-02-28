extends Sprite


# TODO figure out why class_name is broken
const Wowie3_Player = preload("res://player/player.gd")


func body_entered(node: Node) -> void:
	var player := node as Wowie3_Player
	if player != null:
		player.kill()
