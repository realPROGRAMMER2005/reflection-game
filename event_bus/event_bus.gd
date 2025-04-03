# event_bus.gd
extends Node

signal camera_shake(intensity: float, source_pos: Vector2)
signal player_died()

# Функция для вызова тряски из любого места
func shake(intensity: float, source_pos: Vector2 = Vector2.ZERO):
	get_tree().root.get_node("EventBus").emit_signal("camera_shake", intensity, source_pos)

func on_player_died():
	get_tree().root.get_node("EventBus").emit_signal("player_died")
	
