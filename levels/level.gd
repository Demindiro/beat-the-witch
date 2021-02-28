extends TileMap
class_name Wowie30_Level

signal change_level(to)

func change_level(to: String, direction: int) -> void:
	emit_signal("change_level", to, direction)

func save_state():
	return null

func restore_state(_state) -> void:
	pass
