extends Node

const framesPerScene = 4
const sceneCount: int = 3

var selectedItemName: String = "none"
# sceneID -> array of frames
var sceneFrames: Dictionary = {}
# sceneID -> array of items {name: String, sprite: Texture2D, count: int}
var sceneItems: Dictionary = {}

var selectedSceneID: int = 0
var selectedItemID: int = -1

const SHOP_SCENE = 0
const FIELDS_SCENE = 1
const FARM_SCENE = 2


# add/update an item
func add_item(sceneID: int, frameID: int, sprite: Texture2D, name: String, count: int = 1) -> void:
	if sceneID >= sceneCount or frameID >= framesPerScene:
		return
	sceneItems[sceneID][frameID] = {"name": name, "sprite": sprite, "count": count}
	# update frame if currently active scene
	if sceneID == selectedSceneID:
		_update_frame_node(sceneID, frameID)

# increment/decrement item counts
func increment_item_count(sceneID: int, frameID: int, delta: int = 1) -> void:
	var data = sceneItems[sceneID][frameID]
	if data:
		data.count += delta
		if sceneID == selectedSceneID:
			_update_frame_node(sceneID, frameID)

func decrement_item_count(sceneID: int, frameID: int, delta: int = 1) -> void:
	var data = sceneItems[sceneID][frameID]
	if data:
		data.count = max(0, data.count - delta)
		if sceneID == selectedSceneID:
			_update_frame_node(sceneID, frameID)

# check for existence
func checkscene_hasitem(sceneID: int, itemName: String) -> bool:
	for data in sceneItems[sceneID]:
		if data and data.name == itemName:
			return true
	return false

# get count
func checkscene_itemscount(sceneID: int, itemName: String) -> int:
	for data in sceneItems[sceneID]:
		if data and data.name == itemName:
			return data.count
	return 0

# select an item in the hotbar
func select_item(frameID: int) -> void:
	for frame in sceneFrames[selectedSceneID]:
		if frame.itemframeID != frameID:
			frame._on_unselect()
	selectedItemID = frameID
	var data = sceneItems[selectedSceneID][frameID]
	if data:
		selectedItemName = data.name
	else:
		selectedItemName = "none"
		
# set the count of an item directly
func set_item_count(sceneID: int, frameID: int, count: int) -> void:
	if sceneID >= sceneCount or frameID >= framesPerScene:
		return
	var data = sceneItems[sceneID][frameID]
	if data:
		data.count = count
		if sceneID == selectedSceneID:
			_update_frame_node(sceneID, frameID)
		

# change scene
func change_scene(sceneID: int) -> void:
	selectedSceneID = sceneID
	selectedItemID = -1
	selectedItemName = "none"
	# refresh visible frames
	for i in range(framesPerScene):
		_update_frame_node(sceneID, i)

# internal helper to update a node from item data
func _update_frame_node(sceneID: int, frameID: int) -> void:
	var frame = sceneFrames[sceneID][frameID]
	var data = sceneItems[sceneID][frameID]
	frame._on_unselect()
	if data:
		frame.itemSprite.texture = data.sprite
		update_frame_label(frame, data.name, data.count)
	else:
		frame.itemSprite.texture = null
		frame.frameSprite.texture = frame.frameUnselected
		var label = frame.get_node_or_null("itemname")
		if label:
			label.text = ""
			

# update the label of a frame
func update_frame_label(frame, name: String, count: int) -> void:
	var label = frame.get_node_or_null("itemname")
	if label:
		label.text = name if count == 1 else "%s(%d)" % [name, count]
		
