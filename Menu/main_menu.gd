extends CanvasLayer

# 0 - 100
var sfx_volume: float = 100
var music_volume: float = 100

@onready var options_menu: Control = $OptionsMenu
@onready var help_menu: Control = $HelpMenu
@onready var block_main_menu: Control = $Block
@onready var sfx_slider: Slider = $OptionsMenu/MarginContainer/GridContainer/SFXSlider
@onready var music_slider: Slider = $OptionsMenu/MarginContainer/GridContainer/MusicSlider


func _ready():
	sfx_slider.value = sfx_volume
	music_slider.value = music_volume
	#music_player.volume_db = linear_to_db(music_volume / 100)
	#sfx_player.volume_db = linear_to_db(sfx_volume / 100)  


func _on_start_game_btn_pressed() -> void:
	print("The game has started!")
	# TODO: start the project


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
	sfx_volume = value
	#sfx_player.volume_db = linear_to_db(sfx_volume / 100)
	# TODO: change sfx volume


func _on_music_slider_value_changed(value: float) -> void:
	music_volume = value
	#music_player.volume_db = linear_to_db(music_volume / 100)
	# TODO: change music volume
