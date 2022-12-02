extends Node2D

var eventscene = preload("res://Scenes/Events/Event.tscn")
var event = eventscene.instance()
onready var eventlabel = $"../UI_Canvas/UI/VBoxContainer/EventLabel"
onready var timer = $EventKillTimer

func _on_EventSpawnTimer_timeout():
	spawn()
	timer = Timer.new()
	timer.wait_time = 3
	timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(timer)
	timer.start()

func spawn():
	randomize()
	event.position = Vector2(rand_range(10,990), rand_range(10,590))
	$EventSpawnTimer.wait_time = rand_range(5,15)
	#print($EventSpawnTimer.wait_time)
	eventlabel.text = "Next Event in " + String($EventSpawnTimer.wait_time) + " seconds"
	get_tree().get_root().call_deferred("add_child",event)
		

	

func _on_timer_timeout():
	print("delete")
	#event.queue_free()
	#remove_child(event)
	#timer.stop()
