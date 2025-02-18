extends CanvasLayer

@onready var downfalls_label = $Label

func _process(_delta: float) -> void:
	downfalls_label.text = "Downfalls: " + str(Global.downfalls)
