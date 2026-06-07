extends CharacterBody2D
@export var speed : float = 10000
@onready var virtual_joystick: VirtualJoystick = $"../CanvasLayer/Virtual Joystick"
@onready var modifiers: TileMapLayer = $"../modifiers"



var move_vector := Vector2.ZERO
var spawn_pos=Vector2(728,567)

func _ready() -> void:
	position=spawn_pos
	

func _process(delta: float) -> void:
	if virtual_joystick and virtual_joystick.is_pressed:
		rotation = virtual_joystick.output.angle() - deg_to_rad(90)
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_vector * speed * delta
	move_and_slide()
	get_tile_under_player()

func get_tile_under_player():
	# Convertit la position du personnage en coordonnées de cellule
	var cell = modifiers.local_to_map(modifiers.to_local(global_position))
	
	# Récupère les données de la tile à cette cellule
	var tile_data = modifiers.get_cell_tile_data(cell)
	if tile_data:
		var type = tile_data.get_custom_data("type")
		if type=="trap":
			print("it's a trap")
			position=spawn_pos
