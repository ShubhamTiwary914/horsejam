extends CanvasLayer

@onready var sceneNames = {
	0: "Shop",
	1: "Fields",
	2: "Farm"
}

func _ready() -> void:
	pass

func sceneChange(sceneID) -> void:
	$sceneLabel.text = sceneNames[sceneID]
