extends Sprite2D

@export var shop: Texture2D
@export var field: Texture2D
@export var farm: Texture2D

func set_ground_by_id(id: int) -> void:
	match id:
		0:
			texture = shop
		1:
			texture = field
		2:
			texture = farm
		_:
			return
	scale = Vector2(2, 2)
