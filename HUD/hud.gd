extends CanvasLayer


@onready var enemies_label: Label = $"MarginContainer/HBoxContainer/EnemiesCount"


func _ready() -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))

func _process(delta) -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))
