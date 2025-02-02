extends StaticBody2D

@onready var capacity: int = \
	int(direction_n) + int(direction_o) + int(direction_s) + int(direction_w)

@export var direction_n = true
@export var direction_o = true
@export var direction_s = true
@export var direction_w = true
