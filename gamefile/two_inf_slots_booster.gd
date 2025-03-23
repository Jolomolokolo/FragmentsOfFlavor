extends Control

@onready var label = $Label
@onready var two_inf_slots_booster = $TwoInfSlotsBooster
@onready var two_inf_slots_deactivated = $TwoInfSlotsBoosterDeactivated
@onready var timer = $Timer

var price = 3

func _process(_delta: float) -> void:
	update_booster_label()
	if Input.is_action_just_pressed("9") and Global.two_inv_slots_booster > 0 and not Global.inv_slots_booster_activated and Global.cafe_area:
		Global.activate_booster()
		timer.start()
		Global.two_inv_slots_booster = Global.two_inv_slots_booster - 1
	else:
		# Error Sound
		pass

func _on_timer_timeout() -> void:
	Global.deactivate_booster()

func update_booster_label():
	if Global.two_inv_slots_booster > 0:
		two_inf_slots_deactivated.visible = false
		two_inf_slots_booster.visible = true
	else:
		two_inf_slots_booster.visible = false
		two_inf_slots_deactivated.visible = true
	
	label.text = str(Global.two_inv_slots_booster)

func _on_button_pressed() -> void:
	if Global.tokens >= price and Global.desktop_visible:
		Global.tokens -= price
		Global.two_inv_slots_booster += 1
	elif Global.two_inv_slots_booster > 0 and not Global.inv_slots_booster_activated and Global.cafe_area:
		Global.activate_booster()
		timer.start()
		Global.two_inv_slots_booster = Global.two_inv_slots_booster - 1
