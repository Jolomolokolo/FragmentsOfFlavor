extends Control

signal time_add

@onready var label = $Label
@onready var time_add_booster = $TimeAddBooster
@onready var time_add_booster_deactivated = $TimeAddBoosterDeactivated

@export var time_extra: int = 120

func _process(_delta: float) -> void:
	update_booster_label()
	if Input.is_action_just_pressed("7") and not Global.time_add_customer_booster <= 0:
		time_add.emit(time_extra)
		Global.time_add_customer_booster = Global.time_add_customer_booster - 1
	else:
		# Error Sound
		pass

func update_booster_label():
	if Global.time_add_customer_booster > 0:
		time_add_booster_deactivated.visible = false
		time_add_booster.visible = true
	else:
		time_add_booster.visible = false
		time_add_booster_deactivated.visible = true
	
	label.text = str(Global.time_add_customer_booster)
