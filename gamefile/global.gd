extends Node

var table = []
var orders = []

var handheld_bool_1 = false
var handheld_bool_2 = false
var handheld_selected_main = true
var handheld = ""
var handheld_2 = ""

var health = 100
var cash = 100
var orders_served = 0
var orders_failed = 0
var tables_visited = 0
var food_waste = 0

var player_name = ""

var cafe_area = false
var desktop_visible = false
var desktop_fire_visible = false
var desktop_crane_visible = false
var downfalls = 0
var fire_minigame_finished = false
var desktop_juice_visible = false
var juice_minigame_finished = false
var crane_minigame_finished = false
var score_history_fire = []
var score_history = []


func reset():
	table.clear()
	orders.clear()

	handheld_bool_1 = false
	handheld_bool_2 = false
	handheld_selected_main = true
	handheld = ""
	handheld_2 = ""

	health = 100
	cash = 100
	orders_served = 0
	orders_failed = 0
	tables_visited = 0
	food_waste = 0

	cafe_area = false
	desktop_visible = false
	desktop_fire_visible = false
	desktop_crane_visible = false
	downfalls = 0
	fire_minigame_finished = false
	desktop_juice_visible = false
	juice_minigame_finished = false
	crane_minigame_finished = false
	score_history_fire.clear()
	score_history.clear()

func switch_handheld():
	handheld_selected_main = !handheld_selected_main
	#print("Slot switched: ", "Main" if handheld_selected_main else "Beside")
	
func select_handheld(slot):
	if slot == 1:
		handheld_selected_main = true
	elif slot == 2:
		handheld_selected_main = false
	#print("Selected Slot: ", "Main" if handheld_selected_main else "Beside")

func select_next_handheld():
	if handheld_selected_main:
		select_handheld(2)
	else:
		select_handheld(1)

func select_previous_handheld():
	if handheld_selected_main:
		select_handheld(2)
	else:
		select_handheld(1)

func is_slot_full():
	if handheld_bool_1 and handheld_bool_2:
		return true
	return false

func set_item(item):
	if handheld_selected_main:
		if handheld_bool_1:
			if !handheld_bool_2:
				handheld_2 = item
				handheld_bool_2 = true
				#print("Item added to second slot")
			else:
				print("Both Slots full")
		else:
			handheld = item
			handheld_bool_1 = true
			#print("Item added to main slot")
	else:
		if handheld_bool_2:
			if !handheld_bool_1:
				handheld = item
				handheld_bool_1 = true
				#print("Item added to main slot")
			else:
				print("Both slots full")
		else:
			handheld_2 = item
			handheld_bool_2 = true
			#print("Item added to secod slot")



func add_score(score: int):
	var timestamp = Time.get_time_string_from_system()
	score_history.append({ "score": score, "time": timestamp })
	#print("Score saved:", score_history)

func add_score_fire(time: int):
	var timestamp = Time.get_time_string_from_system()
	score_history_fire.append({ "score": time, "time": timestamp})
	#print("Score saved:", score_history_fire)

func get_highscore_juice():
	if score_history.size() > 0:
		return score_history[score_history.size() - 1]["score"]
	else:
		return null
