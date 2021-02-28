extends Label


signal new_letter
signal finished


export var texts := PoolStringArray()
export var delays := PoolRealArray()
export var letter_delay := 0.1


func _ready() -> void:
	text = ""
	assert(len(texts) == len(delays) - 1, "There must be N + 1 delays compared to texts")
	yield(get_tree().create_timer(delays[0]), "timeout")
	for i in len(texts):
		text = ""
		for t in texts[i]:
			text += t
			if t == " ":
				continue
			emit_signal("new_letter")
			yield(get_tree().create_timer(letter_delay), "timeout")
		yield(get_tree().create_timer(delays[i + 1]), "timeout")
	text = ""
	emit_signal("finished")
