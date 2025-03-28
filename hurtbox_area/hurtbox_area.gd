extends Area2D
class_name HurtboxArea



func _on_hitbox_area_entered(hitbox_area: HitboxArea) -> void:
	hitbox_area.emit_signal('hit')
	
