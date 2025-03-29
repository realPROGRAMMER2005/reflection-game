extends Area2D
class_name HitboxArea

var group: String
var total_lifetime

signal hit


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile:
		if body.group != group or (body.sender == owner and body.total_lifetime >= 0.15):
			emit_signal('hit', body.damage)
			body.emit_signal('hitbox_area_collided')
