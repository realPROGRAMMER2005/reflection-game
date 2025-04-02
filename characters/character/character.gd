extends CharacterBody2D
class_name Character

@export var group: String = 'bad_comet'
@export var controlled_by_player: bool = false
@export var speed: float = 45
@export var type_variation: bool = false
@export var max_health: int = 1
var current_health: int
@export var projectile_scene: PackedScene
@export var fire_rate: float = 0.3
var fire_rate_timer: float = 0

@onready var detection_area: DetectionArea = get_node("DetectionArea")
@onready var hitbox_area: HitboxArea = get_node("HitboxArea")
@onready var muzzle: Muzzle = get_node("Muzzle")
@onready var visuals: Node2D = get_node("CometVisuals")
@onready var navigation_agent: NavigationAgent2D = get_node("NavigationAgent2D")
@onready var raycast: RayCast2D = get_node("RayCast2D")

@export var impact_particles_scene: PackedScene = load("res://particles/ImpactParticles.tscn")

var aiming_angle: float = 0
var target: Character

enum AIStates {STAY, PATROL, FOLLOW}
var current_ai_state: AIStates = AIStates.STAY

func _ready() -> void:
	if type_variation:
		var size_scale = randf_range(0.6, 3)
		max_health = max_health * size_scale
		speed = speed / size_scale
		scale = Vector2(size_scale, size_scale)
	
	current_health = max_health
	hitbox_area.connect("hit", on_hit)
	hitbox_area.group = group
	detection_area.connect('enemy_entered', on_enemy_entered_detection_area)
	navigation_agent.path_desired_distance = 10.0
	navigation_agent.target_desired_distance = 50.0
	
	# Настройка RayCast2D
	if not raycast:
		raycast = RayCast2D.new()
		add_child(raycast)
		raycast.name = "RayCast2D"
	raycast.enabled = true
	raycast.collide_with_areas = false
	raycast.collide_with_bodies = true
	raycast.collision_mask = 1  # Установите нужный слой для стен

func _physics_process(delta: float) -> void:
	handle_fire_rate(delta)
	handle_player_controls()
	handle_ai()
	move_and_slide()
	visuals.global_rotation = aiming_angle

func check_can_shoot():
	return fire_rate_timer >= fire_rate

func handle_fire_rate(delta):
	fire_rate_timer += delta

func handle_player_controls():
	if controlled_by_player: 
		var mouse_pos = get_global_mouse_position()
		var direction_to_mouse = (mouse_pos - global_position).normalized()
		aiming_angle = Vector2.RIGHT.angle_to(direction_to_mouse)
		var move_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		
		velocity = move_direction * speed
		muzzle.global_rotation = aiming_angle
		
		if Input.is_action_pressed("attack"):
			shoot()

func handle_ai():
	if not controlled_by_player:
		if current_ai_state == AIStates.STAY:
			handle_ai_stay()
		elif current_ai_state == AIStates.PATROL:
			handle_ai_patrol()
		elif current_ai_state == AIStates.FOLLOW:
			handle_ai_follow()

func handle_ai_stay():
	velocity = Vector2.ZERO

func handle_ai_patrol():
	pass

func handle_ai_follow():
	if target:
		# Устанавливаем цель для NavigationAgent2D
		navigation_agent.set_target_position(target.global_position)
		
		# Получаем следующую точку пути
		var next_path_position = navigation_agent.get_next_path_position()
		var direction = (next_path_position - global_position).normalized()
		
		# Двигаемся к цели
		velocity = direction * speed
		
		var direction_to_target = (target.global_position - global_position).normalized()
		aiming_angle = direction_to_target.angle()
		muzzle.global_rotation = aiming_angle
		
		raycast.target_position = to_local(target.global_position)
		raycast.force_raycast_update()  
		
		if not raycast.is_colliding():
			shoot()



func on_enemy_entered_detection_area(enemy: Character):
	if enemy.controlled_by_player:
		target = enemy
		current_ai_state = AIStates.FOLLOW

func on_hit(damage):
	get_damage(damage)

func get_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()

func die():
	spawn_impact_particles()
	EventBus.shake(5, global_position)
	queue_free()

func shoot():
	if check_can_shoot():
		fire_rate_timer = 0
		
		EventBus.shake(0.5, global_position)
		
		var projectile_instance: Projectile = projectile_scene.instantiate()
		projectile_instance.group = group
		projectile_instance.sender = self
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = muzzle.global_position
		projectile_instance.global_rotation = muzzle.global_rotation
		projectile_instance.direction = muzzle.global_transform.x.normalized()
		

func spawn_impact_particles(args: Dictionary = {}):
	var impact_particles_instance: CPUParticles2D = impact_particles_scene.instantiate()
	for key in args.keys():
		impact_particles_instance.set(key, args.get(key))
	get_parent().get_parent().add_child(impact_particles_instance)
	impact_particles_instance.self_modulate = visuals.comet_color
	impact_particles_instance.global_position = global_position
	
	impact_particles_instance.emitting = true
