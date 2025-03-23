extends Area2D

var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_action") and player_in_area and Global.cafe_area:
		var slot_index = Global.selected_slot
		
		if slot_index < Global.handhelds.size():
			Global.handhelds[slot_index] = ""
			Global.handheld_bool[slot_index] = false
		
		Global.food_waste += 1
