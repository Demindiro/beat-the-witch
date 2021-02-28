extends Area2D

signal change_level(to)

export(String, FILE, "*.tscn") var to: String
export(int, "Left", "Right") var direction: int

func entered(_body: Node) -> void:
	emit_signal("change_level", to, direction * 2 - 1)
