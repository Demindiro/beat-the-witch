extends Label


signal new_letter
signal finished


export var texts := PoolStringArray()
export var delays := PoolRealArray()
export var letter_delay := 0.1


# godot pls fix timer
var timer: SceneTreeTimer = null


func _ready() -> void:
	text = ""
	assert(len(texts) == len(delays) - 1, "There must be N + 1 delays compared to texts")
	timer = get_tree().create_timer(delays[0]) 
	yield(timer, "timeout")
	for i in len(texts):
		text = ""
		for t in texts[i]:
			text += t
			if t == " ":
				continue
			emit_signal("new_letter")
			timer = get_tree().create_timer(letter_delay)
			yield(timer, "timeout")
		timer = get_tree().create_timer(delays[i + 1]) 
		yield(timer, "timeout")
	text = ""
	emit_signal("finished")


func _exit_tree() -> void:
	if timer != null:
		for s in timer.get_signal_connection_list("timeout"):
			timer.disconnect(s["signal"], s["target"], s["method"])
