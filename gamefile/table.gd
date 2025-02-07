extends StaticBody2D

@onready var capacity: int = \
	int(direction_n) + int(direction_o) + int(direction_s) + int(direction_w)

@export var direction_n: bool = true
@export var direction_o: bool = true
@export var direction_s: bool = true
@export var direction_w: bool = true

@export var occupied: bool = false
var count = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("customer"):
		count += 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("customer"):
		count -= 1
		if count == 0:
			occupied = false
			Global.tables_visited += 1
			print("Table ist leer")
