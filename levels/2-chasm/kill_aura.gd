extends Area2D


func entered(body: Node) -> void:
	var p := body as Wowie3_Player
	if p != null:
		p.kill()
