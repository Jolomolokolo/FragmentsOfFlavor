extends Control

signal orders_complete

@onready var label = $Label
@onready var all_orders_complete_booster = $AllOrdersCompleteBooster
@onready var all_orders_complete_booster_deactivated = $AllOrdersCompleteBoosterDeactivated

var price = 5

func _process(_delta: float) -> void:
	update_booster_label()
	if Input.is_action_just_pressed("8") and Global.all_orders_complete_booster > 0 and Global.cafe_area:
		orders_complete.emit()
		Global.all_orders_complete_booster = Global.all_orders_complete_booster - 1
	else:
		# Error Sound
		pass

func update_booster_label():
	if Global.all_orders_complete_booster > 0:
		all_orders_complete_booster_deactivated.visible = false
		all_orders_complete_booster.visible = true
	else:
		all_orders_complete_booster.visible = false
		all_orders_complete_booster_deactivated.visible = true
	
	label.text = str(Global.all_orders_complete_booster)

func _on_button_pressed() -> void:
	if Global.tokens >= price and Global.desktop_visible:
		Global.tokens -= price
		Global.all_orders_complete_booster += 1
	elif Global.all_orders_complete_booster > 0 and Global.cafe_area:
		orders_complete.emit()
		Global.all_orders_complete_booster = Global.all_orders_complete_booster - 1
