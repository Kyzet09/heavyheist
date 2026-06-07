extends Node2D
@onready var coins: Label = $coins


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins.text=str(Global.total_coins)


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_buy_charge_pressed() -> void:
	pass # Replace with function body.
