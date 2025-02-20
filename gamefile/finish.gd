extends Control

signal desktop_return

func _on_return_desktop_pressed() -> void:
	desktop_return.emit()
	#print("Should RETURN")
