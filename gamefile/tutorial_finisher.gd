extends Area2D

func _on_body_entered(_body: Node2D) -> void: ## Evtl. später als Signal oder so
	call_deferred("set_monitoring", false)
	#$CollisionShape2D.disabled = true # Nur für Debug
	#print("Not visible?!")
