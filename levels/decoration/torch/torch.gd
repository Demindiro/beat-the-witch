tool
extends AnimatedSprite


func _ready() -> void:
	# Randomize because having torches play the exact same sequence in sync
	# looks weird
	frame = randi() % frames.get_frame_count("default")
