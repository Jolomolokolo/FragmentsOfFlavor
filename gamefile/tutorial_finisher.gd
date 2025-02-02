extends Area2D

func _on_customer_spawner_tutorial_finished() -> void:
	call_deferred("set_monitoring", false)
	$CollisionShape2D.disabled = true # Nur für Debug
	#print("Not visible?!")
	
