extends Node

signal customer_spawn_w_size(group_size: int)

var tables = []

func _ready() -> void:
	for child in get_children():
		if child is StaticBody2D:
			tables.append({"position": child.global_position, "occupied": false, "capacity": child.capacity})
			tables.shuffle()
	print(tables)

func _on_customer_spawner_customer_spawn(group_size: int):
	for table in tables:
		if not table["occupied"] and table["capacity"] >= group_size:
			table["occupied"] = true
			print(table)
			print(tables)
			print("GroupSize: ", group_size)
			customer_spawn_w_size.emit(group_size)
		return table["position"]
	return null
