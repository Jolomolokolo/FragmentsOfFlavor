extends CanvasLayer

@onready var token_label = $TokenLabel

func _process(_delta):
	update_token_display()

func update_token_display():
	token_label.text = "🪙: " + str(int(Global.tokens))
