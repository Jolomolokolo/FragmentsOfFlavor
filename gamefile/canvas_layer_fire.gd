extends CanvasLayer

@onready var downfalls_label = $Label

func _process(_delta: float) -> void:
	if Global.desktop_fire_visible == true:
		downfalls_label.visible = true
		downfalls_label.text = "Downfalls: " + str(Global.downfalls)
	else:
		downfalls_label.visible = false
