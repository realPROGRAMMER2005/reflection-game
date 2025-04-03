# event_bus.gd
extends Node

signal camera_shake(intensity: float, source_pos: Vector2)
signal player_died()
signal restart()
signal level_cleared()
signal level_change()

var has_player_died: bool = false
var has_level_cleared: bool = false

# Функция для вызова тряски из любого места
func shake(intensity: float, source_pos: Vector2 = Vector2.ZERO):
	get_tree().root.get_node("EventBus").emit_signal("camera_shake", intensity, source_pos)

func on_player_died():
	get_tree().root.get_node("EventBus").emit_signal("player_died")
	has_player_died = true


func on_restart():
	get_tree().root.get_node("EventBus").emit_signal("restart")
	has_player_died = false

func on_level_cleared():
	get_tree().root.get_node("EventBus").emit_signal("level_cleared")
	has_level_cleared = true

func on_level_change():
	get_tree().root.get_node("EventBus").emit_signal("level_change")
	has_level_cleared = false
