extends Node2D
class_name ProjectileVisuals

@export var projectile_color: Color = Color.from_rgba8(500, 500, 500)
@export var destoy_partciles_scene: PackedScene


func apply_color():
	var projectile_parts: Array = get_node("Parts").get_children()
	for projectile_part in projectile_parts:
		projectile_part.self_modulate = projectile_color

func spawn_destroy_particles(args: Dictionary = {}):
	var destoy_partciles_instance: CPUParticles2D = destoy_partciles_scene.instantiate()
	for key in args.keys():
		destoy_partciles_instance.set(key, args.get(key))
	get_parent().get_parent().add_child(destoy_partciles_instance)
	destoy_partciles_instance.self_modulate = projectile_color
	destoy_partciles_instance.global_position = global_position
	
	destoy_partciles_instance.emitting = true
	
		
		
	
	
	
	
	
func _ready() -> void:
	apply_color()
