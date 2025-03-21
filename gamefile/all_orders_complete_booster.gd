extends Control

@onready var label = $Label
@onready var all_orders_complete_booster = $AllOrdersCompleteBooster
@onready var all_orders_complete_booster_deactivated = $AllOrdersCompleteBoosterDeactivated


func _process(_delta: float) -> void:
	if Global.all_orders_complete_booster > 0:
		all_orders_complete_booster_deactivated.visible = false
		all_orders_complete_booster.visible = true
	else:
		all_orders_complete_booster.visible = false
		all_orders_complete_booster_deactivated.visible = true
	
	label.text = str(Global.all_orders_complete_booster)
