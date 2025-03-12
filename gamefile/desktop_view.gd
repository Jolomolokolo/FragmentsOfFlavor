extends Node2D

signal closeDesktop

@onready var fire_game_button = $DesktopStandard/FireGameButton
@onready var fire_game_button_deactivated = $DesktopStandard/FireGameButtonDeactivated
@onready var juice_game_button = $DesktopStandard/JuiceGameButton
@onready var juice_game_button_deactivated = $DesktopStandard/JuiceGameButtonDeactivated
@onready var crane_game_button = $DesktopStandard/CraneButton
@onready var crane_game_button_deactivated = $DesktopStandard/CraneButtonDeactivated
@onready var trash_button = $DesktopStandard/TrashButton
@onready var cam_desktop = $CameraDesktop
@onready var cam_fire_minigame = $DesktopFireMinigame/DesktopPlayer/CameraFireMinigame
@onready var cam_juice_minigame = $DesktopJuiceMinigame/Camera2D
@onready var cam_crane_minigame = $DesktopCraneMinigame/Camera2d # Needs to be fixed
@onready var label_downfall = $DesktopFireMinigame/CanvasLayer
@onready var finish_canvas = $DesktopFireMinigame/Finish
@onready var juice_canvas = $DesktopJuiceMinigame/CanvasLayer

@onready var juicer_4_4 = $"DesktopStandard/Juicer4-4"
@onready var juicer_3_4 =  $"DesktopStandard/Juicer3-4"
@onready var juicer_2_4 =  $"DesktopStandard/Juicer2-4"
@onready var juicer_1_4 =  $"DesktopStandard/Juicer1-4"
@onready var juicer_0_4 =  $"DesktopStandard/Juicer0-4"

func _ready() -> void:
	fire_game_button.visible = false
	juice_game_button.visible = false
	cam_desktop.enabled = false
	cam_fire_minigame.enabled = false
	cam_juice_minigame.enabled = false

func _process(_delta: float) -> void:
	check_juicer()

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
	Global.desktop_visible = false
	if Global.fire_minigame_finished == true:
		finish_canvas.visible = true

func _on_juice_game_button_pressed() -> void:
	cam_desktop.enabled = false
	cam_juice_minigame.enabled = true
	Global.desktop_visible = false
	Global.desktop_juice_visible = true
	juice_canvas.visible = true

func _on_cran_button_pressed() -> void:
	cam_desktop.enabled = false
	cam_crane_minigame.enabled = true
	Global.desktop_visible = false
	Global.desktop_crane_visible = true
	#crane_canvas.visible = true

func _on_fire_game_button_deactivated_pressed() -> void:
	# Error Sound
	print("Deactivated FireGame Button pressed")

func _on_juice_game_button_deactivated_pressed() -> void:
	if Global.fire_minigame_finished == true:
		juice_game_button.visible = true
		juice_game_button_deactivated.visible = false
	else:
		# Error Sound
		print("Deactivated JuiceGame Button pressed")

func _on_crane_button_deactivated_pressed() -> void:
	if Global.juice_minigame_finished == true:
		crane_game_button.visible = true
		crane_game_button_deactivated.visible = false
	else:
		# Error Sound
		print("Deactivated CraneGame Button pressed")

func _on_desktop_fire_minigame_desktop_return() -> void:
	cam_fire_minigame.enabled = false
	cam_desktop.enabled = true
	label_downfall.visible = false
	Global.desktop_visible = true
	Global.desktop_fire_visible = false
	finish_canvas.visible = false
	#print("Yeah, finished")

func _on_desktop_juice_minigame_desktop_return_from_juice() -> void:
	cam_desktop.enabled = true
	cam_juice_minigame.enabled = false
	Global.desktop_juice_visible = false
	Global.desktop_visible = true
	juice_canvas.visible = false

func check_juicer():
	var completed_games = 0
	
	if Global.fire_minigame_finished:
		completed_games += 1
	if Global.juice_minigame_finished:
		completed_games += 1
	if Global.crane_minigame_finished:
		completed_games += 1
	# if Global.yet_another_minigame_finished:
	#     completed_games += 1

	match completed_games:
		0:
			juicer_0_4.visible = false
			juicer_1_4.visible = false
			juicer_2_4.visible = false
			juicer_3_4.visible = false
			juicer_4_4.visible = true
		1:
			juicer_0_4.visible = false
			juicer_1_4.visible = false
			juicer_2_4.visible = false
			juicer_3_4.visible = true
			juicer_4_4.visible = false
		2:
			juicer_0_4.visible = false
			juicer_1_4.visible = false
			juicer_2_4.visible = true
			juicer_3_4.visible = false
			juicer_4_4.visible = false
		3:
			juicer_0_4.visible = false
			juicer_1_4.visible = true
			juicer_2_4.visible = false
			juicer_3_4.visible = false
			juicer_4_4.visible = false
		4:
			juicer_0_4.visible = true
			juicer_1_4.visible = false
			juicer_2_4.visible = false
			juicer_3_4.visible = false
			juicer_4_4.visible = false
