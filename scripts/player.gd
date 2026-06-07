extends CharacterBody2D
@export var speed : float = 25000
@onready var virtual_joystick: VirtualJoystick = $"../CanvasLayer/Virtual Joystick"

var move_vector := Vector2.ZERO

func _process(delta: float) -> void:
	if virtual_joystick and virtual_joystick.is_pressed:
		rotation = virtual_joystick.output.angle() - deg_to_rad(90)
	## Movement using Input functions:
	move_vector = Vector2.ZERO
	move_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = move_vector * speed * delta
	move_and_slide()
