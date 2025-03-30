extends Area2D
class_name HurtboxArea

signal hitbox_area_entered
signal hurtbox_area_exited

var hitboxes_in_area: Array[HitboxArea]

func _ready() -> void:
	connect('hitbox_area_entered', on_hitbox_area_entered)
	connect('hitbox_area_exited', on_hitbox_area_exited)

func hurt():
	for hitbox_area in hitboxes_in_area:
		hitbox_area.emit_signal('hit')

func on_hitbox_area_entered(hitbox_area: HitboxArea):
	hitboxes_in_area.append(hitbox_area)

func on_hitbox_area_exited(hitbox_area: HitboxArea):
	hitboxes_in_area.remove_at(hitboxes_in_area.find(hitbox_area))
