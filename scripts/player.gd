extends CharacterBody2D
@export var speed : float = 10000
@onready var virtual_joystick: VirtualJoystick = $"../joystick_canva/Virtual Joystick"
@onready var modifiers: TileMapLayer
@onready var tuto: Node2D = $".."
@onready var text_canva: CanvasLayer = $"../text_canva"
@onready var script_tuto: RichTextLabel = $"../text_canva/script_tuto"

var move_vector := Vector2.ZERO
var collected_coins : int = 0
var collected_keys : int = 0
var has_sword : bool = false

func set_current_room(room: Node2D):
	modifiers= room.get_node("modifiers")


func _process(delta: float) -> void:
	if virtual_joystick and virtual_joystick.is_pressed:
		rotation = virtual_joystick.output.angle() - deg_to_rad(90)
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_vector * speed * delta
	move_and_slide()
	get_tile_under_player()
	open_doors()

func get_tile_under_player():
	# Convertit la position du personnage en coordonnées de cellule
	var cell = modifiers.local_to_map(modifiers.to_local(global_position))
	# Récupère les données de la tile à cette cellule
	var tile_data = modifiers.get_cell_tile_data(cell)
	if tile_data:
		var type = tile_data.get_custom_data("type")
		if type=="trap":
			position=tuto.spawn_pos
		if type=="coin":
			modifiers.set_cell(cell,-1)
			if collected_coins==0:
				dialog("[font_size=32][i]Voice in you head [/i] \nCOINS! I love coins!")
			collected_coins+=1
			print("coins: ",collected_coins)
		if type=="key":
			collected_keys+=1
			modifiers.set_cell(cell,-1)
			print("keys: ",collected_keys)
		if type=="sword":
			has_sword=true
			modifiers.set_cell(cell,-1)
			print("sword: ",has_sword)
		if type=="pot" and has_sword:
			modifiers.set_cell(cell,0,Vector2i(15,0))
			collected_coins+=2
			collected_keys+=1
			print("coins: ",collected_coins)
			print("keys: ",collected_keys)
		if type=="pot" and not has_sword:
			dialog("[font_size=32][i]Voice in you head [/i] \nI need something to break it...")
		if type=="heart":
			dialog("[font_size=32][i]Voice in you head [/i] \nFinally! FREE!!!")
			await get_tree().create_timer(2.0).timeout
			Global.collected_coins = collected_coins
			Global.time_spent=tuto.formater_temps()
			get_tree().change_scene_to_file("res://scenes/level_end.tscn")
			

func open_doors():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		if collider is TileMapLayer and collider.name=="modifiers":
			var contact_pos = collision.get_position()
			var tile_pos = collider.local_to_map(collider.to_local(contact_pos))
			var tile_data = collider.get_cell_tile_data(tile_pos)
			if tile_data:
				var tile_type=tile_data.get_custom_data("type")
				if tile_type =="door" and collected_keys>0:
					collected_keys-=1
					collider.set_cell(tile_pos, 0,Vector2i(9,0))  # open door
				elif tile_type =="door" and collected_keys<=0:
					dialog("[font_size=32][i]Voice in you head [/i] \nI need a key to open this door...")

func dialog(text):
	script_tuto.text=text
	text_canva.visible = true
	await get_tree().create_timer(2.0).timeout
	text_canva.visible = false
	
