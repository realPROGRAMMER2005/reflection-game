extends CanvasLayer

@onready var options_menu: Control = $OptionsMenu
@onready var help_menu: Control = $HelpMenu
@onready var block_main_menu: Control = $Block
@onready var sfx_slider: Slider = $OptionsMenu/MarginContainer/GridContainer/SFXSlider
@onready var music_slider: Slider = $OptionsMenu/MarginContainer/GridContainer/MusicSlider
@onready var music_player: AudioStreamPlayer = $"../AudioStreamPlayer"
var level: PackedScene = preload("res://level/Level.tscn")
var hud: PackedScene = preload("res://HUD/hud.tscn")

var bgm_index: int = AudioServer.get_bus_index("BGM")
var sfx_index: int = AudioServer.get_bus_index("Master") 


func _ready():
	sfx_slider.value = Settings.sfx_volume
	music_slider.value = Settings.music_volume


func _on_start_game_btn_pressed() -> void:
	print("The game has started!")
	add_sibling(hud.instantiate())
	add_sibling(level.instantiate())
	queue_free()


func _on_options_btn_pressed() -> void:
	options_menu.visible = true
	block_main_menu.visible = true


func _on_help_btn_pressed() -> void:
	help_menu.visible = true
	block_main_menu.visible = true


func _on_options_exit_pressed() -> void:
	options_menu.visible = false
	block_main_menu.visible = false


func _on_help_exit_pressed() -> void:
	help_menu.visible = false
	block_main_menu.visible = false


func _on_sfx_slider_value_changed(value: float) -> void:
	Settings.sfx_volume = value
	var db: float = linear_to_db(Settings.music_volume / 100)
	AudioServer.set_bus_volume_db(sfx_index, db)

func _on_music_slider_value_changed(value: float) -> void:
	Settings.music_volume = value
	var db: float = linear_to_db(Settings.music_volume / 100)
	AudioServer.set_bus_volume_db(bgm_index, db)
