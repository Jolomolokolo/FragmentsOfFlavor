extends Node2D

signal desktop_return

func _on_finish_desktop_return() -> void:
	desktop_return.emit()
