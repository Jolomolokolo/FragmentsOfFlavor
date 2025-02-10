extends Area2D

@onready var desktop_scene = $Desktop

func _ready() -> void:
	desktop_scene.visible = false

func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		print("Eigentlich zeigen")
		desktop_scene.visible = true
		desktop_scene.z_index = 10
		
