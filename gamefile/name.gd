extends Control

@onready var text_field : LineEdit = $LineEdit
@onready var error_icon : TextureRect = $ErrorIcon
var player_name : String = ""

@onready var focus_timer : Timer = $FocusTimer

func _ready() -> void:
	self.visible = true
	get_tree().paused = true
	text_field.grab_focus()
	error_icon.visible = false
	focus_timer.timeout.connect(self._on_focus_timeout)

func _on_line_edit_text_submitted(input_text: String) -> void:
	if is_valid_name(input_text):
		Global.player_name = input_text
		get_tree().paused = false
		self.visible = false
		error_icon.visible = false
	else:
		error_icon.visible = true
		text_field.clear()
		focus_timer.start(0.1)

func _on_focus_timeout() -> void:
	text_field.grab_focus()

func is_valid_name(input_text: String) -> bool:
	var pattern = RegEx.new()
	var result = pattern.compile("^[a-zA-Z0-9!\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~]+$")
	
	if result == OK:
		var match = pattern.search(input_text)
		return match != null
	else:
		return false
