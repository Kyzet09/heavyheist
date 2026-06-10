extends Node2D
@onready var player: CharacterBody2D = $player
@onready var text_canva: CanvasLayer = $text_canva
@onready var map: TileMapLayer = $map
@onready var modifiers: TileMapLayer = $modifiers
@onready var keys_label: Label = $text_canva/keys_label

var time_spent_in_level: float = 0.0

var spawn_pos=Vector2i(100,100)

var loot_spawnpoints={0:[{"xmin":1,"xmax":11,"ymin":1,"ymax":10}]}

var current_floor=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generate_loot(0,0)
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

func generate_room(room_pos: Vector2i,floor=null,room_id =null) -> void:
	if (map.get_cell_source_id(room_pos+Vector2i(0,1)) != -1):
		player.collected_keys+=1
		keys_label.text=str(player.collected_keys)
		return
	elif (not room_id and not floor):
		var random=randi_range(1, 3) 
		var room_scene = load("res://scenes/floor"+str(current_floor)+"_room_"+str(random)+".tscn")
		var room = room_scene.instantiate()
		copy_room(room,room_pos)
		generate_loot(current_floor,random,room_pos)
	else:
		var room_scene = load("res://scenes/floor"+str(floor)+"_room_"+str(room_id)+".tscn")
		var room = room_scene.instantiate()
		copy_room(room,room_pos)
		generate_loot(current_floor,room_id,room_pos)


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

func generate_loot(floor:int, room : int,room_pos: Vector2i = Vector2i.ZERO):
	if floor==0:
		if room==0:
			for i in range(3): # a equilibrer
				var loot_pos=Vector2i(randi_range(loot_spawnpoints[0][0]["xmin"],loot_spawnpoints[0][0]["xmax"]),randi_range(loot_spawnpoints[0][0]["ymin"],loot_spawnpoints[0][0]["ymax"]))
				modifiers.set_cell(loot_pos,0,Vector2i(13,3))
		elif room==1:
			for i in range(randi_range(1,4)): # generation de pieces a equilibrer
				var loot_pos=Vector2i(randi_range(3,9),randi_range(3,7))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,0))
			for i in range(randi_range(1,2)): # generation de pot a equilibrer
				var loot_pos=Vector2i(randi_range(3,9),randi_range(3,7))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(14,0))
		elif room==2:
			for i in range(1): # generation de clé a equilibrer
				var loot_pos=Vector2i(randi_range(1,2),randi_range(8,10))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,3))
			for i in range(2): # generation de piece a equilibrer
				var loot_pos=Vector2i(randi_range(1,2),randi_range(8,10))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,0))
			if randi_range(1,10)<=3: # 3/10 chance de faire spawner l'épée
				modifiers.set_cell(Vector2i(11,1)+room_pos,0,Vector2i(13,4))
		elif room==3:
			for i in range(1): # generation de clé a equilibrer
				var loot_pos=Vector2i(randi_range(1,2),randi_range(1,10))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,3))
			for i in range(randi_range(1,3)): # generation de piece a equilibrer
				var loot_pos=Vector2i(randi_range (8,11),randi_range(1,6))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,0))

	if floor==1:
		if room==1:
			for i in range(randi_range(0,3)): # generation de pieces a equilibrer
				var loot_pos=Vector2i(randi_range(4,8),randi_range(3,7))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,0))
			for i in range(randi_range(0,2)): # generation de pot a equilibrer
				var loot_pos=Vector2i(randi_range(4,8),randi_range(3,7))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(14,0))
			if (randi_range(0,2)==0):
				modifiers.set_cell(Vector2i(6,5)+room_pos,0,Vector2i(13,1))
		elif room==2:
			for i in range(1): # generation de clé a equilibrer
				var loot_pos=Vector2i(randi_range(1,11),randi_range(4,6))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,3))
			for i in range(randi_range(1,5)): # generation de piece a equilibrer
				var loot_pos=Vector2i(randi_range(1,11),randi_range(4,6))
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(13,0))
		elif room==3:
			var list_pos=[4,6,8,10]
			var rd=randi_range(0,2)
			for i in range(rd): # generation de pot a equilibrer
				var loot_pos=Vector2i(list_pos[randi_range(0,3)],4)
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(14,0))
			for i in range(2-rd): # generation de pot a equilibrer
				var loot_pos=Vector2i(list_pos[randi_range(0,3)],6)
				modifiers.set_cell(loot_pos+room_pos,0,Vector2i(14,0))
	
