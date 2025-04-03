extends Node2D
class_name CometSounds

@export var shoot_sound =  preload("res://sound/shot/shot.mp3")
@export var death_sound = preload("res://sound/glass_break/glass_break_0.mp3")

func play_shot_sound():
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = shoot_sound
	get_parent().get_parent().add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)

func play_death_sound():
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = death_sound
	get_parent().get_parent().add_child(audio_player)
	audio_player.play()
	audio_player.finished.connect(audio_player.queue_free)
