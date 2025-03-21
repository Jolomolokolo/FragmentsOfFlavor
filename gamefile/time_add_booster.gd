extends Control

@onready var label = $Label
@onready var time_add_booster = $TimeAddBooster
@onready var time_add_booster_deactivated = $TimeAddBoosterDeactivated


func _process(_delta: float) -> void:
	if Global.time_add_customer_booster > 0:
		time_add_booster_deactivated.visible = false
		time_add_booster.visible = true
	else:
		time_add_booster.visible = false
		time_add_booster_deactivated.visible = true
	
	label.text = str(Global.time_add_customer_booster)
