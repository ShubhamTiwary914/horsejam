class_name Soil
extends Area2D


# soil ID
@export var soil_id: int = 0
func set_soilID(v: int) -> void:
	soil_id = v
func get_soilID() -> int:
	return soil_id

#sprites for modes of soil {0,1,...5}
@export var grassPlainSprite : Texture2D
@export var soilPlainSprite : Texture2D
@export var soilSeededSprite0 : Texture2D
@export var soilSeededSprite1 : Texture2D
@export var soilSeededSprite2 : Texture2D
@export var soilSeededSprite3 : Texture2D

#config
@export var nextLevel_health: int = 3
@export var wateredTimer : int = 3
@onready var sprite: Sprite2D = $sprite
@onready var timer: Timer = $timer
@export var highlight_color: Color = Color(0.6, 0.8, 1.2, 1.0)
var is_hovered: bool = false

var soilMode = 0
var health: int = 0

const SOIL_MODE_NAMES := {
	"grass": 0,
	"soilplain": 1,
	"plant0": 2,
	"plant1": 3,
	"plant2": 4,
	"wheat": 5
}

func _ready() -> void:
	_update_sprite()
	
func _update_sprite() -> void:
	match soilMode:
		0:
			sprite.texture =  grassPlainSprite
		1:
			sprite.texture = soilPlainSprite
		2:
			sprite.texture = soilSeededSprite0
		3:
			sprite.texture = soilSeededSprite1
		4:
			sprite.texture = soilSeededSprite2
		5:
			sprite.texture = soilSeededSprite3
	_apply_highlight()


# EVENT ACTIONS -----------------------
#mouse click
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_handle_tool_action()

func _handle_tool_action() -> void:
	match Globals.selectedItemName:
		"hoe":
			if soilMode == SOIL_MODE_NAMES.grass:
				_till()
			elif soilMode == SOIL_MODE_NAMES.wheat:
				_harvest()
		"water":
			if soilMode >= SOIL_MODE_NAMES.plant0 and soilMode <= SOIL_MODE_NAMES.plant2:
				_water()
				_showlabel_updated()
		"seeds":
			if (
				soilMode == SOIL_MODE_NAMES.soilplain && 
				Globals.checkscene_itemscount(Globals.FARM_SCENE, "seeds") > 0
			):
				_plant()
			pass
		_:
			pass
	
func _till() -> void:
	soilMode = SOIL_MODE_NAMES.soilplain
	health = 0
	_update_sprite()
	timer.start()

func _harvest() -> void:
	soilMode = SOIL_MODE_NAMES.soilplain
	health = 0
	_update_sprite()
	timer.stop()
	Globals.increment_item_count(Globals.FARM_SCENE, 3)
	Globals.increment_item_count(Globals.FIELDS_SCENE, 0)

func _water() -> void:
	health += 1
	if health >= nextLevel_health and soilMode >= SOIL_MODE_NAMES.plant0 and soilMode <= SOIL_MODE_NAMES.plant2:
		health = 0
		soilMode += 1
		_update_sprite()

		# flash sprite light blue for wateredTimer seconds
		var original_color = sprite.modulate
		sprite.modulate = Color(0.6, 0.8, 1.0, 1.0)  # small blue
		var tmp_timer = Timer.new()
		tmp_timer.one_shot = true
		tmp_timer.wait_time = wateredTimer
		add_child(tmp_timer)
		tmp_timer.start()
		tmp_timer.timeout.connect(func() -> void:
			sprite.modulate = original_color
			tmp_timer.queue_free()
		)
		
func _plant():
	soilMode += 1
	_update_sprite()
	#reduce seeds count
	var sceneID = Globals.selectedSceneID
	var frameID = 2  # seeds frame
	Globals.decrement_item_count(sceneID, frameID)
	
func _apply_highlight() -> void:
	if is_hovered:
		sprite.modulate = highlight_color
	else:
		sprite.modulate = Color(1, 1, 1, 1)

func _on_mouse_entered() -> void:
	is_hovered = true
	_apply_highlight()
	var label = $label
	if label:
		match soilMode:
			SOIL_MODE_NAMES.grass:
				label.text = "plain grass"
			SOIL_MODE_NAMES.soilplain:
				label.text = "empty soil"
			SOIL_MODE_NAMES.plant0, SOIL_MODE_NAMES.plant1, SOIL_MODE_NAMES.plant2:
				_showlabel_updated()
			SOIL_MODE_NAMES.wheat:
				label.text = "wheat"
		label.show()

func _showlabel_updated():
	$label.show()
	$label.text = "water: %d" % health


func _on_mouse_exited() -> void:
	is_hovered = false
	_apply_highlight()
	$label.hide()
