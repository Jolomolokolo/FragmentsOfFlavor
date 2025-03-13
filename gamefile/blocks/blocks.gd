extends RigidBody2D

signal block_dropped

var is_attached = true

func _ready():
	freeze = true
	gravity_scale = 0

func _input(event):
	if event.is_action_pressed("ui_accept") and is_attached:
		is_attached = false
		freeze = false
		gravity_scale = 1
		emit_signal("block_dropped")
