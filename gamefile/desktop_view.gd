extends Node2D

signal closeDesktop

@onready var fire_game_button = $DesktopStandard/FireGameButton
@onready var fire_game_button_deactivated = $DesktopStandard/FireGameButtonDeactivated
@onready var juice_game_button = $DesktopStandard/JuiceGameButton
@onready var juice_game_button_deactivated = $DesktopStandard/JuiceGameButtonDeactivated
@onready var trash_button = $DesktopStandard/TrashButton
@onready var cam_desktop = $CameraDesktop
@onready var cam_fire_minigame = $DesktopFireMinigame/DesktopPlayer/CameraFireMinigame
@onready var cam_juice_minigame = $DesktopJuiceMinigame/Camera2D
@onready var label_downfall = $DesktopFireMinigame/CanvasLayer
@onready var finish_canvas = $DesktopFireMinigame/Finish

func _ready() -> void:
	fire_game_button.visible = false
	juice_game_button.visible = false
	cam_desktop.enabled = false
	cam_fire_minigame.enabled = false
	cam_juice_minigame.enabled = false

func _on_close_button_pressed() -> void:
	closeDesktop.emit()

func _on_trash_button_pressed() -> void:
	fire_game_button.visible = true
	fire_game_button_deactivated.visible = false

func _on_fire_game_button_pressed() -> void:
	cam_desktop.enabled = false
	cam_fire_minigame.enabled = true
	label_downfall.visible = true
	Global.desktop_fire_visible = true
	if Global.fire_minigame_finished == true:
		finish_canvas.visible = true

func _on_fire_game_button_deactivated_pressed() -> void:
	# Error Sound
	print("Deactivated FireGame Button pressed")

func _on_desktop_fire_minigame_desktop_return() -> void:
	cam_fire_minigame.enabled = false
	cam_desktop.enabled = true
	label_downfall.visible = false
	Global.desktop_fire_visible = false
	finish_canvas.visible = false
	#print("Yeah, finished")

func _on_juice_game_button_pressed() -> void:
		cam_desktop.enabled = false
		cam_juice_minigame.enabled = true
		Global.desktop_juice_visible = true
		#if Global.fire_minigame_finished == true:
		#	finish_canvas.visible = true
	
func _on_juice_game_button_deactivated_pressed() -> void:
	if Global.fire_minigame_finished == true:
		juice_game_button.visible = true
		juice_game_button_deactivated.visible = false
	else:
		# Error Sound
		print("Deactivated JuiceGame Button pressed")
