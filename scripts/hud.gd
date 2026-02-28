extends CanvasLayer

@onready var sceneNames = {
	0: "Shop",
	1: "Field",
	2: "Farm"
}
@onready var sceneLabel = $sceneLabel
@onready var hotbar = $hotbar

@export var frameSize: Vector2 = Vector2(64, 64)
@export var gap: int = 3
@export var startPos: Vector2 = Vector2(10, 10)
@export var itemframeScene : PackedScene

func _ready() -> void:
	# instantiate hotbar frames
	for i in range(Globals.framesPerScene):
		var frame = itemframeScene.instantiate()
		frame.position = startPos + Vector2(i * (frameSize.x + gap), 0)
		hotbar.add_child(frame)
		frame.itemframeID = i
		frame.selected.connect(_on_item_selected)
		frame._on_unselect()

	# initialize Globals dictionaries
	for sceneID in range(Globals.sceneCount):
		Globals.sceneFrames[sceneID] = []
		Globals.sceneItems[sceneID] = []
		for i in range(Globals.framesPerScene):
			Globals.sceneFrames[sceneID].append(hotbar.get_child(i))
			Globals.sceneItems[sceneID].append(null)
	# set initial scene
	change_scene(0)
	
func init_hotbar(sceneID: int, sceneDefaultHotbar: Dictionary[String, ItemData]) -> void:
	for itemName in sceneDefaultHotbar.keys():
		var data: ItemData = sceneDefaultHotbar[itemName]
		Globals.add_item(sceneID, data.frameID, data.itemtexture, itemName, data.count)

func change_scene(sceneID: int) -> void:
	sceneLabel.text = sceneNames[sceneID]
	Globals.change_scene(sceneID)

func _on_item_selected(itemframeID: int) -> void:
	Globals.select_item(itemframeID)
