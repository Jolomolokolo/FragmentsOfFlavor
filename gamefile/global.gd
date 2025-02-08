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
	return handheld_bool_1 if handheld_selected_main else handheld_bool_2

func set_item(item):
	if handheld_selected_main:
		handheld = item
		handheld_bool_1 = true
	else:
		handheld_2 = item
		handheld_bool_2 = true
