# event_bus.gd
extends Node

# Сигнал: интенсивность и позиция источника
signal camera_shake(intensity: float, source_pos: Vector2)

# Функция для вызова тряски из любого места
func shake(intensity: float, source_pos: Vector2 = Vector2.ZERO):
	get_tree().root.get_node("EventBus").emit_signal("camera_shake", intensity, source_pos)
