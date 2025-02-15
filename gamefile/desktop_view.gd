extends Node2D

signal closeDesktop

@onready var fire_game_button = $DesktopStandard/FireGameButton
@onready var fire_game_button_deactivated = $DesktopStandard/FireGameButtonDeactivated
@onready var trash_button = $DesktopStandard/TrashButton
@onready var cam_desktop = $CameraDesktop
@onready var cam_fire_minigame = $DesktopFireMinigame/DesktopPlayer/CameraFireMinigame

func _ready() -> void:
	fire_game_button.visible = false
	cam_desktop.enabled = false
	cam_fire_minigame.enabled = false

func _on_close_button_pressed() -> void:
	closeDesktop.emit()

func _on_trash_button_pressed() -> void:
	fire_game_button.visible = true
	fire_game_button_deactivated.visible = false

func _on_fire_game_button_pressed() -> void:
	cam_desktop.enabled = false
	cam_fire_minigame.enabled = true

func _on_fire_game_button_deactivated_pressed() -> void:
	# Error Sound
	print("Deactivated FireGame Button pressed")
	
