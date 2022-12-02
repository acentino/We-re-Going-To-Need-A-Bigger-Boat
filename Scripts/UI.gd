extends Control

onready var aiboat = preload("res://Scenes/AI/AI_Boat.tscn")
var aiboatVec = Vector2()

func _on_Button_pressed():
	var boat = aiboat.instance()
	get_tree().get_root().call_deferred("add_child",boat)
	var newPos = Vector2(aiboatVec.x + rand_range(5, 9), rand_range(30, 50)) 
	boat.set_position(newPos)
	aiboatVec = newPos
	get_tree().get_root().add_child(boat)
	
