extends Control

@onready var score_label = $Score
@onready var player_name = $Name

var score = 0
var bonus = -5
var mulitplier = 0

func _ready() -> void:
	player_name.text = str(Global.player_name)
	score = round((Global.health * 3) + (Global.cash * 0.5) + (Global.orders_served * 10) - (Global.orders_failed * 15) + (Global.tables_visited * 2) - (Global.food_waste * 8) + (bonus * mulitplier))
	score_label.text = "Score: " + str(score)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
