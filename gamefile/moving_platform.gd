extends CharacterBody2D

@export var target_offset: Vector2 = Vector2(100, 0)
@export var speed: float = 50.0
@export var enabled: bool = false

var start_position: Vector2
var direction: int = 1

func _ready():
	start_position = global_position

func _physics_process(delta):
	if not enabled:
		return

	var target = start_position + target_offset * direction
	var move_vector = (target - global_position).normalized() * speed * delta

	global_position += move_vector

	if global_position.distance_to(target) < speed * delta:
		direction *= -1

	for body in $Area2D.get_overlapping_bodies():
		if body is CharacterBody2D:
			body.global_position += move_vector
