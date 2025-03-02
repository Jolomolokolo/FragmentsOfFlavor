extends Control

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel") and Global.cafe_area == true:
		toggle_pause()

func _on_texture_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	if Global.desktop_visible == true or Global.desktop_fire_visible == true or Global.desktop_juice_visible == true:
		return
	elif Global.cafe_area == true:
		get_tree().paused = !get_tree().paused
		self.visible = get_tree().paused
