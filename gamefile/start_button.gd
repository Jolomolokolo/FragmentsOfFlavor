extends Button

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_action") or Input.is_action_just_pressed("ui_accept"):
		Global.reset()
		get_tree().change_scene_to_file("res://cafe.tscn")
	
func _on_pressed():
	Global.reset()
	get_tree().change_scene_to_file("res://cafe.tscn")
	#print("Func works")
