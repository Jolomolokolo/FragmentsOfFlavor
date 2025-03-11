extends Area2D

@onready var player = $"../CharacterBody2D"
@onready var desktop_scene = $Desktop
@onready var cam_desktop = $Desktop/CameraDesktop
@onready var cam_fire_minigame = $Desktop/DesktopFireMinigame/DesktopPlayer/CameraFireMinigame
@onready var cam = $"../CharacterBody2D/Camera2D"
@onready var cafe_nodes = get_tree().get_nodes_in_group("cafe")
@onready var desktop_nodes = get_tree().get_nodes_in_group("desktop")

@onready var highscore_fire = $Desktop/DesktopStandard/HighsScoresFire
@onready var highscore_juice = $Desktop/DesktopStandard/HighsScoresJuice

var can_trigger_again: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_trigger_again and Global.cafe_area == true:
		_show_desktop()

func _show_desktop():
	Global.cafe_area = false
	can_trigger_again = false
	Global.desktop_visible = true
	highscore_fire.visible = true
	highscore_juice.visible = true
	
	cam_desktop.enabled = true
	cam.enabled = false
	
	for node in cafe_nodes:
		node.visible = false

func _hide_desktop():
	if Global.desktop_visible == true:
		
		Global.cafe_area = true
		await get_tree().create_timer(0.2).timeout
		Global.desktop_visible = false
		Global.desktop_fire_visible = false
		highscore_fire.visible = true
		highscore_juice.visible = true
		
		cam_desktop.enabled = false
		cam.enabled = true
		
		for node in cafe_nodes:
			node.visible = true

	can_trigger_again = true

func _input(event):
	if event.is_action_pressed("ui_cancel") and Global.desktop_fire_visible == false and Global.desktop_juice_visible == false and Global.desktop_visible == true:
		_hide_desktop()

func _on_desktop_close_desktop() -> void:
	_hide_desktop()
