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
		if not Global.is_slot_full() and Global.cash > 0:
			Global.cash -= 5
			Global.set_item("water")
			print("Item aufgenommen in Slot: ", "1" if Global.handheld_selected_main else "2")
			print("Cash: ", Global.cash)
		else:
			print("Nicht genug Geld oder Slot voll!")
