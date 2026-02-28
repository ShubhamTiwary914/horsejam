extends Node2D

@export var sceneID = 1

func _ready() -> void:
	$ground.set_ground_by_id(sceneID)
	$HUD.sceneChange(sceneID)

func moveScene(step: int) -> void:
	sceneID += step
	sceneID = (2) if (sceneID>=2) else (sceneID)
	sceneID = (0) if (sceneID<=0) else (sceneID)
	$ground.set_ground_by_id(sceneID)
	$HUD.sceneChange(sceneID)

func _on_prevbtn_pressed() -> void:
	moveScene(-1)

func _on_nextbtn_pressed() -> void:
	moveScene(1)
