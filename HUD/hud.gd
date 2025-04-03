extends CanvasLayer


@onready var enemies_label: Label = $"MarginContainer/HBoxContainer/EnemiesCount"
@onready var screen_title_label: Label = $"ScreenTitleContainer/Label"
@onready var screen_subtitle_label: Label = $ScreenSubtitleContainer/Label

var wait_for_accept: bool = false

func _ready() -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))
	
	EventBus.player_died.connect(on_player_died)

func _process(delta) -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))

func on_player_died():
	screen_title_label.text = "DEAD"
	screen_title_label.self_modulate = Color.RED
	
	screen_subtitle_label.text = "Press SPACE to Return to Menu"
	screen_subtitle_label.self_modulate = Color.YELLOW
