extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			get_tree().paused = false
			self.visible = false
		
		else:
			get_tree().paused = true
			self.visible = true

func _on_texture_button_pressed() -> void:
	if get_tree().paused:
		get_tree().paused = false
		self.visible = false
		
	else:
		get_tree().paused = true
		self.visible = true
