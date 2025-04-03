extends AudioStreamPlayer


const MAIN_MENU: int = 0
const IN_GAME: int = 1

var menu_theme: String = "res://sound/music/music.mp3"
var game_music_list: Array = [
	"res://sound/music/music.mp3",
	"res://sound/music/music2.mp3",
]
var curr_music_index: int = 0
var state: int = MAIN_MENU


func _ready() -> void:
	play()


func _on_finished() -> void:
	if state == MAIN_MENU:
		play()
	elif state == IN_GAME:
		print("State is in_game")
		var new_index: int = randi_range(0, max(0, len(game_music_list) - 2))
		if new_index >= curr_music_index:
			new_index += 1
		curr_music_index = new_index
		print(curr_music_index)
		stream = load(game_music_list[new_index])
		play()


func set_new_state(new_state: int) -> void:
	state = new_state
	stop()
	_on_finished()
