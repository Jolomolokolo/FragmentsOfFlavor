extends Control

var player_name = ""

func _ready() -> void:
	self.visible = true
	get_tree().paused = true

func _on_line_edit_text_submitted(new_text: String) -> void:
	Global.player_name = new_text
	get_tree().paused = false
	self.visible = false
