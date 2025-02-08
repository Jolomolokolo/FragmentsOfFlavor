extends Area2D

var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_action") and player_in_area:
		if Global.handheld_selected_main:
			Global.handheld = ""
			Global.handheld_bool_1 = false
		else:
			Global.handheld_2 = ""
			Global.handheld_bool_2 = false
		Global.food_waste += 1
