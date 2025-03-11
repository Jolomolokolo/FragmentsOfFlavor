extends CanvasLayer

@onready var score_container = $VBoxContainer

func _ready():
	self.visible = false

func _process(_delta: float) -> void:
	if Global.desktop_visible == true:
		update_score_display()
		self.visible = true
	else:
		self.visible = false

func update_score_display():
	for child in score_container.get_children():
		child.queue_free()

	var scores = Global.score_history_fire
	
	if scores.is_empty():
		self.visible = false
	else:
		self.visible = true

	for entry in scores:
		var score_label = Label.new()
		score_label.text = entry["time"] + " - " + str(entry["score"])
		score_container.add_child(score_label)
