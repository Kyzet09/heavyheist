extends Node2D
@onready var coins: Label = $coins
@onready var buy_charge: Button = $charge_label/buy_charge
@onready var charge: Label = $charge_label/charge


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins.text=str(Global.total_coins)
	buy_charge.text="Level up ("+str(Global.bonus_price["charge"])+")"
	charge.text=str(Global.charge)
	Global.save()


func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
	Global.save()


func _on_buy_charge_pressed() -> void:
	if (Global.bonus_price["charge"]<=Global.total_coins):
		Global.total_coins-=Global.bonus_price["charge"]
		Global.charge+=5
		Global.bonus_price["charge"]=int(Global.bonus_price["charge"]*1.2)
		buy_charge.text="Level up ("+str(Global.bonus_price["charge"])+")"
		charge.text=str(Global.charge)
		
