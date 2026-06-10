
extends Node

var collected_coins : int = 0
var time_spent: String = ""
var total_coins : int = 0

var charge = 20
var bonus_price ={"charge":10}


func save():
	var data = {
		"coins": total_coins,
		"charge": charge,
		"bonus_price": bonus_price
	}

	var fichier = FileAccess.open("user://save.json", FileAccess.WRITE)
	fichier.store_string(JSON.stringify(data))
	print("saved")

func load():
	if not FileAccess.file_exists("user://save.json"):
		return

	var fichier = FileAccess.open("user://save.json", FileAccess.READ)
	var contenu = fichier.get_as_text()

	var json = JSON.parse_string(contenu)
	print(json)
	if json:
		total_coins=json["coins"]
		charge=json["charge"]
		bonus_price=json["bonus_price"]
	print("loaded")
