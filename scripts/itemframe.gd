extends Area2D

signal selected(itemframeID: int)

@export var itemframeID: int = 0
@onready var frameSprite: Sprite2D = $framesprite
@onready var itemSprite: Sprite2D = $itemsprite

@export var frameUnselected: Texture2D
@export var frameSelected: Texture2D

var isSelected: bool = false

func _ready() -> void:
	_update_frame()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_select()

func _select() -> void:
	isSelected = true
	_update_frame()
	emit_signal("selected", itemframeID)

func _on_unselect() -> void:
	isSelected = false
	_update_frame()

func _update_frame() -> void:
	frameSprite.texture = frameSelected if isSelected else frameUnselected
