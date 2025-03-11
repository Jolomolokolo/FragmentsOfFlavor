extends Control

signal desktop_return
signal start_game

func _on_return_desktop_pressed() -> void:
	desktop_return.emit()
	#print("Should RETURN")

func _on_restart_game_pressed() -> void:
	start_game.emit()
