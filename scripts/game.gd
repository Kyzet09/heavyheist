extends Node2D
@onready var player: CharacterBody2D = $player
@onready var text_canva: CanvasLayer = $text_canva
@export var spawn_room: PackedScene

var time_spent_in_level: float = 0.0

var spawn_pos=Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_dungeon()
	player.position=spawn_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_spent_in_level+= delta

func formater_temps() -> String:
	print(time_spent_in_level)
	var secondes=time_spent_in_level
	var minutes = int(secondes) / 60
	var secs = int(secondes) % 60
	return "%02d:%02d" % [minutes, secs]

func generate_dungeon() -> void:
	var seed_base := randi()
	var spawn_room: Node2D = spawn_room.instantiate()
	add_child(spawn_room)
	spawn_room.position=Vector2(0,0)
	player.set_current_room(spawn_room)
