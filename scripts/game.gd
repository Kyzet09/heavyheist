extends Node2D
@onready var player: CharacterBody2D = $player
@onready var text_canva: CanvasLayer = $text_canva
@onready var room_2: Node2D = $room2
@onready var map: TileMapLayer = $map
@onready var modifiers: TileMapLayer = $modifiers

var time_spent_in_level: float = 0.0

var spawn_pos=Vector2i(100,100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_dungeon()
	player.position=spawn_pos
	var room2_scene = load("res://scenes/room_2.tscn")
	var room2 = room2_scene.instantiate()
	print(room2.get_children())
	copy_room(room2,Vector2i(0,-11))
	#room2.free()
	

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

func copy_room(room: Node, offset: Vector2i = Vector2i.ZERO):
	copy_tilemaplayer(room.get_node("map"), map, offset)
	copy_tilemaplayer(room.get_node("modifiers"), modifiers, offset)
	
func copy_tilemaplayer(source: TileMapLayer, target: TileMapLayer, offset: Vector2i = Vector2i.ZERO):
	for cell in source.get_used_cells():
		target.set_cell(
			cell + offset,
			source.get_cell_source_id(cell),
			source.get_cell_atlas_coords(cell)
		)
