extends Node2D

@export var horseScene : PackedScene
@export var initialHorsesCount : int = 2
@export var boundStart : Vector2 = Vector2(20, 150)
@export var boundEnd : Vector2 = Vector2(450, 610)
@export var center : Vector2 = Vector2(240,350)
@export var spawn_radius: float = 100.0

var horses: Array[Horse] = []

func _ready() -> void:
	for ctr in range(initialHorsesCount):
		_spawn_horse()

func _spawn_horse() -> void:
	if horseScene == null:
		return
	var horse = horseScene.instantiate() as Horse
	horse.area_top_left = boundStart
	horse.area_bottom_right = boundEnd
	#spawn position under radius "spawn_radius"	
	var angle := randf_range(0.0, TAU)
	var offset := Vector2(cos(angle), sin(angle)) * spawn_radius
	horse._setinit_position(center + offset)
	add_child(horse)
	horses.append(horse)
	
func pop_horse() -> void:
	if horses.is_empty():
		return
	var horse = horses.pop_back()
	if is_instance_valid(horse):
		horse.queue_free()
