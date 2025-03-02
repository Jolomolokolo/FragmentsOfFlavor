extends RigidBody2D

@export var push_force_multiplier: float = 10.0
@export var bounce_factor: float = 0.5

@onready var area2d = $Area2D

func _on_Area2D_body_entered(body: Node):
	if body is CharacterBody2D:
		# Berechnung des Impulses, um den Block wegzuschieben
		var push_force = body.velocity.normalized() * push_force_multiplier
		apply_impulse(Vector2.ZERO, push_force)

		# Verursacht das Bounce-Verhalten
		self.linear_velocity *= bounce_factor
