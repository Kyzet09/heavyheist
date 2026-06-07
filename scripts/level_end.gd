extends Node2D

@onready var coins_recap: Label = $VBoxContainer/coins_recap
@onready var time_recap: Label = $VBoxContainer/time_recap



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_recap.text="Coins collected: "+ str(Global.collected_coins)
	time_recap.text="Time spent: "+ str(Global.time_spent)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
