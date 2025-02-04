extends CanvasLayer

signal dead

@onready var cash_label = $CashLabel
@onready var texture_rect = $TextureRect
@onready var order_container = $ScrollContainer/VBoxContainer

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

func _ready():
	update_cash_display()
	update_heath_display()
	update_orders()

func _process(_delta):
	update_cash_display()
	update_heath_display()
	update_orders()

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
	
	for order_name in Global.orders:
		var texture = order_icons.get(order_name, null)

		if texture:
			var icon = TextureRect.new()
			icon.texture = texture
			icon.custom_minimum_size = Vector2(64, 64)
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
			order_container.add_child(icon)
	
	$ScrollContainer.scroll_vertical = $ScrollContainer.get_v_scroll_bar().max_value
