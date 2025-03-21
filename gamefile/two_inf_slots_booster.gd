extends Control

@onready var label = $Label
@onready var two_inf_slots_booster = $TwoInfSlotsBooster
@onready var two_inf_slots_deactivated = $TwoInfSlotsBoosterDeactivated


func _process(_delta: float) -> void:
	if Global.two_inv_slots_booster > 0:
		two_inf_slots_deactivated.visible = false
		two_inf_slots_booster.visible = true
	else:
		two_inf_slots_booster.visible = false
		two_inf_slots_deactivated.visible = true
	
	label.text = str(Global.two_inv_slots_booster)
