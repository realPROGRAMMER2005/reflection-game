extends StaticBody2D
class_name Wall

@export var wall_color: Color = Color.DIM_GRAY

@export var impact_particles_scene: PackedScene = load("res://particles/ImpactParticles.tscn")



@onready var polygon: Polygon2D = get_node("Polygon2D")
@onready var collision_polygon: CollisionPolygon2D = get_node("CollisionPolygon2D")

signal projectile_collided
	
func apply_color():
	if polygon:
		polygon.self_modulate = wall_color

func apply_collision_polygon_to_match_polygon():
	if polygon and collision_polygon:
		collision_polygon.polygon = polygon.polygon

func _ready() -> void:
	apply_color()
	apply_collision_polygon_to_match_polygon()
	connect('projectile_collided', on_projectile_collided)

func spawn_impact_particles(pos: Vector2):
	var impact_particles_instance: CPUParticles2D = impact_particles_scene.instantiate()
	impact_particles_instance.self_modulate = wall_color
	impact_particles_instance.amount = 10
	impact_particles_instance.initial_velocity_max = 15
	get_parent().add_child(impact_particles_instance)
	impact_particles_instance.global_position = pos
	impact_particles_instance.emitting = true


func on_projectile_collided(pos: Vector2):
	spawn_impact_particles(pos)
