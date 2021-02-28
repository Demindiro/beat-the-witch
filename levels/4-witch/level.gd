extends Wowie30_Level


func save_state():
	return {"eaten_cookie": has_eaten_cookie(), "witch_gone": is_witch_gone()}


func restore_state(state) -> void:
	var witch_gone := false
	if state != null:
		witch_gone = state["witch_gone"]
		if state["eaten_cookie"]:
			get_node("Cookie").queue_free()

	if witch_gone:
		get_node("Witch").queue_free()
		get_node("Witch dialogue").queue_free()
		get_node("Cookie").visible = true
	else:
		emit_signal("disable_player_movement", true)
		emit_signal("disable_music", true)


func has_eaten_cookie() -> bool:
	return not has_node("Cookie")


func is_witch_gone() -> bool:
	return not has_node("Witch")


func enable_player_movement() -> void:
	emit_signal("disable_player_movement", false)
	emit_signal("disable_music", false)
