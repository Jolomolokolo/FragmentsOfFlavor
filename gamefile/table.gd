extends StaticBody2D

@onready var capacity: int = \
	int(direction_n) + int(direction_o) + int(direction_s) + int(direction_w)

@export var direction_n: bool = true
@export var direction_o: bool = true
@export var direction_s: bool = true
@export var direction_w: bool = true

@export var occupied: bool = false
