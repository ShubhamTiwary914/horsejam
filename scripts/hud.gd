extends CanvasLayer

@onready var sceneNames = {
	0: "Shop",
	1: "Field",
	2: "Farm"
}

func _ready() -> void:
	pass

func sceneChange(sceneID: int) -> void:
	$sceneLabel.text = sceneNames[sceneID]
