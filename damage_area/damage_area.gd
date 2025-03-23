extends Area2D
class_name DamageArea

var hitbox_areas_to_damage: Array = []
var damage_groups: Array[String] = []
var damaged_hitboxes: Array[HitboxArea] = []

func _on_hitbox_area_entered(hitbox_area: HitboxArea) -> void:
	for damage_group in damage_groups:
		if hitbox_area.is_in_group(damage_group):
			hitbox_areas_to_damage.append(hitbox_area)


func _on_hitbox_area_exited(hitbox_area: HitboxArea) -> void:
	for i: int in range(len(hitbox_areas_to_damage)):
		if hitbox_areas_to_damage[i] == hitbox_area:
			hitbox_areas_to_damage.remove_at(i)
			break
	
