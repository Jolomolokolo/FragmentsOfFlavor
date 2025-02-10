extends Area2D

@onready var desktop_scene

func _ready() -> void:
	desktop_scene = load("res://desktop.tscn").instantiate()
	desktop_scene.visible = false
	add_child(desktop_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Eigentlich zeigen")
		_show_desktop()

func _show_desktop():
	desktop_scene.global_position = Vector2(0, 0)
	desktop_scene.visible = true
	desktop_scene.z_index = 10
	
	get_tree().paused = true

func _hide_desktop():
	get_tree().paused = false
	desktop_scene.visible = false

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_hide_desktop()
