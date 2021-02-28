extends Sprite


signal killed


func entered(body: Node) -> void:
	var p := body as Wowie3_Player
	if p != null:
		p.kill()
		queue_free()
		emit_signal("killed")
