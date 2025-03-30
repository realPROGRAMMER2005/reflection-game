extends Node2D
class_name ProjectileVisuals

@export var projectile_color: Color = Color.from_rgba8(500, 500, 500)
@export var impact_particles_scene: PackedScene = load("res://particles/ImpactParticles.tscn")


func apply_color():
	var projectile_parts: Array = get_node("Parts").get_children()
	for projectile_part in projectile_parts:
		projectile_part.self_modulate = projectile_color

func spawn_impact_particles(args: Dictionary = {}):
	var impact_particles_instance: CPUParticles2D = impact_particles_scene.instantiate()
	for key in args.keys():
		impact_particles_instance.set(key, args.get(key))
	get_parent().get_parent().add_child(impact_particles_instance)
	impact_particles_instance.self_modulate = projectile_color
	impact_particles_instance.global_position = global_position
	
	impact_particles_instance.emitting = true
	
		
		
	
	
	
	
	
func _ready() -> void:
	apply_color()
