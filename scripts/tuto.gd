extends Node2D
@onready var player: CharacterBody2D = $player
@onready var text_canva: CanvasLayer = $text_canva

var time_spent_in_level: float = 0.0

var spawn_pos=Vector2(228,452)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.position=spawn_pos
	await get_tree().create_timer(5.0).timeout
	text_canva.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_spent_in_level+= delta

func formater_temps() -> String:
	print(time_spent_in_level)
	var secondes=time_spent_in_level
	var minutes = int(secondes) / 60
	var secs = int(secondes) % 60
	return "%02d:%02d" % [minutes, secs]
