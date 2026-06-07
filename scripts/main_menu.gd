extends Node2D

@onready var button_play: Button = $VBoxContainer/Button_play


func _ready():
	button_play.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/Tuto.tscn")
