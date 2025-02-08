extends Control

@onready var score_label = $Score
var score = 0
var bonus = -5
var mulitplier = 0

func _ready() -> void:
	score = round((Global.health * 3) + (Global.cash * 0.5) + (Global.orders_served * 10) - (Global.orders_failed * 15) + (Global.tables_visited * 2) - (Global.food_waste * 8) + (bonus * mulitplier))
	score_label.text = "Score: " + str(score)
