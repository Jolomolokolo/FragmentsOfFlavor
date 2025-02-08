extends Control

#var url = ""

@onready var score_label = $Score
@onready var player_name = $Name
@onready var vbox = $VBoxContainer

var score: int = 0
var bonus = 5
var mulitplier = 0

func _ready() -> void:
	player_name.text = str(Global.player_name)
	score = round((Global.health * 3) + (Global.cash * 0.5) + (Global.orders_served * 10) - (Global.orders_failed * 15) + (Global.tables_visited * 2) - (Global.food_waste * 8) + (bonus * mulitplier))
	score_label.text = "Score: " + str(score)
	save_score(Global.player_name, score)
	load_and_display_scores()
#	send_highscore(str(player_name), score)

func save_score(player_name: String, score: int, file_path: String = "user://score.txt"):
	var file = FileAccess.open(file_path, FileAccess.READ_WRITE)
	if file:
		file.seek_end()
		var datetime = Time.get_datetime_string_from_system()
		file.store_line(datetime + " - " + player_name + ": " + str(score))
		file.close()
		print("Score saved: " + datetime + " - " + player_name + " - " + str(score))
	else:
		print("Saving Error")

func load_and_display_scores():
	var scores = []
	var file = FileAccess.open("user://score.txt", FileAccess.READ)
	if file:
		while not file.eof_reached():
			var line = file.get_line().strip_edges()
			if line != "":
				scores.append(line)
		file.close()
	
	scores.sort_custom(func(a, b):
		return int(a.rsplit(": ", false, 1)[1]) > int(b.rsplit(": ", false, 1)[1])
	)
	
	for child in vbox.get_children():
		child.queue_free()
	
	for i in range(min(10, scores.size())):
		var label = Label.new()
		var score_entry = scores[i].split(" - ", false, 1)[1]
		label.text = "%d. %s" % [i + 1, score_entry]
		vbox.add_child(label)

#func send_highscore(player_name: String, score: int):
#	var request = HTTPRequest.new()
#	add_child(request)
#	
#	var post_data = '{"player_name": "' + player_name + '", "score": ' + str(score) + '}'
#	
#	var headers = ["Content-Type: application/json"]
#	
#	var err = request.request(url, headers, HTTPClient.METHOD_POST, post_data)
#	
#	if err == OK:
#		print("Daten erfolgreich gesendet!")
#	else:
#		print("Fehler bei der Anfrage: ", err)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://start_screen.tscn")
	print("Start Page")
