extends Area2D

@onready var player = $"../CharacterBody2D"
@onready var desktop_scene = $Desktop
@onready var cam_desktop = $Desktop/CameraDesktop
@onready var cam_fire_minigame = $Desktop/DesktopFireMinigame/DesktopPlayer/CameraFireMinigame
@onready var cam = $"../CharacterBody2D/Camera2D"
@onready var cafe_nodes = get_tree().get_nodes_in_group("cafe")
@onready var desktop_nodes = get_tree().get_nodes_in_group("desktop")

var can_trigger_again: bool = true

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and can_trigger_again and Global.cafe_area == true:
		_show_desktop()

func _show_desktop():
	#get_tree().paused = true
	Global.cafe_area = false
	can_trigger_again = false
	Global.desktop_visible = true
	#desktop_scene.set_process(true)
	#desktop_scene.set_physics_process(true)
	
	# Kameraumschaltung
	cam_desktop.enabled = true  # Desktop-Kamera aktivieren
	cam.enabled = false  # Charakter-Kamera deaktivieren
	
	
	for node in cafe_nodes:
		node.visible = false

func _hide_desktop():
	if Global.desktop_visible == true:
		
		#get_tree().paused = false
		Global.cafe_area = true
		await get_tree().create_timer(0.2).timeout
		Global.desktop_visible = false
		Global.desktop_fire_visible = false
		
		# Kameraumschaltung zurück
		cam_desktop.enabled = false  # Desktop-Kamera deaktivieren
		cam_fire_minigame.enabled = false # Fire Minigame-Kamera deaktivieren
		cam.enabled = true  # Charakter-Kamera aktivieren
		
		for node in cafe_nodes:
			node.visible = true

	can_trigger_again = true

func _input(event):
	if event.is_action_pressed("ui_cancel") and Global.desktop_fire_visible == false and Global.desktop_juice_visible == false and Global.desktop_visible == true:
		_hide_desktop()

func _on_desktop_close_desktop() -> void:
	_hide_desktop()
