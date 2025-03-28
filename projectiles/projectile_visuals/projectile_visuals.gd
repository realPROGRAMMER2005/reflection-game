extends Node2D
class_name ProjectileVisuals

@export var projectile_color: Color = Color.from_rgba8(500, 500, 500)


func apply_color():
	var projectile_parts: Array = get_node("Parts").get_children()
	for projectile_part in projectile_parts:
		projectile_part.color = projectile_color
	
func _ready() -> void:
	apply_color()
