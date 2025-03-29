extends CharacterBody2D
class_name Character

@export var group: String = 'bad_comet'

@export var controlled_by_player: bool = false

@export var speed: float = 45


@export var max_health: int = 1
var current_health: int = max_health

@export var projectile_scene: PackedScene

@export var fire_rate: float = 0.3
var fire_rate_timer: float = 0

@onready var hitbox_area: HitboxArea = get_node("HitboxArea")
@onready var muzzle: Muzzle = get_node("Muzzle")
@onready var visuals: Node2D = get_node("CometVisuals")

var aiming_angle

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
	
func _physics_process(delta: float) -> void:
	handle_fire_rate(delta)
	handle_player_controls()
	

	
	
	move_and_slide()
	visuals.global_rotation = aiming_angle


func _ready() -> void:
	hitbox_area.connect("hit", on_hit)
	hitbox_area.group = group

func on_hit(damage):
	get_damage(damage)

func get_damage(damage):
	current_health -= damage
	if current_health <= 0:
		die()
		
func die():
	queue_free()

func shoot():
	if check_can_shoot():
		fire_rate_timer = 0
		
		var projectile_instance: Projectile = projectile_scene.instantiate()
		projectile_instance.group = group
		projectile_instance.sender = self
		get_parent().add_child(projectile_instance)
		projectile_instance.global_position = muzzle.global_position
		projectile_instance.global_rotation = muzzle.global_rotation
		projectile_instance.direction = muzzle.global_transform.x.normalized()
		
