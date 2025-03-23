extends Node

var table = []
var orders = []

var handhelds = ["", "", "", "", ""]
var handheld_bool = [false, false, false, false, false]
var selected_slot = 0

var health = 100
var cash = 100
var orders_served = 0
var orders_failed = 0
var tables_visited = 0
var food_waste = 0
var tokens = 0

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

var time_add_customer_booster = 0
var all_orders_complete_booster = 0
var two_inv_slots_booster = 0
var inv_slots_booster_activated = false

func reset():
	table.clear()
	orders.clear()

	handhelds = ["", "", "", "", ""]
	handheld_bool = [false, false, false, false, false]
	selected_slot = 0

	health = 100
	cash = 100
	orders_served = 0
	orders_failed = 0
	tables_visited = 0
	food_waste = 0
	tokens = 0

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

	time_add_customer_booster = 0
	all_orders_complete_booster = 0
	two_inv_slots_booster = 0

	inv_slots_booster_activated = false

func switch_handheld():
	selected_slot = (selected_slot + 1) % get_max_slots()

func select_handheld(slot):
	if slot >= 0 and slot < handhelds.size():
		selected_slot = slot

func select_next_handheld():
	selected_slot = (selected_slot + 1) % get_max_slots()

func select_previous_handheld():
	selected_slot = (selected_slot - 1 + get_max_slots()) % get_max_slots()

func get_max_slots():
	return 5 if inv_slots_booster_activated else 2

func is_slot_full():
	var filled_slots = 0
	for i in range(handheld_bool.size()):
		if handheld_bool[i]:
			filled_slots += 1
	return filled_slots >= get_max_slots()

func set_item(item):
	for i in range(handhelds.size()):
		if not handheld_bool[i]:
			handhelds[i] = item
			handheld_bool[i] = true
			return
	print("All slots full!")

func activate_booster():
	inv_slots_booster_activated = true
	handhelds.resize(5)
	handheld_bool.resize(5)
	print("Booster activated! 5 Slots!")

func deactivate_booster():
	inv_slots_booster_activated = false
	handhelds.resize(2)
	handheld_bool.resize(2)
	print("Booster deactivated! Return to 2 Slots")

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
