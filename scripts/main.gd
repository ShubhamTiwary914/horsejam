extends Node2D

@export var sceneID = 1
@export var fieldScene: PackedScene
@export var farmScene: PackedScene
@export var shopScene: PackedScene

var currentSceneInstance: Node2D = null

func _ready() -> void:
	$ground.set_ground_by_id(sceneID)
	$HUD.sceneChange(sceneID)
	moveScene(0)

func moveScene(step: int) -> void:
	sceneID += step
	#already at last - no change
	if(sceneID>2 || sceneID<0):
		sceneID = (2) if (sceneID>2) else (sceneID)
		sceneID = (0) if (sceneID<0) else (sceneID)
		return
	$ground.set_ground_by_id(sceneID)
	$HUD.sceneChange(sceneID)
	match sceneID:
		0:
			setSceneObject(shopScene)
			setScene_shop()
		1:
			setSceneObject(fieldScene)
			setScene_fields()
		2: 
			setSceneObject(farmScene)
			setScene_farm()
	
func setSceneObject(scene: PackedScene) -> void:
	if currentSceneInstance != null and is_instance_valid(currentSceneInstance):
		currentSceneInstance.queue_free()
	if scene == null:
		return
	currentSceneInstance = scene.instantiate()
	add_child(currentSceneInstance)
	
func setScene_fields() -> void:
	pass

func setScene_farm() -> void:
	pass
	
func setScene_shop() -> void:
	pass
	

func _on_prevbtn_pressed() -> void:
	moveScene(-1)

func _on_nextbtn_pressed() -> void:
	moveScene(1)
