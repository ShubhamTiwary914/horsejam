extends Node2D

@export var boundStart : Vector2 = Vector2(120, 150)
@export var soilScene : PackedScene

@export var soilCols : int = 6
@export var soilCount: int = 30
@export var soilSize: Vector2 = Vector2(50, 50)
@export var gap: int = 0

var soils: Array[Soil] = []

func _ready() -> void:
	_generate_soil_grid()

func _spawn_soil_at(pos: Vector2) -> void:
	if soilScene == null:
		return
	var soil := soilScene.instantiate() as Soil
	soil.position = pos
	soil.set_soilID(soils.size())

	soil.plant.connect(_on_soil_plant)
	soil.harvest.connect(_on_soil_harvest)
	soil.water.connect(_on_soil_water)
	add_child(soil)
	soils.append(soil)
	
func _generate_one_soil() -> void:
	_spawn_soil_at(boundStart)

func _generate_soil_grid() -> void:
	if soilScene == null:
		return
	for i in range(soilCount):
		var col := i % soilCols
		var row := i / soilCols
		var pos := boundStart + Vector2(
			col * (soilSize.x + gap),
			row * (soilSize.y + gap)
		)
		_spawn_soil_at(pos)
		
func _on_soil_plant(id: int) -> void:
	pass

func _on_soil_harvest(id: int) -> void:
	pass

func _on_soil_water(id: int) -> void:
	pass
