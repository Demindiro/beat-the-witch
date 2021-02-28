extends Node2D


signal eat
signal kill
signal sleeping

export var max_kills := 1

onready var body: AnimatedSprite = get_node("Body")
onready var tongue: AnimationPlayer = get_node("Tongue animation") 
onready var tongue_tip: Node2D = get_node("Tongue/Tip")

var kill_count := 0

var player: Wowie3_Player = null


func eat(p_player: Wowie3_Player) -> void:
	tongue.play("stick_tongue")
	body.animation = "eating"
	player = p_player
	emit_signal("eat")


func entered(b: Node) -> void:
	if body.animation == "sleeping":
		return
	var p := b as Wowie3_Player
	if p != null:
		eat(p)


func animation_finished(name: String) -> void:
	if name == "stick_tongue":
		body.animation = "idle"
		player.kill(false)
		player = null
		kill_count += 1
		emit_signal("kill")
		if kill_count >= max_kills:
			emit_signal("sleeping")


func _process(_delta: float) -> void:
	if player != null:
		player.global_transform.origin = tongue_tip.global_transform.origin
