extends CharacterBody2D
@export var speed : float = 5000
@onready var sprite = $sprite
@onready var virtual_joystick: VirtualJoystick = $"../joystick_canva/Virtual Joystick"
@onready var modifiers: TileMapLayer = $"../modifiers"
@onready var tuto: Node2D = $".."
@onready var text_canva: CanvasLayer = $"../text_canva"
@onready var dialog: RichTextLabel = $"../text_canva/dialog"


var move_vector := Vector2.ZERO
var collected_coins : int = 0
var collected_keys : int = 0
var has_sword : bool = false
var charge : int = 20 # a changer en fonction du stash

func _ready() -> void:
	update_backpack()

func _process(delta: float) -> void:
	if virtual_joystick and virtual_joystick.is_pressed:
		rotation = virtual_joystick.output.angle() + deg_to_rad(90)
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_vector * speed * delta
	move_and_slide()
	get_tile_under_player()
	open_doors()

func get_tile_under_player():
	# Convertit la position du personnage en coordonnées de cellule
	var cell = modifiers.local_to_map(global_position)
	# Récupère les données de la tile à cette cellule
	var tile_data = modifiers.get_cell_tile_data(cell)
	if tile_data:
		var type = tile_data.get_custom_data("type")
		if type=="trap":
			position=tuto.spawn_pos
		if type=="coin":
			modifiers.set_cell(cell,-1)
			if collected_coins==0:
				set_dialog("[font_size=32][i]Voice in you head [/i] \nCOINS! I love coins!")
			collected_coins+=1
			update_backpack()
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
			update_backpack()
			print("coins: ",collected_coins)
			print("keys: ",collected_keys)
		if type=="pot" and not has_sword:
			set_dialog("[font_size=32][i]Voice in you head [/i] \nI need something to break it...")
		if type=="heart":
			set_dialog("[font_size=32][i]Voice in you head [/i] \nFinally! FREE!!!")
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
					set_dialog("[font_size=32][i]Voice in you head [/i] \nI need a key to open this door...")

func set_dialog(text):
	dialog.text=text
	text_canva.visible = true
	await get_tree().create_timer(2.0).timeout
	text_canva.visible = false


func update_backpack():
	print("half capacity" + str(int(charge/2)))
	if collected_coins < int(charge/2):
		sprite.frame = 0
		speed = 7500
	elif collected_coins < charge:
		sprite.frame = 1
		speed = 5000
	else:
		sprite.frame = 2
		speed = 2500
		
