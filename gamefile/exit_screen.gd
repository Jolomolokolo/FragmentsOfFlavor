extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and Global.desktop_visible == false:
		toggle_pause()

func _on_texture_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	if Global.desktop_visible == true:
		return
	elif Global.desktop_visible == false:
		get_tree().paused = !get_tree().paused
		self.visible = get_tree().paused
