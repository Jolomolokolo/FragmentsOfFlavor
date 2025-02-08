extends CanvasLayer

signal dead

@onready var cash_label = $CashLabel
@onready var texture_rect = $TextureRect
@onready var order_container = $ScrollContainer/VBoxContainer
@onready var order_bg = $ColorRect

@onready var inv_1 = $Inventory/Inv1
@onready var inv_2 = $Inventory/Inv2

@onready var time = $Timer
@onready var time_label = $TimeLabel
var time_left: float = 600

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
	update_cash_display()
	update_heath_display()
	update_orders()
	
	if Input.is_action_just_pressed("ui_swap"):
		Global.switch_handheld()
	elif Input.is_action_just_pressed("1"):
		Global.select_handheld(1)
	elif Input.is_action_just_pressed("2"):
		Global.select_handheld(2)
	
	if Input.is_action_just_pressed("scroll_up"):
		Global.select_next_handheld()
	elif Input.is_action_just_pressed("scroll_down"):
		Global.select_previous_handheld()
	
	update_inventory()

func update_cash_display():
	cash_label.text = "Cash: " + str(Global.cash)

func update_heath_display():
	if Global.health <= 0:
		dead.emit()
	elif Global.health <= 20:
		texture_rect.texture = emoji_bad
	elif  Global.health >= 21 and Global.health <= 69:
		texture_rect.texture = emoji_middle
	elif Global.health >= 70:
		texture_rect.texture = emoji_good

func _on_dead() -> void:
	get_tree().change_scene_to_file("res://dead.tscn")
	print("DEAD")

func update_orders():
	#$ScrollContainer.get_v_scroll_bar().visible = false # Geht nicht
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
	inv_1.texture_normal = inv_icons.get(Global.handheld, null)
	inv_2.texture_normal = inv_icons.get(Global.handheld_2, null)
	
	inv_1.modulate = Color(1, 1, 1, 1) if Global.handheld_selected_main else Color(0.5, 0.5, 0.5, 1)
	inv_2.modulate = Color(1, 1, 1, 1) if not Global.handheld_selected_main else Color(0.5, 0.5, 0.5, 1)

func _on_timer_timeout() -> void:
	if time_left > 0:
		time_left -= 1
		time_label.text = str(time_left)
	elif time_left == 0:
		get_tree().change_scene_to_file("res://score.tscn")
		print("Time up!")
