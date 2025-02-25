extends Button

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_action") or Input.is_action_just_pressed("ui_accept"):
		_on_pressed()

func _on_pressed():
	Global.reset()
	get_tree().change_scene_to_file("res://loading_screen.tscn")
	#print("Func works")
