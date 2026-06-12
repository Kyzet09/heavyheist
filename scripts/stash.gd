extends Node2D
@onready var coins: Label = $coins
@onready var buy_charge: Button = $charge_label/buy_charge
@onready var charge: Label = $charge_label/charge
@onready var lockpicking_lvl: Label = $lockpicking_label/lockpicking_lvl
@onready var progress_bar: ProgressBar = $lockpicking_label/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.save()
	coins.text=str(Global.total_coins)
	buy_charge.text="Level up ("+str(Global.bonus_price["charge"])+")"
	charge.text=str(Global.charge)
	lockpicking_lvl.text=str(Global.lockpicking["lvl"])
	while (Global.lockpicking["xp"]>=Global.lockpicking["xp_to_lvlup"]):
		Global.lockpicking["xp"]-=Global.lockpicking["xp_to_lvlup"]
		Global.lockpicking["lvl"]+=1
		Global.lockpicking["xp_to_lvlup"]+=10
		lockpicking_lvl.text=str(Global.lockpicking["lvl"])
		progress_bar.max_value=Global.lockpicking["xp_to_lvlup"]
	progress_bar.value=Global.lockpicking["xp"]
		


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
		coins.text=str(Global.total_coins)
		
