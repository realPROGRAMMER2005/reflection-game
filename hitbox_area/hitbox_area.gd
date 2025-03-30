extends Area2D
class_name HitboxArea

var group: String
var total_lifetime

signal hit


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile:
		if body.group != group or (body.sender == owner and body.total_lifetime >= 0.15 or body.ricocheted):
			emit_signal('hit', body.damage)
			body.emit_signal('hitbox_area_collided')


func _on_hurtbox_area_entered(hurtbox_area: HurtboxArea) -> void:
	hurtbox_area.emit_signal('hitbox_area_entered', self)

	


func _on_hurtbox_area_exited(hurtbox_area: HurtboxArea) -> void:
	hurtbox_area.emit_signal('hitbox_area_exited', self)
	
