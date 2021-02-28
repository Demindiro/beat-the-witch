extends Wowie30_Level


func save_state():
	return {"eaten_cookie": has_eaten_cookie(), "witch_gone": is_witch_gone()}


func restore_state(state) -> void:
	if state != null:
		if state["witch_gone"]:
			get_node("Witch").queue_free()
			get_node("Witch dialogue").queue_free()
			get_node("Cookie").visible = true
		if state["eaten_cookie"]:
			get_node("Cookie").queue_free()


func has_eaten_cookie() -> bool:
	return not has_node("Cookie")


func is_witch_gone() -> bool:
	return not has_node("Witch")
