extends CanvasLayer


@onready var enemies_label: Label = $"MarginContainer/HBoxContainer/EnemiesCount"
@onready var screen_title_label: Label = $"ScreenTitleContainer/Label"
@onready var screen_subtitle_label: Label = $ScreenSubtitleContainer/Label
@onready var level_label: Label = $"LevelContainer/Level"

var player_died: bool = false

var wait_for_accept: bool = false

func _ready() -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))
	level_label.text = "Level " + str(Settings.level_difficulty)
	
	EventBus.restart.connect(on_restart)
	EventBus.player_died.connect(on_player_died)
	EventBus.level_cleared.connect(on_level_cleared)

func _process(delta) -> void:
	enemies_label.text = (str(Settings.kills) + 
		"/" + str(Settings.enemies_count))
	level_label.text = "Level " + str(Settings.level_difficulty)
	
	handle_accept()

func on_player_died():
	screen_title_label.text = "DEAD"
	screen_title_label.self_modulate = Color.RED
	
	screen_subtitle_label.text = "Press SPACE to Return to Restart"
	screen_subtitle_label.self_modulate = Color.YELLOW
	
	wait_for_accept = true
	player_died = true

func handle_accept():
	

	
	if wait_for_accept:
		if Input.is_action_just_pressed("ui_accept"):
			if player_died:
				EventBus.on_restart()
				clear_title()
				clear_subtitle()
			else:
				EventBus.on_level_change()
				clear_title()
				clear_subtitle()
			wait_for_accept = false
				

func clear_title():
	screen_title_label.text = ""
	screen_title_label.self_modulate = Color.TRANSPARENT
	
func clear_subtitle():
	screen_subtitle_label.text = ""
	screen_subtitle_label.self_modulate = Color.TRANSPARENT

func on_level_cleared():
	screen_title_label.text = "CLEARED"
	screen_title_label.self_modulate = Color.GREEN
	
	screen_subtitle_label.text = "Press SPACE to Proceed"
	screen_subtitle_label.self_modulate = Color.YELLOW
	
	wait_for_accept = true
	player_died = false

func on_restart():
	clear_subtitle()
	clear_title()
	wait_for_accept = false
	player_died = false
