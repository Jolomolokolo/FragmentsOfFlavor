extends Area2D

@onready var player = $"../CharacterBody2D"
@onready var canvas_layer = $"../CanvasLayer"
@onready var desktop_scene: Node2D = load("res://desktop.tscn").instantiate()
var last_coords_player: Vector2
var can_trigger_again: bool = true

func _ready() -> void:
	desktop_scene.visible = false
	add_child(desktop_scene)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_trigger_again:
		_show_desktop()

func _show_desktop():
	desktop_scene.global_position = Vector2(0, 0)
	desktop_scene.visible = true
	desktop_scene.z_index = 10
	last_coords_player = player.global_position
	player.global_position = Vector2(640, 360)
	get_tree().paused = true
	can_trigger_again = false
	Global.desktop_visible = true
	canvas_layer.visible = false

func _hide_desktop():
	if Global.desktop_visible == true:
		get_tree().paused = false
		desktop_scene.visible = false
		desktop_scene.z_index = -10
		player.global_position = last_coords_player
		await get_tree().create_timer(0.2).timeout
		Global.desktop_visible = false
		canvas_layer.visible = true
	can_trigger_again = true

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		_hide_desktop()
