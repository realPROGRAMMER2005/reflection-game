extends StaticBody2D
class_name Wall

@export var wall_color: Color = Color.DIM_GRAY
@export var break_sound = preload("res://sound/rock_break/rock_break.mp3")
@export var max_health: int = 3
var current_health: int
@export var destructable: bool = true

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
	current_health = max_health
	apply_color()
	apply_collision_polygon_to_match_polygon()
	connect('projectile_collided', on_projectile_collided)

func spawn_impact_particles(pos: Vector2, args = {}):
	var impact_particles_instance: CPUParticles2D = impact_particles_scene.instantiate()
	impact_particles_instance.self_modulate = wall_color
	impact_particles_instance.amount = 10
	
	for key in args.keys():
		impact_particles_instance.set(key, args.get(key))
	
	
	get_parent().add_child(impact_particles_instance)
	impact_particles_instance.global_position = pos
	impact_particles_instance.emitting = true




func on_projectile_collided(pos: Vector2, damage: int):
	spawn_impact_particles(pos)
	get_damage(damage)

func get_damage(damage):
	
	if destructable:
		current_health -= damage
		if current_health <= 0:
			die()


func die():
	spawn_impact_particles(global_position, {"amount": 100})
	play_break_sound()
	EventBus.shake(0.8, global_position)
	queue_free()

func play_break_sound():
	var audio_player = AudioStreamPlayer2D.new()
	audio_player.stream = break_sound
	audio_player.bus = "SFX"
	get_parent().add_child(audio_player)
	audio_player.play()
