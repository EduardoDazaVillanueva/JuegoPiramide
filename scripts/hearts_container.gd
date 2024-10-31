extends HBoxContainer

@onready var HeartGui = preload("res://scenes/heart_gui.tscn")

func updateHearts(max: int):
	for child in get_children():
		remove_child(child)
		child.queue_free()
	
	for i in range(max):
		var heart = HeartGui.instantiate()
		add_child(heart)
