extends Area2D
class_name DetectionArea

var group: String

signal enemy_entered

func _ready() -> void:
	pass

func _on_character_entered(character: Character) -> void:
	if character.group != group:
		emit_signal('enemy_entered', character)
