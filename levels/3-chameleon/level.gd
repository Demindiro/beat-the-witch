extends Wowie30_Level


func save_state():
	return get_node("Chameleon").kill_count


func restore_state(state) -> void:
	if state != null:
		var c = get_node("Chameleon")
		c.kill_count = state
		if c.kill_count >= c.max_kills:
			c.sleep()
