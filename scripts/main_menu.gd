extends Node2D

@onready var button_play: Button = $VBoxContainer/Button_play

func _ready() -> void:
	Global.load()

func _on_button_play_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/tuto.tscn")


func _on_button_skip_tuto_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
