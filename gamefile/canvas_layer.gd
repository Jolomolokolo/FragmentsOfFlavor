extends CanvasLayer

signal dead

@onready var cash_label = $CashLabel
@onready var texture_rect = $TextureRect
@onready var order_container = $ScrollContainer/VBoxContainer
@onready var order_bg = $ColorRect

@onready var inv_1 = $Inventory/Inv1
@onready var inv_2 = $Inventory/Inv2
@onready var inv_3 = $Inventory/Inv3
@onready var inv_4 = $Inventory/Inv4
@onready var inv_5 = $Inventory/Inv5

@onready var time = $Timer
@onready var time_label = $TimeLabel
var time_left: float = 900

var emoji_bad = preload("res://icons/emojis/emoji_bad.png")
var emoji_middle = preload("res://icons/emojis/emoji_middle.png")
var emoji_good = preload("res://icons/emojis/emoji_good.png")

var order_icons = {
	"avocado_toast": preload("res://food/food_icon/avocado_toast.png"),
	"cheescake": preload("res://food/food_icon/cheescake.png"),
	"coffe": preload("res://food/food_icon/coffe.png"),
	"cola": preload("res://food/food_icon/cola.png"),
	"cookie": preload("res://food/food_icon/cookie.png"),
	"crumb_cake": preload("res://food/food_icon/crumb_cake.png"),
	"energy": preload("res://food/food_icon/energy.png"),
	"hot_chocolat": preload("res://food/food_icon/hot_chocolate.png"),
	"soup": preload("res://food/food_icon/soup.png"),
	"water": preload("res://food/food_icon/water.png")
}

var inv_icons = {
	"avocado_toast": preload("res://food/food_inv/avocado_toast_inv.png"),
	"cheescake": preload("res://food/food_inv/cheescake_inv.png"),
	"coffe": preload("res://food/food_inv/coffe_inv.png"),
	"cola": preload("res://food/food_inv/cola_inv.png"),
	"cookie": preload("res://food/food_inv/cookie_inv.png"),
	"crumb_cake": preload("res://food/food_inv/crumb_cake_inv.png"),
	"energy": preload("res://food/food_inv/energy_inv.png"),
	"hot_chocolat": preload("res://food/food_inv/hot_chocolate_inv.png"),
	"soup": preload("res://food/food_inv/soup_inv.png"),
	"water": preload("res://food/food_inv/water_inv.png"),
	"": preload("res://food/food_inv/inv.png")
}

func _ready():
	update_cash_display()
	update_heath_display()
	update_orders()
	update_inventory()

func _process(_delta):
	if Global.cafe_area:
		update_cash_display()
		update_heath_display()
		update_orders()
		
		if Input.is_action_just_pressed("ui_swap"):
			Global.switch_handheld()
		elif Input.is_action_just_pressed("1"):
			Global.select_handheld(0)
		elif Input.is_action_just_pressed("2"):
			Global.select_handheld(1)
		
		if Global.inv_slots_booster_activated:
			if Input.is_action_just_pressed("3"):
				Global.select_handheld(2)
			if Input.is_action_just_pressed("4"):
				Global.select_handheld(3)
			if Input.is_action_just_pressed("5"):
				Global.select_handheld(4)
		
		if Input.is_action_just_pressed("scroll_up"):
			Global.select_previous_handheld()
		elif Input.is_action_just_pressed("scroll_down"):
			Global.select_next_handheld()
		
		update_inventory()


func update_cash_display():
	cash_label.text = "\ud83d\udcb5: " + str(int(Global.cash))

func update_heath_display():
	if Global.health <= 0:
		dead.emit()
	elif Global.health <= 20:
		texture_rect.texture = emoji_bad
	elif Global.health >= 21 and Global.health <= 69:
		texture_rect.texture = emoji_middle
	elif Global.health >= 70:
		texture_rect.texture = emoji_good

func _on_dead() -> void:
	get_tree().change_scene_to_file("res://dead.tscn")
	print("DEAD")

func update_orders():
	for child in order_container.get_children():
		child.queue_free()
	
	if Global.orders.size() == 0:
		$ScrollContainer.visible = false
		order_bg.visible = false
		return
	
	$ScrollContainer.visible = true
	order_bg.visible = true
	
	for order_name in Global.orders:
		var texture = order_icons.get(order_name, null)
		if texture:
			var icon = TextureRect.new()
			icon.texture = texture
			icon.custom_minimum_size = Vector2(64, 64)
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			order_container.add_child(icon)
	
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value

func update_inventory():
	var max_slots = Global.get_max_slots()
	
	var inventory_slots = [inv_1, inv_2, inv_3, inv_4, inv_5]
	
	for i in range(5):
		if i < max_slots:
			inventory_slots[i].texture_normal = inv_icons.get(Global.handhelds[i], null)
			inventory_slots[i].visible = true
			if i == Global.selected_slot:
				inventory_slots[i].modulate = Color(1, 1, 1, 1)
			else:
				inventory_slots[i].modulate = Color(0.5, 0.5, 0.5, 1)
		else:
			inventory_slots[i].visible = false

func _on_timer_timeout() -> void:
	if Global.cafe_area == true:
		if time_left > 0:
			time_left -= 1
			time_label.text = str(int(time_left))
		elif time_left == 0:
			get_tree().change_scene_to_file("res://score.tscn")
			print("Time up!")
