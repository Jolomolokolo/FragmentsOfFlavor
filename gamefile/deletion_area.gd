extends Area2D

func _on_body_entered(body) -> void:
	if body is RigidBody2D:
		body.queue_free()
