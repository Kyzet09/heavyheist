extends Node2D
@onready var player: CharacterBody2D = $player
@onready var text_canva: CanvasLayer = $text_canva
@onready var map: TileMapLayer = $map
@onready var modifiers: TileMapLayer = $modifiers

var time_spent_in_level: float = 0.0

var spawn_pos=Vector2i(100,100)

var loot_spawnpoints={0:[{"xmin":1,"xmax":11,"ymin":1,"ymax":10}]}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_loot(0,3)
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

func generate_room(room_pos: Vector2i) -> void:
	var random=randi_range(1, 3) 
	var room_scene = load("res://scenes/room_"+str(random)+".tscn")
	var room = room_scene.instantiate()
	copy_room(room,room_pos)

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

func generate_loot(room : int,nb_item : int):
	for i in range(nb_item):
		var loot_pos=Vector2i(randi_range(loot_spawnpoints[0][0]["xmin"],loot_spawnpoints[0][0]["xmax"]),randi_range(loot_spawnpoints[0][0]["ymin"],loot_spawnpoints[0][0]["ymax"]))
		modifiers.set_cell(loot_pos,0,Vector2i(13,3))
	
