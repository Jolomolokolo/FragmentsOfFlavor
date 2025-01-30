extends Area2D

@export var tilemap: TileMap
@export var tile_coords: Vector2i  # Die Tile-Koordinaten des Tiles, auf dem das Area2D platziert werden soll
@export var layer_index: int = 1   # Der Layer, auf dem das Tile liegt (z.B. Layer 2)

func _ready():
	if tilemap:
		# Stelle sicher, dass wir die Position im richtigen Layer berechnen
		# Die Position des Tiles in Weltkoordinaten für den angegebenen Layer ermitteln
		var world_position = tilemap.map_to_world(tile_coords, layer_index)
		
		# Die tatsächliche Tile-Größe von der TileMap holen
		var tile_size = tilemap.cell_size
		
		# Das Area2D mittig auf dem Tile platzieren
		position = world_position + tile_size / 2
