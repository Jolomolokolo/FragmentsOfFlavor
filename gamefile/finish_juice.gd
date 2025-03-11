extends Control

signal desktop_return_from_juice
signal restart_juice

@onready var score_label = $Score

func _process(_delta: float) -> void:
	score_label.text = "Score: " + str(Global.get_highscore_juice()) # TODO: Adden, das vergleichen vom größten score

func _on_return_desktop_pressed() -> void:
	desktop_return_from_juice.emit()

func _on_restart_pressed() -> void:
	restart_juice.emit()
 
