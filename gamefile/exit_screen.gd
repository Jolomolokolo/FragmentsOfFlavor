extends Control

signal fire_close_to_desktop
signal juice_close_to_desktop

@onready var return_button = $Pause/Return

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		toggle_pause()

func _on_texture_button_pressed() -> void:
	toggle_pause()

func toggle_pause() -> void:
	if not Global.desktop_visible:
		if not Global.cafe_area:
			return_button.visible = true
		else:
			return_button.visible = false
		
		get_tree().paused = !get_tree().paused
		self.visible = get_tree().paused

func _on_return_pressed() -> void:
	return_button.visible = false
	toggle_pause()
	if Global.desktop_fire_visible:
		fire_close_to_desktop.emit()
	elif Global.desktop_juice_visible:
		juice_close_to_desktop.emit()
