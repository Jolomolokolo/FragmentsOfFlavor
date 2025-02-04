extends Area2D

var player_in_area = false

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_action") == true and player_in_area == true:
		if Global.handheld_bool == false and Global.cash > 0:
			Global.handheld_bool = true
			Global.handheld = "cookie"
			Global.cash -= 5
			print("Cash: ", Global.cash)
		else:
			print("NEEE")
