extends Sprite2D
@export var tilemap: TileMap
@export var tile_coords: Vector2i  # Die Tile-Koordinaten des Tiles, auf dem das Area2D platziert werden soll

func _ready():
	if tilemap:
		# Position des Tiles in Weltkoordinaten ermitteln
		var world_position = tilemap.map_to_world(tile_coords)
		
		# Die tatsächliche Tile-Größe von der TileMap holen
		var tile_size = tilemap.cell_size
		
		# Das Area2D mittig auf dem Tile platzieren
		position = world_position + tile_size / 2
