extends Node2D

signal closeDesktop

@onready var fire_game_button = $DesktopStandard/FireGameButton
@onready var fire_game_button_deactivated = $DesktopStandard/FireGameButtonDeactivated
@onready var trash_button = $DesktopStandard/TrashButton

func _ready() -> void:
	fire_game_button.visible = false

func _on_close_button_pressed() -> void:
	closeDesktop.emit()

func _on_trash_button_pressed() -> void:
	fire_game_button.visible = true
	fire_game_button_deactivated.visible = false

func _on_fire_game_button_pressed() -> void:
	print("FireGame Button pressed")

func _on_fire_game_button_deactivated_pressed() -> void:
	# Error Sound
	print("Deactivated FireGame Button pressed")
